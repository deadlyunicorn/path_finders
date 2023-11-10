import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/sensors/location_views/compass_view.dart';
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

    TargetProvider appState = context.watch<TargetProvider>();

    Coordinates targetLocation = appState.targetLocation;

    return Center(
      child: StreamBuilder(
        stream: Geolocator.getPositionStream(), 
        builder: (context, snapshot) {

          double targetLocationRotationInRads = num.parse( 
            currentPosition
              .getRotationFromNorthTo( targetLocation )
              .toStringAsFixed(5) 
          ) as double;

          if ( snapshot.hasError ){
            return const Text( "Failed getting data");
          }
          else if ( snapshot.hasData ){

            currentPosition = Coordinates( snapshot.data!.latitude, snapshot.data!.longitude ); 

            return Column( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text( 
                  "Your current position is \n" 
                  "${ currentPosition.latitude }, ${ currentPosition.longitude }" 
                ),
                targetLocationRotationInRads.isFinite 
                  ? Column(
                    children: [
                      Text(
                          "Rotate clockwise ${targetLocationRotationInRads * 57.29 } degress from North,"
                          "in order to look towards ${appState.targetName}.",
                          textAlign: TextAlign.center,
                        ),
                        Center(child: 
                          CompassView( targetLocationRotationInRads: targetLocationRotationInRads )
                        )

                    ],
                  )
                
                  : const CircularProgressIndicator()
              ],
            );
          }
          else{
            return const CircularProgressIndicator();
          }
        }
    )
      
    );
  }
}