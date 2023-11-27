import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class CompassView extends StatelessWidget {
  
  final double targetLocationRotationInRads;

  const CompassView({super.key, required this.targetLocationRotationInRads});

  @override
  Widget build( BuildContext context){

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events, 
      builder: (context, snapshot){


        if ( snapshot.connectionState == ConnectionState.active ){

          final double? direction = snapshot.data?.heading;

          if ( direction == null || snapshot.hasError ){
            return const Center(
              child: Text("Your device doesn't have the required sensors")
            );
          }
          else{

            

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Compass(
                  angle: direction * ( math.pi / 180 ) * -1, 
                  children: [
                    const Text( 
                      "N", 
                      style: TextStyle( color: Colors.red),
                      textScaler: TextScaler.linear( 2 ) 
                    ),
                    Icon(
                      Icons.straight,
                      color: Colors.white38,
                      size: MediaQuery.of(context).size.width * 0.3,
                    )
                  ]
                ),
                const SizedBox.square( dimension: 48 ),
                Compass(
                  angle: direction * ( math.pi / 180 ) * -1 + targetLocationRotationInRads, 
                  children: [
                    const Text( 
                      "Target", 
                      textScaler: TextScaler.linear( 1.5 ),
                      style: TextStyle( color: Colors.white) ),
                    Icon(
                      Icons.straight_rounded,
                      color: Colors.white38,
                      size: MediaQuery.of(context).size.width * 0.3,
                    )
                  ]
                )
              ],
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

  final double angle;
  final List<Widget> children;

  const Compass( {super.key, required this.angle, required this.children } );

  @override
  Widget build(BuildContext context) {

    final compassWidth = MediaQuery.of(context).size.width * 0.8;
    final compassHeight = MediaQuery.of(context).size.height * 0.2;

    return SizedBox(
      width: compassWidth,
      height: compassHeight,
      child: Material(
        shadowColor: Colors.brown.shade700,
        shape: const CircleBorder( 
          side: BorderSide( 
            color: Colors.black26,
            width: 7
            )
          ),
        elevation: 3,
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: angle,
            child:  Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            ) 
          )
        ),
      )
    );
  }
}