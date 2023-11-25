import 'package:flutter/material.dart';
import 'package:path_finders/src/providers/location_services_provider.dart';
import 'package:provider/provider.dart';

class LocationServicesCheckerView extends StatelessWidget{
  
  final Widget child;
  const LocationServicesCheckerView( {super.key, required this.child});

  @override
  Widget build(BuildContext context) {

    final locationServicesProvider = context.watch<LocationServicesProvider>();

    return FutureBuilder<bool>(
      future: locationServicesProvider.sensors.hasLocationPermission, 
      builder: (context, snapshot){
        if ( snapshot.hasData ){
          return snapshot.data == true
            ? child
            : Center ( child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Can't get location.. Is GPS enabled?"),
                  TextButton(
                    onPressed: locationServicesProvider.reinvokeGeolocator, 
                    child:  const Text( "Retry") )
                ],
              )
            );
        }
        else if( snapshot.hasError ){
          return (
            const Center( child:  Text("No location services found.") ) 
          ); 
        }
        else{ 
          
          if ( snapshot.connectionState == ConnectionState.done ){
            return Center ( child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Can't get location.. Is GPS enabled?"),
                  TextButton(
                    onPressed: locationServicesProvider.reinvokeGeolocator, 
                    child:  const Text( "Retry") )
                ],
              )
            );
          }
          else{
            //not mounted yet.
            return const SizedBox.shrink();
          }
          
        }
      });
  }
}