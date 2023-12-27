import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/custom/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:path_finders/src/copying_service.dart';
import 'package:path_finders/src/custom/is_landscape.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:path_finders/src/tracker/compass/compass_view.dart';
import 'package:path_finders/src/tracker/format_distance.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:url_launcher/url_launcher.dart';

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
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of( context )
              .showSnackBar(
                CustomSnackBar(
                  textContent: AppLocalizations.of(context)!.snackbar_tip1,
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
    final appLocalizations = AppLocalizations.of(context);



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



              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column( 
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: isLandscape(context)? MediaQuery.sizeOf(context).width * 0.5 :MediaQuery.sizeOf(context).width * 0.85,
                        child: Padding(
                          padding: const EdgeInsets.only( top: 8 ),
                          child: distanceToTarget < 15
                            ?Text(
                              appLocalizations!.tracking_nearby,
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            )
                            :Column( 
                              children:[
                                Text( 
                                  " ${ appLocalizations!.tracking_distanceToIs(appState.targetName)}",
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.center,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 48,
                                    ),
                                    Text( 
                                      DistanceFormatter.metersFormatter( distanceToTarget ),
                                      style: Theme.of(context).textTheme.headlineMedium,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      width: 48,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: IconButton(
                                          onPressed: ()async{
                                            await launchUrl( Uri.parse( "http://maps.google.com/maps?daddr=${targetLocation.toString()}" ));
                                          },
                                          tooltip: appLocalizations.tracking_showOnMap,
                                          color: Theme.of(context).colorScheme.primary,
                                          icon: const Icon ( Icons.navigation_outlined ),
                                        ),
                                      ),
                                    )
                                    
                                  ],
                                )
                              ]
                            ),
                        ),
                      ),
                      isLandscape(context)
                        ?const SizedBox.shrink()
                        :CompassView( 
                          targetLocationRotationInRads: targetLocationRotationInRads, 
                          targetLocation: targetLocation,
                          distanceToTarget: distanceToTarget,
                        ),
                      Column(
                        children: [

                           Text(
                              appLocalizations.tracking_currentPositionIs
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
                              "${ currentLocation.latitude.toStringAsFixed(7)}, ${ currentLocation.longitude.toStringAsFixed(7) }",
                              textScaler: const TextScaler.linear( 1.5 ),
                              textAlign: TextAlign.center,
                              )
                            )

                        ],
                      )
                     
                  ],
                ),
                isLandscape(context)
                  ?Expanded(
                    child: CompassView(
                      targetLocationRotationInRads: targetLocationRotationInRads, 
                      targetLocation: targetLocation,
                      distanceToTarget: distanceToTarget
                    )
                  ) 
                  :const SizedBox.shrink()

                ],
              ) ;

            }
            else{
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( appLocalizations!.errors_locationService ),
                    TextButton(
                      style: squaredButtonStyle,
                      onPressed: ()async{
                        await Geolocator.getCurrentPosition();
                        setState(() {
                        });
                      }, 
                      child: Text( appLocalizations.errors_retry )
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
                  return Center ( 
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        const CircularProgressIndicator(),
                        Positioned(
                          bottom: -75,
                          child: Column(
                            children: [
                              Text( 
                                appLocalizations!.errors_geolocatorTimeout,
                                textAlign: TextAlign.center
                              ),
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