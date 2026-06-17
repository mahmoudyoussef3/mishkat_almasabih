import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    // According to connectivity_plus documentation, checkConnectivity() returns a List<ConnectivityResult> in newer versions
    // We check if it contains something other than .none
    return !results.contains(ConnectivityResult.none) && results.isNotEmpty;
  }
}
