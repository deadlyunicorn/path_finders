import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/copying_service.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/storage_services.dart';
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

      await AppearancesCounterFile.getSnackBarCounter()
        .then( (value) async {
          if ( value != 0 ){
            await Future.delayed( const Duration( seconds: 3) )
            .then((_){
              ScaffoldMessenger.of( context )
              .showSnackBar(
                CustomSnackBar(
                  textContent: "Go to 'Profile' Tab to enable/disable location sharing.",
                  duration: const Duration( seconds: 5 ),
                  context: context,
                ),
              );
            }
          );

          }
        });
      
      
    }
  );
    
  }

  @override
  Widget build(BuildContext context) {

    final TargetProvider appState = context.watch<TargetProvider>();
    final Coordinates targetLocation = appState.targetLocation;


    return Center(
      child: StreamBuilder(
        //This might take too long to resolve!
        //This is due to the accuracy --
        stream: Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            //don't use the "Time Limit" option 
            //as you will need to add a 'retry' button
            //to get out of the exception
          )
        ), 
        builder: (context, positionStreamSnapshot) {

          if ( positionStreamSnapshot.connectionState == ConnectionState.active ){

            final positionStreamSnapshotData = positionStreamSnapshot.data;

            if ( positionStreamSnapshot.hasData 
              && positionStreamSnapshotData != null 
            ){ //has position data

              final currentLocation = Coordinates( 
                positionStreamSnapshotData.latitude, 
                positionStreamSnapshotData.longitude 
              ); 
              final int distanceToTarget = currentLocation.distanceInMetersTo( targetLocation );
              final double targetLocationRotationInRads = double.parse( 
                  currentLocation
                    .getRotationFromNorthTo( targetLocation )
                    .toStringAsFixed(7) 
              );

              return Column( 
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      RichText( 
                        text: 
                        ( distanceToTarget < 15 )
                        ?TextSpan( 
                          text:"Your friend is nearby!",
                          style: TextStyle( color: Theme.of(context).colorScheme.primary ),
                        )
                        :TextSpan(
                          text:"Your distance to ${appState.targetName} is \n",
                          style: TextStyle( color: Theme.of(context).colorScheme.primary ),
                          children: [ 
                            TextSpan( 
                              style: const TextStyle( fontSize: 24 ),
                              text: DistanceFormatter.metersFormatter( distanceToTarget )
                            )
                          ]
                        ),
                        textAlign: TextAlign.center,
                        textScaler: const TextScaler.linear(1.5),
                      ),
                      const SizedBox( height: 5 ),
                    ],
                  ),
                  Expanded(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const SizedBox.square( dimension:  8),
                        CompassView( 
                          targetLocationRotationInRads: targetLocationRotationInRads, 
                          targetLocation: targetLocation 
                        ),
                        TextButton(
                          style: const ButtonStyle(
                            shape: MaterialStatePropertyAll( 
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all( Radius.circular( 4 ) )
                              )
                            )
                          ),
                          onPressed: (){},
                          onLongPress: ()async{
                            await CopyService.copyTextToClipboard( 
                              context: context,
                              "${ currentLocation.latitude.toStringAsFixed(7)}, ${ currentLocation.longitude.toStringAsFixed(7) }" 
                            );
                          }, 
                          child: Text( 
                          "Your current position is \n" 
                          "${ currentLocation.latitude.toStringAsFixed(7)}, ${ currentLocation.longitude.toStringAsFixed(7) }",
                          textScaler: const TextScaler.linear( 1.5 ),
                          textAlign: TextAlign.center,
                          )
                        )
                        
                      ]
                    )
                  )                
                ],
              );

            }
            else{
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
          }
          else{
            

            return FutureBuilder(
              future: Future.delayed( const Duration( seconds: 3)), 
              builder: ( context, timerFutureSnapshot){
                if ( timerFutureSnapshot.connectionState == ConnectionState.done ){
                  return const Center ( 
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        CircularProgressIndicator(),
                        Positioned(
                          bottom: -75,
                          child: Column(
                            children: [
                              Text("This might take a while if you are not out in the open."),
                              Text("You could try moving your device around."),
                              Text("Or restarting the app."),
                            ],
                          )
                        )
                      ],
                    )
                  );
                }
                else{
                  return const CircularProgressIndicator(); 
                }
              }
            );

          }
        }
      )
    );
  }
}