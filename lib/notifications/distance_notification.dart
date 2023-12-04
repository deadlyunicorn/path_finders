import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationAbstractions {

  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('launcher_icon');
  static const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid
  );

  static intialization()async{
    await flutterLocalNotificationsPlugin.initialize(
    initializationSettings
  );
  }
  static void displayTest()async{
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        "Channel Id", "Chhannel name",
        channelDescription: "My Description",
        importance: Importance.max,
        ticker: "ticker"
      );
      const NotificationDetails notificationDetails = NotificationDetails( android: androidNotificationDetails );
      await flutterLocalNotificationsPlugin.show( 
        0, "A cool tittle", "a cool body", notificationDetails
      );
  }
}