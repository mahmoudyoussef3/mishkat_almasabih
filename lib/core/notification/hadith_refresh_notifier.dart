import 'package:flutter/material.dart';

/// Singleton pattern عشان نضمن instance واحد بس في كل التطبيق
class HadithRefreshNotifier extends ChangeNotifier {
  static final HadithRefreshNotifier _instance = HadithRefreshNotifier._internal();
  
  factory HadithRefreshNotifier() => _instance;
  
  HadithRefreshNotifier._internal();

  /// دالة لإشعار جميع المستمعين بالتحديث
  void notifyRefresh() {
    debugPrint('🔔 Notifying all listeners to refresh hadith');
    notifyListeners();
  }
}