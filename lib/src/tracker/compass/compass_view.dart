import 'dart:math' as math;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:path_finders/notifications/notification_controller.dart';
import 'package:path_finders/src/copying_service.dart';
import 'package:path_finders/src/custom/is_landscape.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Compass(
                      isBehavingLikeRealCompass: isBehavingLikeRealCompass,
                      direction: direction,
                      additionalRotation: widget.targetLocationRotationInRads,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Transform.translate(
                      offset: Offset( MediaQuery.of(context).size.width * 0.2, 0),
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
                      ]),
                    ),
                    Text( "${appLocalizations.compass_accuracy} ${ 
                        accuracy != null
                          ? accuracy < 15 
                            ? appLocalizations.compass_accuracy_veryLow
                            : accuracy < 30? appLocalizations.compass_accuracy_low :appLocalizations.compass_accuracy_great
                          :appLocalizations.compass_accuracy_calibrationNeeded}"
                    ),
                    FutureBuilder(
                      future:(()async{
                        if ( notificationEnabled ){
                          if ( context.mounted ) NotificationController.createNewNotification( context, widget.distanceToTarget );
                        } else{
                          await NotificationController.cancelNotifications();
                        }
                      })(), 
                      builder: (context, snapshot) => const SizedBox.shrink(),
                    )

                  ],
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

class Compass extends StatelessWidget {

  final double direction;
  final double additionalRotation;
  final bool isBehavingLikeRealCompass;

  const Compass( {
    super.key, 
    required this.isBehavingLikeRealCompass,
    required this.direction, 
    required this.additionalRotation
  } );

  @override
  Widget build(BuildContext context) {

    final compassWidth = MediaQuery.of(context).size.width * 0.8;
    final compassHeight = isLandscape(context)? MediaQuery.of(context).size.height * 0.5 :MediaQuery.of(context).size.height * 0.3;
    final compassRadius = math.min( compassHeight, compassWidth);

    final rotationToNorth = -direction * ( math.pi / 180 );

    return SizedBox(
      width: compassRadius,
      height: compassRadius,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: compassRadius * 0.8,
            height: compassRadius,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all( Radius.circular( compassRadius )) ,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onBackground.withAlpha( 100 ),
                  blurRadius: 4
                )
              ]
            )
          ),
          Image.asset( "assets/compass/body.png", height: compassRadius,  ),
          //need to *scale* the images based on the available space, 
          //else they will try to get all of it as they are larger.
          Container(
            width: compassRadius,
            height: compassRadius,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha( 100 ),
                  blurRadius: 8
              )],
              borderRadius: BorderRadius.all( Radius.circular( compassRadius ))
            ),         
          ), 
          Transform.rotate(
            angle: isBehavingLikeRealCompass? rotationToNorth :0,
            child: Image.asset( "assets/compass/inner.png", height: compassRadius * 0.852 )
          ), 
          Transform.rotate(
            angle: isBehavingLikeRealCompass? 0: rotationToNorth,
            child: Image.asset("assets/compass/arrow.png", height: compassRadius * 0.75 )
          ),
          Transform.rotate(
            angle: isBehavingLikeRealCompass? rotationToNorth + additionalRotation :additionalRotation ,
            child: Image.asset("assets/compass/dot.png", height: compassRadius * 0.75,color: Colors.green, )
          )
        ],
      ) 
      
    );
  }
}