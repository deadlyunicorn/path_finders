import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/tracker/compass/compass_view.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:provider/provider.dart';

class TrackerView extends StatefulWidget{

  const TrackerView({ super.key });

  @override
  State<TrackerView> createState() => _TrackerViewState();
}

class _TrackerViewState extends State<TrackerView> {

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
            final int? distanceToTarget = targetLocation != null? currentLocation.distanceInMetersTo( targetLocation ) :null;


            if ( targetLocation != null ){

              targetLocationRotationInRads= double.parse( 
                currentLocation
                  .getRotationFromNorthTo( targetLocation )
                  .toStringAsFixed(5) 
              );


            }

            return Column( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text( 
                  "Your current position is \n" 
                  "${ currentLocation.latitude }, ${ currentLocation.longitude }\n"
                  "Go to Profile Tab to enable/disable sharing.",
                  textAlign: TextAlign.center,
                  
                ),
                Column(
                  children: [
                    (
                      targetLocation != null 
                      && distanceToTarget != null
                      && targetLocationRotationInRads != null
                      && targetLocationRotationInRads.isFinite
                    ) 

                    ?Column(
                      children: [
                        Center( 
                          child: 
                          ( distanceToTarget < 7 )
                          ?const Text( "Your friend is nearby!" )
                          :Text(
                            "Your distance is $distanceToTarget meters.\n"
                            "Rotate clockwise ${ ( targetLocationRotationInRads * 57.29 ).round() } degress from North, "
                            "in order to look towards ${appState.targetName}.",
                            textAlign: TextAlign.center,
                          )
                        ),
                        Center(child: 
                          CompassView( targetLocationRotationInRads: targetLocationRotationInRads )
                        )
                      ],
                    ) 
                    :SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: const Center( child: 
                       Text( 
                        "Select someone to locate, at the 'Friends' Tab.",
                        style: TextStyle( color: Colors.red ), )
                      ),
                    ) ,
                  ],
                )                
              ],
            );
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