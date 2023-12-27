import 'dart:math' as math;
import 'package:flutter/material.dart';

class Compass extends StatelessWidget {

  final double direction;
  final double additionalRotation;
  final bool isBehavingLikeRealCompass;
  final double compassRadius;

  const Compass( {
    super.key, 
    required this.isBehavingLikeRealCompass,
    required this.direction, 
    required this.additionalRotation,
    required this.compassRadius
  } );

  @override
  Widget build(BuildContext context) {

    

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