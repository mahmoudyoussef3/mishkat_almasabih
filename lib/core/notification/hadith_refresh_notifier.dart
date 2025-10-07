import 'dart:async';

/// Singleton class لإرسال إشعارات عند تحديث الحديث
class HadithRefreshNotifier {
  static final HadithRefreshNotifier _instance = HadithRefreshNotifier._internal();
  
  factory HadithRefreshNotifier() => _instance;
  
  HadithRefreshNotifier._internal();

  // StreamController للإشعار بالتحديث
  final _controller = StreamController<bool>.broadcast();

  /// Stream للاستماع للتحديثات
  Stream<bool> get onRefresh => _controller.stream;

  /// إشعار بتحديث الحديث
  void notifyRefresh() {
    if (!_controller.isClosed) {
      _controller.add(true);
    }
  }

  /// تنظيف الموارد
  void dispose() {
    _controller.close();
  }
}