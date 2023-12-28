import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/custom/is_landscape.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/tracker/compass/notification_service_builder.dart';
import 'package:path_finders/src/tracker/format_distance.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:url_launcher/url_launcher.dart';

class DistanceToTargetView extends StatefulWidget {
  const DistanceToTargetView({
    super.key,
    required this.distanceToTarget,
    required this.appLocalizations,
    required this.appState,
    required this.targetLocation,
    required this.notificationIsEnabled
  });

  final int distanceToTarget;
  final AppLocalizations appLocalizations;
  final TargetProvider appState;
  final Coordinates targetLocation;
  final bool notificationIsEnabled;

  @override
  State<DistanceToTargetView> createState() => _DistanceToTargetViewState();
}

class _DistanceToTargetViewState extends State<DistanceToTargetView> {

  int lastDistanceSnapshot = 0;
  ReceivePort? _receivePort;


  @override
  Widget build(BuildContext context) {

    if ( widget.notificationIsEnabled ){

       WidgetsBinding.instance.addPostFrameCallback(
          ( _ )async{

            await checkForegroundPermissions();
            final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
            final bool isRegistered = _registerReceivePort(receivePort);
            if (!isRegistered) {
              print('Failed to register receivePort!');
            }

            if ( await FlutterForegroundTask.isRunningService  ){
              _registerReceivePort( FlutterForegroundTask.receivePort );
              if ( widget.distanceToTarget != lastDistanceSnapshot ){
                await FlutterForegroundTask.saveData(key: "targetLocation", value: widget.targetLocation.toString());
              }
            }
            else{
              await FlutterForegroundTask.saveData(key: "targetLocation", value: widget.targetLocation.toString());
              await FlutterForegroundTask.startService(
                notificationTitle: "Distance Tracker", 
                notificationText: "${DistanceFormatter.metersFormatter(widget.distanceToTarget)} to Target - You need to open the app in order to get the updated location of a live target.",
                callback: startCallback
              );
            }
            
          }, 
        );
        setState(() {
          lastDistanceSnapshot = widget.distanceToTarget;
        });
      // }

    }else{
      // delete the notification.

      WidgetsBinding.instance.addPostFrameCallback(
        ( _ )async{
              if ( await FlutterForegroundTask.isRunningService ) await FlutterForegroundTask.stopService();
        }, 
      );
    }
    


    return SizedBox(
      width: isLandscape(context)? MediaQuery.sizeOf(context).width * 0.5 :MediaQuery.sizeOf(context).width * 0.85,
      child: Padding(
        padding: const EdgeInsets.only( top: 8 ),
        child: widget.distanceToTarget < 15
          ?Text(
            widget.appLocalizations.tracking_nearby,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          )
          :Column( 
            children:[
              Text( 
                " ${ widget.appLocalizations.tracking_distanceToIs(widget.appState.targetName)}",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  Text( 
                    DistanceFormatter.metersFormatter( widget.distanceToTarget ),
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 48,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: IconButton(
                        onPressed: ()async{
                          await launchUrl( Uri.parse( "http://maps.google.com/maps?daddr=${widget.targetLocation.toString()}" ));
                        },
                        tooltip: widget.appLocalizations.tracking_showOnMap,
                        color: Theme.of(context).colorScheme.primary,
                        icon: const Icon ( Icons.navigation ),
                      ),
                    ),
                  )
                  
                ],
              )
            ]
          ),
      ),
    );
  }

  Future<void> checkForegroundPermissions() async {
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }
    
    // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
    final NotificationPermission notificationPermissionStatus =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  @override
  void initState(){
    super.initState();
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'path_finders_foreground_service',
        channelName: 'Path Finders Foreground Service Notification',
        channelDescription: 'Distance to the current target is shown as notification.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
      ),
    );
  }

  bool _registerReceivePort(ReceivePort? newReceivePort) {
    if (newReceivePort == null) {
      return false;
    }

    _closeReceivePort();

    _receivePort = newReceivePort;
    _receivePort?.listen((data) {
      if (data is int) {
        print('eventCount: $data');
      }  else if (data is DateTime) {
        print('timestamp: ${data.toString()}');
      }
    });
    return _receivePort != null;


  }

    void _closeReceivePort() {
      _receivePort?.close();
      _receivePort = null;
    }


}
