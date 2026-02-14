import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'theme.dart';

enum AppTheme { light, dark }

class ThemeProvider extends ChangeNotifier {
  static const _prefKey = 'app_theme';
  late SharedPreferences _prefs;

  AppTheme _currentTheme = AppTheme.light;

  AppTheme get currentTheme => _currentTheme;

  ThemeData get themeData {
    switch (_currentTheme) {
      case AppTheme.dark:
        return AppThemes.darkTheme;
      case AppTheme.light:
      default:
        return AppThemes.lightTheme;
    }
  }

  bool get isDarkMode => _currentTheme == AppTheme.dark;

  ThemeProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _loadTheme();
    } catch (e) {
      debugPrint('❌ Error initializing SharedPreferences: $e');
      _currentTheme = AppTheme.light;
      notifyListeners();
    }
  }

  void _loadTheme() {
    final themeIndex = _prefs.getInt(_prefKey);
    if (themeIndex != null && themeIndex < AppTheme.values.length) {
      _currentTheme = AppTheme.values[themeIndex];
    } else {
      _currentTheme = AppTheme.light;
    }
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    try {
      await _prefs.setInt(_prefKey, _currentTheme.index);
    } catch (e) {
      debugPrint('❌ Error saving theme: $e');
    }
  }

  Future<void> setTheme(AppTheme theme) async {
    if (_currentTheme != theme) {
      _currentTheme = theme;
      await _saveTheme();
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _currentTheme = isDarkMode ? AppTheme.light : AppTheme.dark;
    await _saveTheme();
    notifyListeners();
  }
}
