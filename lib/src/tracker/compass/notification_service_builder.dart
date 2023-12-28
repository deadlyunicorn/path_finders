// The callback function should always be a top-level function.
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/tracker/format_distance.dart';
import 'package:path_finders/src/types/coordinates.dart';


@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {

  SendPort? _sendPort;

  // Called when the task is started.
  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    // Send data to the main isolate.
     final targetLocationCoordinates =
        ( await FlutterForegroundTask.getData<String>(key: 'targetLocation') )
        ?.split(",")
        .map((e) => e.trim())
        .toList();

    if( targetLocationCoordinates != null && targetLocationCoordinates.length == 2 ){

      final targetLocation = Coordinates( double.tryParse( targetLocationCoordinates.first ) ?? 0, double.tryParse(targetLocationCoordinates.last)?? 0 ); 
      final userPosition = await Geolocator.getCurrentPosition();
      final distanceToTarget =  targetLocation.distanceInMetersTo( Coordinates( userPosition.latitude, userPosition.longitude) ) ;
      await FlutterForegroundTask.updateService(
        notificationText: "${DistanceFormatter.metersFormatter( distanceToTarget )} to Target - You need to open the app in order to get the updated location of a live target.",
        notificationTitle: "Distance Tracker",
        callback: startCallback,

      );
    }

    sendPort?.send(timestamp.toString());
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {
  }
  @override
  void onNotificationButtonPressed(String id) {
  }
  @override
  void onNotificationPressed() {
  }
}
