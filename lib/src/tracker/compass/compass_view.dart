import 'dart:math' as math;

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/custom/copying_service.dart';
import 'package:path_finders/src/custom/is_landscape.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/tracker/compass/compass_widget.dart';
import 'package:path_finders/src/tracker/compass/notification_service.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:permission_handler/permission_handler.dart';

class CompassView extends StatefulWidget {
  
  final double targetLocationRotationInRads;
  final Coordinates targetLocation;
  final int distanceToTarget;

  const CompassView({
    super.key, 
    required this.targetLocationRotationInRads, 
    required this.targetLocation ,
    required this.distanceToTarget,
  });

  @override
  State<CompassView> createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView> {

  bool isBehavingLikeRealCompass = true;
  bool notificationIsEnabled = false;

  @override
  Widget build( BuildContext context){

    final appLocalizations = AppLocalizations.of( context );
    final compassWidth = MediaQuery.of(context).size.width * 0.8;
    final compassHeight = isLandscape(context)? MediaQuery.of(context).size.height * 0.5 :MediaQuery.of(context).size.height * 0.3;
    final compassRadius = math.min( compassHeight, compassWidth);

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events, 
      builder: (context, snapshot){

        if ( snapshot.connectionState == ConnectionState.active ){

          final double? direction = snapshot.data?.heading ;
          final double? accuracy  = snapshot.data?.accuracy;


          if ( direction == null || snapshot.hasError ){
            return Center(
              child: Text( appLocalizations!.errors_sensors )
            );
          }
          else{

            return GestureDetector(
              
              onTap: ()async{

                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                
                ScaffoldMessenger.of(context)
                  .showSnackBar(
                    CustomSnackBar(
                      textContent: 
                      "${ isBehavingLikeRealCompass? appLocalizations.snackbar_compass_realistic :appLocalizations.snackbar_compass_targetMode}.\n" 
                      "${ appLocalizations.snackbar_compass_doubleTap }\n"
                      "${appLocalizations.snackbar_compass_longPress}", 
                      context: context
                    )
                  );
                
                setState(() {
                  isBehavingLikeRealCompass = !isBehavingLikeRealCompass;
                });


              },
              onDoubleTap: ()async{

                 if ( notificationIsEnabled ){

                  if ( await FlutterForegroundTask.isRunningService ) await FlutterForegroundTask.stopService();
                  setState(() {
                    notificationIsEnabled = false;
                  });

                }else{
                  
                  try{
                    await checkForegroundPermissions();
                    if ( await Geolocator.checkPermission() != LocationPermission.always ){

                      if ( context.mounted ) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          CustomSnackBar(textContent: appLocalizations.tracking_alwaysOnRequest, context: context)
                        );
                      } 
                      await Permission.locationAlways.request();
                      return;
                    }

                  }catch( error ){
                    //something went wrong
                  }

                  if ( !(await FlutterForegroundTask.isRunningService) ){
                    await FlutterForegroundTask.startService(
                      notificationTitle: "Distance Tracker", 
                      notificationText: "Initializing..",
                      callback: startCallback
                    );
                  }
                  
                  setState(() {
                    notificationIsEnabled = true;
                  });
                  
                }
                
              },
              onLongPress: (){
                CopyService.copyTextToClipboard( widget.targetLocation.toString(), context: context);
              },
              child: 
                SizedBox(
                  width: compassRadius,
                  height: compassRadius,
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Compass(
                        isBehavingLikeRealCompass: isBehavingLikeRealCompass,
                        direction: direction,
                        additionalRotation: widget.targetLocationRotationInRads,
                        compassRadius: compassRadius,
                      ),
                      Positioned(
                        top: compassRadius + 10,
                        right: 0,
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon( 
                              Icons.circle_sharp, 
                              color: Colors.green,
                              size: 8
                            ),
                            Text( appLocalizations!.compass_target )
                          ]
                        )
                      ),
                      Positioned(
                        top: compassRadius + 30,
                        child: Text( "${appLocalizations.compass_accuracy} ${ 
                            accuracy != null
                              ? accuracy < 15 
                                ? appLocalizations.compass_accuracy_veryLow
                                : accuracy < 30? appLocalizations.compass_accuracy_low :appLocalizations.compass_accuracy_great
                              :appLocalizations.compass_accuracy_calibrationNeeded}"
                        ),
                      ),
                    ],
                  ),
                )
                
            );

          }
        }
        else{
          return const Center(child: CircularProgressIndicator());
        }
          
        
      }
    );

    
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
        buttons: [
          const NotificationButton(id: "dismissButton", text: "Dismiss")
        ]
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        isOnceEvent: true,
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
}
