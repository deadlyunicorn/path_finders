import 'dart:math' as math;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:path_finders/src/copying_service.dart';
import 'package:path_finders/src/custom/is_landscape.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/tracker/compass/compass_widget.dart';
import 'package:path_finders/src/types/coordinates.dart';

class CompassView extends StatefulWidget {
  
  final double targetLocationRotationInRads;
  final Coordinates targetLocation;
  final int distanceToTarget;

  const CompassView({
    super.key, 
    required this.targetLocationRotationInRads, 
    required this.targetLocation ,
    required this.distanceToTarget
  });

  @override
  State<CompassView> createState() => _CompassViewState();
}

class _CompassViewState extends State<CompassView> {

  bool isBehavingLikeRealCompass = true;
  bool notificationEnabled = false;

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
              onDoubleTap: (){
                
                setState(() {
                  notificationEnabled = !notificationEnabled;
                });
                
                // NotificationAbstractions.displayTest();
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
}
