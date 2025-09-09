import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

/// ThemeManager handles theme switching and persistence for the Mishkat Al-Masabih app.
///
/// This class provides:
/// - Theme state management
/// - Persistent theme storage
/// - Theme change notifications
/// - System theme detection
/// - Professional dark mode implementation
class ThemeManager extends Cubit<ThemeMode> {
  static const String _themeKey = 'app_theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;

  ThemeManager() : super(ThemeMode.system) {
    _loadThemeFromStorage();
  }

  /// Current theme mode (system, light, dark)
  ThemeMode get themeMode => _themeMode;

  /// Whether dark mode is currently active
  bool get isDarkMode => _isDarkMode;

  /// Current theme data based on the selected mode
  ThemeData get currentTheme {
    switch (_themeMode) {
      case ThemeMode.light:
        return AppTheme.lightTheme;
      case ThemeMode.dark:
        return AppTheme.darkTheme;
      case ThemeMode.system:
        return _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;
    }
  }

  /// Toggle between light and dark themes
  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.system) {
      // If system mode, switch to manual dark mode
      _themeMode = ThemeMode.dark;
      _isDarkMode = true;
    } else if (_themeMode == ThemeMode.dark) {
      // Switch to light mode
      _themeMode = ThemeMode.light;
      _isDarkMode = false;
    } else {
      // Switch to dark mode
      _themeMode = ThemeMode.dark;
      _isDarkMode = true;
    }

    await _saveThemeToStorage();
    emit(_themeMode);
    log('Theme changed to: ${_themeMode.name}, isDark: $_isDarkMode');
  }

  /// Set theme mode explicitly
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;

      // Update dark mode state based on system theme if needed
      if (mode == ThemeMode.system) {
        _isDarkMode = _getSystemTheme();
      } else {
        _isDarkMode = mode == ThemeMode.dark;
      }

      await _saveThemeToStorage();
      emit(_themeMode);
      log('Theme mode set to: ${mode.name}');
    }
  }

  /// Set dark mode state directly
  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

      await _saveThemeToStorage();
      emit(_themeMode);
      log('Dark mode set to: $isDark');
    }
  }

  /// Update system theme detection
  void updateSystemTheme() {
    if (_themeMode == ThemeMode.system) {
      final systemIsDark = _getSystemTheme();
      if (_isDarkMode != systemIsDark) {
        _isDarkMode = systemIsDark;
        emit(_themeMode);
        log('System theme updated: $_isDarkMode');
      }
    }
  }

  /// Load theme from SharedPreferences
  Future<void> _loadThemeFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;

      _themeMode = ThemeMode.values[themeIndex];

      if (_themeMode == ThemeMode.system) {
        _isDarkMode = _getSystemTheme();
      } else {
        _isDarkMode = _themeMode == ThemeMode.dark;
      }

      log(
        'Theme loaded from storage: ${_themeMode.name}, isDark: $_isDarkMode',
      );
    } catch (e) {
      log('Error loading theme from storage: $e');
      _themeMode = ThemeMode.system;
      _isDarkMode = _getSystemTheme();
    }
  }

  /// Save theme to SharedPreferences
  Future<void> _saveThemeToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _themeMode.index);
      log('Theme saved to storage: ${_themeMode.name}');
    } catch (e) {
      log('Error saving theme to storage: $e');
    }
  }

  /// Get system theme brightness
  bool _getSystemTheme() {
    // This will be updated by the app when system theme changes
    // For now, we'll use a default value
    return false;
  }

  /// Get theme mode display name
  String getThemeModeDisplayName() {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'الوضع الفاتح';
      case ThemeMode.dark:
        return 'الوضع الليلي';
      case ThemeMode.system:
        return 'تلقائي';
    }
  }

  /// Get theme status text
  String getThemeStatusText() {
    switch (_themeMode) {
      case ThemeMode.light:
        return 'مفعل';
      case ThemeMode.dark:
        return 'مفعل';
      case ThemeMode.system:
        return _isDarkMode ? 'الوضع الليلي' : 'الوضع الفاتح';
    }
  }

  /// Reset to system theme
  Future<void> resetToSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }

  /// Clear theme preferences
  Future<void> clearThemePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_themeKey);
      _themeMode = ThemeMode.system;
      _isDarkMode = _getSystemTheme();
      emit(_themeMode);
      log('Theme preferences cleared');
    } catch (e) {
      log('Error clearing theme preferences: $e');
    }
  }
}
