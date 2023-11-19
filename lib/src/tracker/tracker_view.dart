
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/tracker/location_allowed_view.dart';
import 'package:path_finders/src/tracker/geolocator_controller.dart';

class SensorsView extends StatefulWidget{

  const SensorsView({super.key});
  

  @override
  State<SensorsView> createState() => _SensorsViewState();
}

class _SensorsViewState extends State<SensorsView> {

  void reinvokeGeolocator ()async{
    try{
      await Geolocator.getCurrentPosition();
      setState((){
        sensors = GeolocatorController();
      });
    }
    catch(_){}
  }

  GeolocatorController sensors = GeolocatorController();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<bool>(
      future: sensors.hasLocationPermission, 
      builder: (context, snapshot){
        if ( snapshot.hasData ){
          return snapshot.data == true
            ? const LocationAllowedView()
            : Center ( child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Can't get location.. Is GPS enabled?"),
                  TextButton(
                    onPressed: reinvokeGeolocator, 
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
        else{ //not mounted yet.
          return const SizedBox.shrink();
        }
      });

    
  }
}



