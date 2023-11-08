import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/providers/friend_locator_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:provider/provider.dart';

class LocationAllowedView extends StatefulWidget{

  const LocationAllowedView({ super.key });

  @override
  State<LocationAllowedView> createState() => _LocationAllowedViewState();
}

class _LocationAllowedViewState extends State<LocationAllowedView> {

  Coordinates currentPosition = Coordinates( 0, 0 );

  @override
  Widget build(BuildContext context) {

    FriendLocatorProvider appState = context.watch<FriendLocatorProvider>();

    Coordinates pointOfInterest = appState.pointOfInterest;

    return Column(
      children: [
        Container( 
          alignment: Alignment.center,
          height: MediaQuery.of( context ).size.height / 3 ,
          child: 
          StreamBuilder(
            stream: Geolocator.getPositionStream(), 
            builder: (context, snapshot) {

              double pointOfInterestRotationInRads = num.parse( 
                currentPosition
                  .getDifference( pointOfInterest )
                  .getRotationFromNorth()
                  .toStringAsFixed(5) 
              ) as double ;

              if ( snapshot.hasError ){
                return Text( "Failed getting data");
              }
              else if ( snapshot.hasData ){

              currentPosition = Coordinates( snapshot.data!.latitude, snapshot.data!.longitude ); 

                return Column( 
                  children: [
                    Text( "Your current position is \n ${ currentPosition.latitude }, ${ currentPosition.longitude } " ),
                    pointOfInterestRotationInRads.isFinite 
                      ? Column(
                        children: [
                          Text(

                              "Rotate clockwise ${pointOfInterestRotationInRads * 57.29 } degress from North,"
                              "in order to look towards ${appState.friendlyNameOfPoint}.",
                              textAlign: TextAlign.center,
                            ),
                            Center(child: 
                              _buildCompass( context, pointOfInterestRotationInRads: pointOfInterestRotationInRads )
                            )

                        ],
                      )
                    
                      : CircularProgressIndicator()
                  ],
                );
              }
              else{
                return CircularProgressIndicator();
              }
            }
          )
        ),
        
      ],
    );
  }

  Widget _buildCompass(BuildContext context, { required double pointOfInterestRotationInRads}){

    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events, 
      builder: (context, snapshot){
        if ( snapshot.hasError){
          return Text("Error reading");
        }
        if ( snapshot.connectionState == ConnectionState.waiting ){
          return Center(child: CircularProgressIndicator());
        }

        double? direction = snapshot.data!.heading;

        if ( direction == null ){
          return Center(
            child: Text("Your device doesn't have the required sensors")
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 130,
              child: Material(
                shadowColor: Colors.blue,
                shape: CircleBorder( 
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
            Container(
              width: 130,
              child: Material(
                shadowColor: Colors.blue,
                shape: CircleBorder( 
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
                    angle: ( direction * ( math.pi / 180 ) * -1 + pointOfInterestRotationInRads ),
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