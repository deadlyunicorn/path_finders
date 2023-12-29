// The callback function should always be a top-level function.
import 'dart:async';
import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/custom/target_location_fetch.dart';
import 'package:path_finders/src/tracker/format_distance.dart';
import 'package:path_finders/src/types/coordinates.dart';


@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {

  StreamSubscription<Position>? _userPositionStream;

  // Called when the task is started.
  @override
  void onStart(DateTime timestamp, SendPort? sendPort) async {

    // Send data to the main isolate.
    final targetLocationCoordinates =
      ( await FlutterForegroundTask.getData<String>(key: 'targetLocation') )
      ?.split(",")
      .map((e) => e.trim())
      .toList();
    final targetName = await FlutterForegroundTask.getData<String>(key: 'targetName')??"Unknown";

    if( targetLocationCoordinates != null && targetLocationCoordinates.length == 2 ){

      final targetLocation = Coordinates( 
        double.tryParse( targetLocationCoordinates.first ) ?? 0, 
        double.tryParse(targetLocationCoordinates.last)?? 0 
      ); 

      notificationUpdate(targetLocation, targetName, sendPort);
      
    } else{
      notificationUpdate( Coordinates( 90, 0), "North Pole", sendPort );
    }

  }

  void notificationUpdate(Coordinates targetLocation, String targetName, SendPort? sendPort) {
    _userPositionStream = Geolocator.getPositionStream().listen((position) async{

      try{
        final targetCoordinates = ( await TargetLocationServices.getTargetDetails( targetName ) )?.getCoordinates() ;
        if ( targetCoordinates != null ){
          targetLocation = targetCoordinates;
        } 
      }
      catch( err ) {
        //network error ig?
      }
    
      final userCoordinates = Coordinates( position.latitude, position.longitude);
      final distanceToTarget =  targetLocation.distanceInMetersTo( userCoordinates ) ;
      FlutterForegroundTask.updateService(
        notificationText: "${DistanceFormatter.metersFormatter( distanceToTarget )} to $targetName - If you track a live target, their location won't update unless you open the app.",
        notificationTitle: "Distance Tracker",
      );
    
      sendPort?.send( position.toJson() );
    
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
  }

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) async {

    await _userPositionStream?.cancel();
  }
}