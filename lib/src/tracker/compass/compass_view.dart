import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:path_finders/src/copying_service.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/types/coordinates.dart';

class CompassView extends StatelessWidget {
  
  final double targetLocationRotationInRads;
  final Coordinates targetLocation;

  const CompassView({
    super.key, 
    required this.targetLocationRotationInRads, 
    required this.targetLocation 
  });

  @override
  Widget build( BuildContext context){
    

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events, 
      builder: (context, snapshot){

        if ( snapshot.connectionState == ConnectionState.active ){

          final double? direction = snapshot.data?.heading;
          final double? accuracy  = snapshot.data?.accuracy;

          if ( direction == null || snapshot.hasError ){
            return const Center(
              child: Text("Your device doesn't have the required sensors")
            );
          }
          else{

            return GestureDetector(
              
              onTap: ()async{
                
                ScaffoldMessenger.of(context)
                  .showSnackBar(
                    CustomSnackBar(
                      textContent: 
                      "Showing distance as a notification"
                      "Long Press to copy target's coordinates.", 
                      context: context
                    )
                  );
                // NotificationAbstractions.displayTest();

              },
              onLongPress: (){
                CopyService.copyTextToClipboard( targetLocation.toString(), context: context);
              },
              child: 
                Column(
                  children: [
                    Compass(
                      direction: direction, 
                      additionalRotation: targetLocationRotationInRads,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Transform.translate(
                      offset: Offset( MediaQuery.of(context).size.width * 0.2, 0),
                      child: const Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon( 
                          Icons.circle_sharp, 
                          color: Colors.green,
                          size: 8
                        ),
                        Text(" = Target")
                      ]),
                    ),
                    Text( "Accuracy: ${accuracy != null 
                      ? accuracy < 15 
                        ? "Low"
                        : accuracy.toString()
                      :"Very Low"}"),

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

  const Compass( {
    super.key, 
    required this.direction, 
    required this.additionalRotation
  } );

  @override
  Widget build(BuildContext context) {

    final compassWidth = MediaQuery.of(context).size.width * 0.8;
    final compassHeight = MediaQuery.of(context).size.height * 0.3;
    final rotationToNorth = direction * ( math.pi / 180 ) * -1;

    return SizedBox(
      width: compassWidth,
      height: compassHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: compassWidth * 0.8,
            height: compassHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all( Radius.circular( compassWidth )) ,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onBackground.withAlpha( 100 ),
                  blurRadius: 24
                )
              ]
            )
          ),
          Image.asset( "assets/compass/body.png", height: compassHeight,  ),
          //need to *scale* the images based on the available space, 
          //else they will try to get all of it as they are larger.
          Container(
            width: compassWidth * 0.8,
            height: compassHeight * 0.8,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha( 100 ),
                  blurRadius: 24
              )],
              borderRadius: BorderRadius.all( Radius.circular( compassWidth ))
            ),         
          ), 
          Image.asset( "assets/compass/inner.png", height: compassHeight * 0.852 ), 
          Transform.rotate(
            angle: rotationToNorth,
            child: Image.asset("assets/compass/arrow.png", height: compassHeight * 0.75 )
          ),
          Transform.rotate(
            angle: rotationToNorth + additionalRotation,
            child: Image.asset("assets/compass/dot.png", height: compassHeight * 0.75 )
          )
        ],
      ) 
      
    );
  }
}