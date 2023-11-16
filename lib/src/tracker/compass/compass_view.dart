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
        if ( snapshot.hasError){
          return const Text("Error reading");
        }
        if ( snapshot.connectionState == ConnectionState.waiting ){
          return const Center(child: CircularProgressIndicator());
        }

        double? direction = snapshot.data!.heading;

        if ( direction == null ){
          return const Center(
            child: Text("Your device doesn't have the required sensors")
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 130,
              child: Material(
                shadowColor: Colors.blue,
                shape: const CircleBorder( 
                  side: BorderSide( 
                    color: Colors.black26,
                    width: 5
                    )
                  ),
                elevation: 2,
                color: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: ( direction * ( math.pi / 180 ) * -1 ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("N", style: TextStyle( color: Colors.red), ),
                        Icon(
                          Icons.straight, 
                          size: 100,
                        )
                      ],
                    ) 
                  )
                ),
              )
            ),
            SizedBox(
              width: 130,
              child: Material(
                shadowColor: Colors.blue,
                shape: const CircleBorder( 
                  side: BorderSide( 
                    color: Colors.black26,
                    width: 5
                    )
                  ),
                elevation: 2,
                color: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  child: Transform.rotate(
                    angle: ( direction * ( math.pi / 180 ) * -1 + targetLocationRotationInRads ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text( "Target", style: TextStyle( color: Colors.green), ),
                        Icon(
                          Icons.straight_rounded,
                          color: Colors.green,
                          size: 100,
                        )
                      ],
                    ) 
                  )
                ),
              )
            )
          ],
        );
          
        
      }
    );

    
  }


    
}