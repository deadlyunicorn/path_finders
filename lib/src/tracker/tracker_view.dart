import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/tracker/compass/compass_view.dart';
import 'package:path_finders/src/tracker/format_distance.dart';
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
  void initState() {

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

      await Future.delayed( const Duration( seconds: 3) )
        .then((value){
          ScaffoldMessenger.of( context )
          .showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: const Duration( seconds: 5 ),
              backgroundColor: Colors.blue.shade700 ,
              content: 
                Text( 
                  "Go to 'Profile' Tab to enable/disable location sharing.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).indicatorColor
                  ),
                ),
            )
          );
        });
      
    });
    
  }

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
                  .toStringAsFixed(7) 
              );


            }

            

            return Column( 
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    distanceToTarget != null ? 
                      RichText( 
                        text: 
                        ( distanceToTarget < 7 )
                        ?const TextSpan( text:"Your friend is nearby!" )
                        :TextSpan(
                          text:"Your distance to ${appState.targetName} is \n",
                          children: [ 
                            TextSpan( 
                              style: const TextStyle( fontSize: 24 ),
                              text: DistanceFormatter.metersFormatter( distanceToTarget )
                            )
                          ]
                        ),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1.5),
                      )
                      :const SizedBox.shrink(),
                    const SizedBox( height: 5 ),
                  ],
                ),
                Expanded(

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children:
                      (
                        targetLocation != null 
                        && distanceToTarget != null
                        && targetLocationRotationInRads != null
                        && targetLocationRotationInRads.isFinite
                      ) 

                      ?[
                          const SizedBox.square( dimension:  8),
                          CompassView( targetLocationRotationInRads: targetLocationRotationInRads ),
                          Text( 
                            "Your current position is \n" 
                            "${ currentLocation.latitude.toStringAsFixed(7)}, ${ currentLocation.longitude.toStringAsFixed(7) }",
                            textScaler: const TextScaler.linear( 1.5 ),
                            textAlign: TextAlign.center,
                          )
                      ]

                      :[
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                          child: const Center( 
                            child: Text( 
                              "Select a 'Target' at the 'Friends' Tab",
                              textScaler: TextScaler.linear( 1.4 ),
                            ),
                          )
                        ) 
                      ],
                  )

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