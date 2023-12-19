import 'package:flutter/material.dart';
import 'package:path_finders/notifications/notification_controller.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationController.initializeLocalNotifications();
  await NotificationController.initializeIsolateReceivePort();

  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  

  // await NotificationAbstractions.intialization();

  

  runApp(MyApp(settingsController: settingsController));
}
