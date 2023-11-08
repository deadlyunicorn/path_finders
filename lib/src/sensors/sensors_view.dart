
import 'package:flutter/material.dart';
import 'package:path_finders/src/sensors/location_views/location_allowed_view.dart';
import 'package:path_finders/src/sensors/location_views/location_loading_view.dart';
import 'package:path_finders/src/sensors/location_views/location_not_allowed_view.dart';
import 'package:path_finders/src/sensors/geolocator_controller.dart';

class SensorsView extends StatefulWidget{

  const SensorsView({super.key});
  

  @override
  State<SensorsView> createState() => _SensorsViewState();
}

class _SensorsViewState extends State<SensorsView> {

  var sensorsView = LoadingLocationView();

  @override
  Widget build(BuildContext context) {

    GeolocatorController sensors = GeolocatorController();

    return FutureBuilder<bool>(
      future: sensors.hasLocationPermission, 
      builder: (context, snapshot){
        if ( snapshot.hasData ){
          return snapshot.data == true
            ? const LocationAllowedView()
            : LocationNotAllowedView();
        }
        else if( snapshot.hasError ){
          return (
            const Text("There was an error getting your location.")
          ); 
        }
        else{ //not mounted yet.
          return const SizedBox.shrink();
        }
      });

    
  }
}



