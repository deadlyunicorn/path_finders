import 'package:flutter/material.dart';

import 'settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {

  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  //THEME

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

 

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;
    await _settingsService.writeThemeMode(newThemeMode);
    notifyListeners();
  }

  //Locale Settings

  String _locale = "en";

  Future<void> updateLocaleSetting( String locale )async{
    if ( locale == _locale ) return;


    if ( locale == "en" || locale == "el" ){

      _locale = locale;
      await _settingsService.writeLocaleSetting( locale );
      notifyListeners();

    }

  }

  String get locale => _locale;


   Future<void> loadSettings() async {

    _themeMode = await _settingsService.readThemeMode();
    _locale    = await _settingsService.readLocaleSetting();
    notifyListeners();
  }


}
