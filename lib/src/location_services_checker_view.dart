import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:path_finders/src/custom/styles.dart';
import 'package:path_finders/src/providers/location_services_provider.dart';
import 'package:provider/provider.dart';

class LocationServicesCheckerView extends StatefulWidget{
  
  final Widget child;
  const LocationServicesCheckerView( {super.key, required this.child});

  @override
  State<LocationServicesCheckerView> createState() => _LocationServicesCheckerViewState();
}

class _LocationServicesCheckerViewState extends State<LocationServicesCheckerView> {
  @override
  Widget build(BuildContext context) {

    final appLocalizations = AppLocalizations.of( context );
    final locationServicesProvider = context.watch<LocationServicesProvider>();

    return Center ( 
      child: FutureBuilder<bool>(
        future: locationServicesProvider.sensors.hasLocationPermission, 
        builder: (context, snapshot){

          if ( snapshot.connectionState == ConnectionState.done ){

            if ( snapshot.hasData && snapshot.data == true ){
              return widget.child;
            }
            // else if( snapshot.hasError ){
            //   return (
            //     const Center( child:  Text("No location services found.") ) 
            //   ); 
            // }

            //has loaded but something is wrong.
            return 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text( appLocalizations!.errors_gpsFailed ),
                  TextButton(
                    style: squaredButtonStyle,
                    onPressed: locationServicesProvider.reinvokeGeolocator, 
                    child:  Text( appLocalizations.errors_retry ) )
                ],
              );
          }
          else{ //Loading..
            return FutureBuilder(
              future: Future.delayed( const Duration( seconds: 5)), 
              builder: (_, timerSnapshot ){
                if ( timerSnapshot.connectionState == ConnectionState.done ){
                  return TextButton(
                    style: squaredButtonStyle,
                    onPressed: (){
                      locationServicesProvider.reinvokeGeolocator();
                      setState(() {
                        
                      });
                    }, 
                    child:  Text( appLocalizations!.errors_compassLoad ) );
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