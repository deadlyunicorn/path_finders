import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/sensors/sensors_controller.dart';

class SensorsView extends StatefulWidget{

  const SensorsView({super.key});
  

  @override
  State<SensorsView> createState() => _SensorsViewState();
}

class _SensorsViewState extends State<SensorsView> {

  String locationText = "loading location..";

  @override
  Widget build(BuildContext context) {

    SensorsController sensors = SensorsController();
    sensors.determinePosition.then((
      location
    ){
      setState(() {
        locationText = location.toString();
      }); 
    });

    return(
      Row(
        children: [
          
          Text( locationText )
        ],
      )
    );
  }
}