import 'package:flutter/material.dart';
import 'package:taskmanager/components/theme.dart';

class ThemeNotifier with ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? Themes.dark : Themes.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
