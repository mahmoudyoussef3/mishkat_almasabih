import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/models/hadith_daily_response.dart';
import 'package:mishkat_almasabih/features/hadith_daily/data/repos/save_hadith_daily_repo.dart';

part 'daily_hadith_state.dart';

class DailyHadithCubit extends Cubit<DailyHadithState> {
  final SaveHadithDailyRepo _repo = SaveHadithDailyRepo();
  
  DailyHadithCubit() : super(DailyHadithInitial());

  Timer? _refreshTimer;
  DailyHadithModel? _lastLoadedHadith;
  DateTime? _lastCheckTime;

  // تحميل الحديث لأول مرة وبدء التايمر
  Future<void> startListeningForUpdates() async {
    debugPrint('🔄 Starting to listen for hadith updates...');
    
    // عرض loading state أول مرة بس
    if (state is DailyHadithInitial) {
      emit(DailyHaditLoading());
    }
    
    // تحميل البيانات أول مرة
    await _loadSavedHadith(showLoading: false);
    
    // بدء التايمر للتحديث كل 30 ثانية
    _startPeriodicCheck();
  }

  // بدء التايمر
  void _startPeriodicCheck() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        debugPrint('⏰ Timer triggered - checking for new hadith...');
        _checkForUpdates();
      },
    );
  }

  // فحص التحديثات بدون loading state
  Future<void> _checkForUpdates() async {
    try {
      final saved = await _repo.getHadith();
      
      if (saved != null && _hasHadithChanged(saved)) {
        debugPrint('📱 New hadith found, updating UI...');
        _lastLoadedHadith = saved;
        _lastCheckTime = DateTime.now();
        emit(DailyHadithSuccess(saved));
      } else {
        debugPrint('📖 No changes detected');
      }
    } catch (e) {
      debugPrint('❌ Error checking updates: $e');
      // لا نعرض error للمستخدم في الفحص التلقائي
    }
  }

  // تحقق من تغيير الحديث
  bool _hasHadithChanged(DailyHadithModel newHadith) {
    if (_lastLoadedHadith == null) return true;
    
    // مقارنة النص أو ID الحديث
    return _lastLoadedHadith!.data?.hadith != newHadith.data?.hadith ||
           _lastLoadedHadith!.data?.attribution != newHadith.data?.attribution;
  }

  // تحميل الحديث المحفوظ
  Future<void> _loadSavedHadith({bool showLoading = true}) async {
    try {
      if (showLoading) {
        emit(DailyHaditLoading());
      }
      
      debugPrint('📖 Loading saved hadith...');
      final saved = await _repo.getHadith();
      
      if (saved != null) {
        debugPrint('✅ Hadith loaded: ${saved.data?.hadith?.substring(0, 50) ?? 'No content'}...');
        _lastLoadedHadith = saved;
        _lastCheckTime = DateTime.now();
        emit(DailyHadithSuccess(saved));
      } else {
        debugPrint('❌ No saved hadith found');
        emit(DailyHadithFailure('لا توجد أحاديث محفوظة'));
      }
    } catch (e) {
      debugPrint('❌ Error loading hadith: $e');
      emit(DailyHadithFailure('حدث خطأ في تحميل البيانات'));
    }
  }

  // تحديث فوري من UI
  Future<void> refreshNow() async {
    debugPrint('🔄 Manual refresh requested...');
    emit(DailyHaditLoading());
    await _loadSavedHadith(showLoading: false);
  }

  // إعادة تشغيل الاستماع
  void resumeListening() {
    if (_refreshTimer == null || !_refreshTimer!.isActive) {
      debugPrint('▶️ Resuming hadith listener...');
      _startPeriodicCheck();
    }
  }

  // إيقاف مؤقت للاستماع
  void pauseListening() {
    debugPrint('⏸️ Pausing hadith listener...');
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  // إيقاف نهائي
  void stopListening() {
    debugPrint('🛑 Stopping hadith updates listener...');
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _lastLoadedHadith = null;
    _lastCheckTime = null;
  }

  // معلومات للـ debugging
  String getDebugInfo() {
    return '''
📊 Debug Info:
- State: ${state.runtimeType}
- Timer Active: ${_refreshTimer?.isActive ?? false}
- Last Check: ${_lastCheckTime?.toString() ?? 'Never'}
- Has Hadith: ${_lastLoadedHadith != null}
    ''';
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}