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

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.2,
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
                    angle: ( direction * ( math.pi / 180 ) * -1 ),
                    child:  Column(
                      mainAxisSize: MainAxisSize.min,
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
                      ],
                    ) 
                  )
                ),
              )
            ),
            const SizedBox.square( dimension: 48 ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.2,
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
                    angle: ( direction * ( math.pi / 180 ) * -1 + targetLocationRotationInRads ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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