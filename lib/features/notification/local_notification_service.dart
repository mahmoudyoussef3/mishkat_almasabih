import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:easy_notify/easy_notify.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

// Data model
class ApiData {
  final int id;
  final String title;
  final String body;
  final DateTime fetchedAt;

  ApiData({
    required this.id,
    required this.title,
    required this.body,
    required this.fetchedAt,
  });

  factory ApiData.fromJson(Map<String, dynamic> json) {
    return ApiData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      fetchedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'fetchedAt': fetchedAt.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'ApiData(id: $id, title: $title, fetchedAt: $fetchedAt)';
  }
}

// Service class for cyclic operations
class CyclicDataService {
  static const int CYCLIC_ALARM_ID = 2001;
  static const String API_URL = 'https://jsonplaceholder.typicode.com/posts';
  static const String CACHE_BOX = 'cyclic_data_box';
  static const String CACHE_KEY = 'current_data';
  
  static Box<Map>? _dataBox;
  static Timer? _cleanupTimer;

  /// Initialize the service
  static Future<bool> initialize() async {
    try {
      // Initialize Hive box
      _dataBox = await Hive.openBox<Map>(CACHE_BOX);
      
      // Initialize Android Alarm Manager
      await AndroidAlarmManager.initialize();
      
      log('CyclicDataService initialized successfully');
      return true;
    } catch (e) {
      log('Failed to initialize CyclicDataService: $e');
      return false;
    }
  }

  /// Start the cyclic process
/// Start the cyclic process
static Future<bool> startCyclicProcess() async {
  try {
    // Start immediately
    await _performCycle();
    
    // Schedule periodic execution every 10 seconds
    await AndroidAlarmManager.periodic(
      const Duration(seconds: 10),
      CYCLIC_ALARM_ID,
      cyclicCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: false,
    );

    log('Cyclic process started');
    return true;
  } catch (e) {
    log('Failed to start cyclic process: $e');
    return false;
  }
}


  /// Stop the cyclic process
  static Future<bool> stopCyclicProcess() async {
    try {
      _cleanupTimer?.cancel();
      final cancelled = await AndroidAlarmManager.cancel(CYCLIC_ALARM_ID);
      log('Cyclic process stopped: $cancelled');
      return cancelled;
    } catch (e) {
      log('Failed to stop cyclic process: $e');
      return false;
    }
  }

  /// Fetch data from API
  static Future<ApiData?> _fetchFromApi() async {
    try {
      log('Fetching data from API...');
      
      final response = await http.get(
        Uri.parse('$API_URL/1'), // Fetch post with id 1
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final apiData = ApiData.fromJson(jsonData);
        
        log('API data fetched successfully: ${apiData.title}');
        return apiData;
      } else {
        log('API request failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Error fetching from API: $e');
      return null;
    }
  }

  /// Save data to local storage
  static Future<bool> _saveToLocal(ApiData data) async {
    try {
      if (_dataBox == null) {
        _dataBox = await Hive.openBox<Map>(CACHE_BOX);
      }

      await _dataBox!.put(CACHE_KEY, data.toJson());
      log('Data saved to local storage: ${data.title}');
      return true;
    } catch (e) {
      log('Error saving to local storage: $e');
      return false;
    }
  }

  /// Get data from local storage
  static Future<ApiData?> getFromLocal() async {
    try {
      if (_dataBox == null) {
        _dataBox = await Hive.openBox<Map>(CACHE_BOX);
      }

      final cachedData = _dataBox!.get(CACHE_KEY);
      if (cachedData != null) {
        final data = ApiData.fromJson(Map<String, dynamic>.from(cachedData));
        log('Data retrieved from local storage: ${data.title}');
        return data;
      } else {
        log('No data found in local storage');
        return null;
      }
    } catch (e) {
      log('Error getting from local storage: $e');
      return null;
    }
  }

  /// Remove data from local storage
  static Future<bool> _removeFromLocal() async {
    try {
      if (_dataBox == null) {
        _dataBox = await Hive.openBox<Map>(CACHE_BOX);
      }

      await _dataBox!.delete(CACHE_KEY);
      log('Data removed from local storage');
      return true;
    } catch (e) {
      log('Error removing from local storage: $e');
      return false;
    }
  }

// Only show repeated notifications; no cancellation
static Future<void> _showNotification(ApiData data) async {
  try {
    await EasyNotify.showRepeatedNotification(
      id: data.id,
      title: 'Data Updated',
      body: data.title.length > 30
          ? '${data.title.substring(0, 30)}...'
          : data.title,
    );
    log('Notification shown for: ${data.title}');
  } catch (e) {
    log('Error showing notification: $e');
  }
}


  /// Perform one complete cycle
  static Future<void> _performCycle() async {
    try {
      log('=== Starting new cycle at ${DateTime.now()} ===');
      
      // Step 1: Get data from API
      final apiData = await _fetchFromApi();
      if (apiData == null) {
        log('Failed to fetch data from API, ending cycle');
        return;
      }

      // Step 2: Show notification
      await _showNotification(apiData);

      // Step 3: Save data locally
      await _saveToLocal(apiData);

      // Step 4: Show saved data (this would typically update UI)
      final savedData = await getFromLocal();
      if (savedData != null) {
        log('Currently saved data: ${savedData.toString()}');
      }

      // Step 5: Schedule cleanup after 10 seconds
      // Note: In the alarm callback, we'll remove and fetch again
      
      log('=== Cycle completed at ${DateTime.now()} ===');
    } catch (e) {
      log('Error in cycle: $e');
    }
  }

  /// Get current data status for UI
  static Future<Map<String, dynamic>> getDataStatus() async {
    final localData = await getFromLocal();
    return {
      'hasData': localData != null,
      'data': localData,
      'lastUpdate': localData?.fetchedAt,
    };
  }

  /// Manual trigger for testing
  static Future<void> triggerManualCycle() async {
    await _performCycle();
  }
}

// Callback function for alarm manager - must be top-level
@pragma('vm:entry-point')
void cyclicCallback(int id) async {
  try {
    while (true) {
      // 1. Fetch data
      final apiData = await CyclicDataService._fetchFromApi();
      if (apiData != null) {
        // Show notification
        await CyclicDataService._showNotification(apiData);
        // Save data locally
        await CyclicDataService._saveToLocal(apiData);
      }

      // 2. Wait 10 seconds
      await Future.delayed(const Duration(seconds: 10));

      // 3. Remove local data
      await CyclicDataService._removeFromLocal();
    }
  } catch (e) {
    log('Error in cyclic loop: $e');
  }
}


// Widget to display and control the cyclic service
class CyclicDataWidget extends StatefulWidget {
  const CyclicDataWidget({Key? key}) : super(key: key);

