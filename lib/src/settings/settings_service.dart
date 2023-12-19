import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString( 'themeMode' );

      switch ( themeMode ){

        case ( 'dark' ):
          return ThemeMode.dark;
        case ( 'light' ):
          return ThemeMode.light;
        default :
          return ThemeMode.system;

      }
  }

  Future<void> updateThemeMode(ThemeMode theme) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString( 'themeMode', theme.name );

  }
}
