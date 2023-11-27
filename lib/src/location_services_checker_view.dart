import 'package:flutter/material.dart';
import 'package:path_finders/src/providers/location_services_provider.dart';
import 'package:provider/provider.dart';

class LocationServicesCheckerView extends StatelessWidget{
  
  final Widget child;
  const LocationServicesCheckerView( {super.key, required this.child});

  @override
  Widget build(BuildContext context) {

    final locationServicesProvider = context.watch<LocationServicesProvider>();

    return Center ( 
      child: FutureBuilder<bool>(
        future: locationServicesProvider.sensors.hasLocationPermission, 
        builder: (context, snapshot){

          if ( snapshot.connectionState == ConnectionState.done ){

            if ( snapshot.hasData && snapshot.data == true ){
              return child;
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
                  const Text("Can't get location.. Is GPS enabled?"),
                  TextButton(
                    onPressed: locationServicesProvider.reinvokeGeolocator, 
                    child:  const Text( "Retry") )
                ],
              );
          }
          else{ //Loading..
            return const CircularProgressIndicator();
          }
        }
      )
    );
  }
}