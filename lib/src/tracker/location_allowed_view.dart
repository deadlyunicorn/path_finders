import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/tracker/compass/compass_view.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:provider/provider.dart';

class LocationAllowedView extends StatefulWidget{

  const LocationAllowedView({ super.key });

  @override
  State<LocationAllowedView> createState() => _LocationAllowedViewState();
}

class _LocationAllowedViewState extends State<LocationAllowedView> {

  Coordinates? currentLocation;

  @override
  Widget build(BuildContext context) {

    TargetProvider appState = context.watch<TargetProvider>();
    Coordinates? targetLocation = appState.targetLocation;

    return Center(
      child: StreamBuilder(
        stream: Geolocator.getPositionStream(), 
        builder: (context, snapshot) {

          double? targetLocationRotationInRads;

          if ( snapshot.hasData && snapshot.data != null ){ //has data

            final currentLocation = Coordinates( snapshot.data!.latitude, snapshot.data!.longitude ); 

            if ( targetLocation != null ){

              targetLocationRotationInRads= double.parse( 
                currentLocation
                  .getRotationFromNorthTo( targetLocation )
                  .toStringAsFixed(5) 
              );

            }

            return ( 
              targetLocationRotationInRads != null
              && targetLocationRotationInRads.isFinite 
            )
            ? Column( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text( 
                  "Your current position is \n" 
                  "${ currentLocation.latitude }, ${ currentLocation.longitude }\n"
                  "Go to Profile Tab to enable/disable sharing." 

                ),
                 
                  Column(
                    children: [
                      targetLocation != null 
                      ?Text(
                          "Your distance is ${ currentLocation.distanceInMetersTo( targetLocation ) } meters.\n"
                          "Rotate clockwise ${ ( targetLocationRotationInRads * 57.29 ).round() } degress from North, "
                          "in order to look towards ${appState.targetName}.",
                          textAlign: TextAlign.center,
                        )
                      :const Text( "Not following anyone's location" ),
                        Center(child: 
                          CompassView( targetLocationRotationInRads: targetLocationRotationInRads )
                        )

                    ],
                  )                
                ],
            )
            : const CircularProgressIndicator();
          }
          else{
            if ( snapshot.connectionState == ConnectionState.active && snapshot.hasError ){
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text( "There was an error with the location service." ),
                    TextButton(
                      onPressed: ()async{
                        await Geolocator.getCurrentPosition();
                        setState(() {
                        });
                      }, 
                      child: const Text("Retry")
                    )                  
                  ],
              );
            }
            return const CircularProgressIndicator();
          }
        }
      )
    );
  }
}