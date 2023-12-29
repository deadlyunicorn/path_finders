import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/custom/styles.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:path_finders/src/tracker/current_position_view.dart';
import 'package:path_finders/src/tracker/distance_to_target_view.dart';
import 'package:path_finders/src/tracker/loading_view_with_taking_too_long_message.dart';
import 'package:path_finders/src/custom/is_landscape.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/custom/storage_services.dart';
import 'package:path_finders/src/tracker/compass/compass_view.dart';
import 'package:path_finders/src/types/coordinates.dart';

class TrackerView extends StatefulWidget{

  const TrackerView({ super.key });

  @override
  State<TrackerView> createState() => _TrackerViewState();
}

class _TrackerViewState extends State<TrackerView> {

  bool notificationIsEnabled = false;

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
    final appLocalizations = AppLocalizations.of(context)!;

    return Center(
      child: StreamBuilder( //position stream

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

              //The row is used on landscape mode.
              return Row(  
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column( 
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DistanceToTargetView(
                        appState: appState,
                        distanceToTarget: distanceToTarget, 
                        appLocalizations: appLocalizations,
                        notificationIsEnabled: notificationIsEnabled, 
                        targetLocation: targetLocation),
                      isLandscape(context)
                        ?const SizedBox.shrink()
                        :CompassView( 
                          targetLocationRotationInRads: targetLocationRotationInRads, 
                          targetLocation: targetLocation,
                          distanceToTarget: distanceToTarget,
                        ),
                      CurrentPositionView(appLocalizations: appLocalizations, currentLocation: currentLocation)
                     
                    ],
                  ),
                  isLandscape(context)
                    ?Expanded(
                      child: CompassView(
                        targetLocationRotationInRads: targetLocationRotationInRads, 
                        targetLocation: targetLocation,
                        distanceToTarget: distanceToTarget,
                      )
                    ) 
                    :const SizedBox.shrink()

                ],
              ) ;
            }
            else{
              return Column( //retry
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( appLocalizations.errors_locationService ),
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
            return LoadingViewWithTakingTooLongMessage(appLocalizations: appLocalizations);
          }
        }
      )
    );
  }

}
