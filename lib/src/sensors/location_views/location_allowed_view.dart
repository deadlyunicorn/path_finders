import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/sample_data/country_cords_samples.dart';
import 'package:path_finders/src/types/coordinates.dart';

class LocationAllowedView extends StatefulWidget{

  LocationAllowedView({ super.key });

  @override
  State<LocationAllowedView> createState() => _LocationAllowedViewState();
}

class _LocationAllowedViewState extends State<LocationAllowedView> {

  Coordinates currentPosition = Coordinates( 0, 0 );
  Coordinates pointOfInterest = Coordinates( 0, 0 );

  CompassEvent? _lastRead;
  SampleCoordinateData sampleCoordinates = SampleCoordinateData();
  

  @override
  Widget build(BuildContext context) {

    double pointOfInterestRotationInRads = currentPosition.getDifference( pointOfInterest ).getRotationFromNorth();

    return Column(
      children: [
        Container( 
          alignment: Alignment.center,
          height: MediaQuery.of( context ).size.height / 3 ,
          child: 
          StreamBuilder(
            stream: Geolocator.getPositionStream(), 
            builder: (context, snapshot) {


              if ( snapshot.hasError ){
                return Text( "Failed getting data");
              }
              else if ( snapshot.hasData ){

              currentPosition = Coordinates( snapshot.data!.latitude, snapshot.data!.longitude ); 

                return Column( 
                  children: [
                    Text( "Your current position is \n ${ currentPosition.latitude }, ${ currentPosition.longitude } " ),
                    DropdownMenu(
                      dropdownMenuEntries: [
                        DropdownMenuEntry( value: sampleCoordinates.chinaCords , label: "China"),
                        DropdownMenuEntry( value: sampleCoordinates.finlandCords , label: "Finland"),
                        DropdownMenuEntry( value: sampleCoordinates.mexicoCords , label: "Mexico"),
                        DropdownMenuEntry( value: sampleCoordinates.sAfricaCords , label: "South Africa"),
                      ],
                      onSelected: (value) {
                        
                        if ( value != null ){
                          setState(() {
                            pointOfInterest = value;
                          });
                        }
                      },
                    ),
                    Text( 
                      "Your position difference from your point of interest is"
                      "\n${ currentPosition.getDifference( pointOfInterest ).toString() }" 
                    ),
                    Text(
                      "Rotate ${ pointOfInterestRotationInRads * 57.29 } degress from North."
                    )
                  ],
                );
              }
              else{
                return CircularProgressIndicator();
              }
            }
          )
        ),
        Expanded(child: 
          Center(child: 
            _buildCompass()
          )
        )
        
      ],
    );
  }

  Widget _buildCompass(){
    double pointOfInterestRotationInRads = currentPosition.getDifference( pointOfInterest ).getRotationFromNorth();

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
            )
          ],
        );
          
        
      }
    );
  }
}