  @override
  State<CyclicDataWidget> createState() => _CyclicDataWidgetState();
}

class _CyclicDataWidgetState extends State<CyclicDataWidget> {
  ApiData? _currentData;
  bool _isServiceRunning = false;
  Timer? _uiUpdateTimer;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _startUIUpdates();
  }

  @override
  void dispose() {
    _uiUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeService() async {
    await CyclicDataService.initialize();
    _updateUI();
  }

  void _startUIUpdates() {
    _uiUpdateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _updateUI();
    });
  }

  Future<void> _updateUI() async {
    final status = await CyclicDataService.getDataStatus();
    if (mounted) {
      setState(() {
        _currentData = status['data'];
      });
    }
  }

  Future<void> _startService() async {
    final started = await CyclicDataService.startCyclicProcess();
    setState(() {
      _isServiceRunning = started;
    });
    
    if (started) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cyclic service started')),
      );
    }
  }

  Future<void> _stopService() async {
    final stopped = await CyclicDataService.stopCyclicProcess();
    setState(() {
      _isServiceRunning = !stopped;
    });
    
    if (stopped) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cyclic service stopped')),
      );
    }
  }

  Future<void> _manualTrigger() async {
    await CyclicDataService.triggerManualCycle();
    _updateUI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cyclic Data Service'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Control
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Service Control',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _isServiceRunning ? null : _startService,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Start Cycle'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _isServiceRunning ? _stopService : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Stop Cycle'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _manualTrigger,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Manual Trigger'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Status: ${_isServiceRunning ? 'Running' : 'Stopped'}',
                      style: TextStyle(
                        color: _isServiceRunning ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Current Data Display
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Saved Data',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    if (_currentData != null) ...[
                      Text('ID: ${_currentData!.id}'),
                      const SizedBox(height: 8),
                      Text(
                        'Title: ${_currentData!.title}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Body: ${_currentData!.body}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fetched: ${_currentData!.fetchedAt.toString().substring(0, 19)}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ] else ...[
                      const Text(
                        'No data currently saved',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Instructions
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it works:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Fetch data from API'),
                    const Text('2. Show notification'),
                    const Text('3. Save data locally'),
                    const Text('4. Display saved data'),
                    const Text('5. After 10 seconds: remove local data'),
                    const Text('6. Repeat from step 1'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Main app setup
class CyclicDataApp extends StatelessWidget {
  const CyclicDataApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyclic Data Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const CyclicDataWidget(),
    );
  }
}