import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateNotifier extends ChangeNotifier {
  String _themeMode;

  String get themeMode => _themeMode;
  AppStateNotifier() {
    //_themeMode = 'System Default';
    _getThemeMode();
  }

  void updateTheme(String themeMode) {
    this._themeMode = themeMode;
    notifyListeners();
    _setThemeMode(themeMode);
  }

  _getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _themeMode = prefs.getString('themeMode') != null
        ? prefs.getString('themeMode')
        : 'System Default';
    notifyListeners();
  }

  _setThemeMode(String themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', themeMode);
  }
}
