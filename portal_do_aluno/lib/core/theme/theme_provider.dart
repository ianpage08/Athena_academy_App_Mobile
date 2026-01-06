import 'package:flutter/material.dart';
import 'package:portal_do_aluno/core/app_constants/app_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = AppPreferences.getThemeMode();
  ThemeMode get themeMode => _themeMode;

  void toggleTheme(ThemeMode mode) {
    _themeMode = mode;
    AppPreferences.setTheme(mode);

    notifyListeners();
  }

  bool get isDarkmode => _themeMode == ThemeMode.dark;
}
