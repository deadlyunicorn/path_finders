import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:path_finders/src/sensors/sensors_controller.dart';

class SensorsView extends StatefulWidget{

  const SensorsView({super.key});
  

  @override
  State<SensorsView> createState() => _SensorsViewState();
}

class _SensorsViewState extends State<SensorsView> {

  // ignore: unnecessary_cast
  var sensorsView = LoadingLocationView() as Widget;

  @override
  Widget build(BuildContext context) {

    SensorsController sensors = SensorsController();
    sensors.hasLocationPermission.then((value) {

      setState(() {
        sensorsView = value 
        ? LocationAllowedView()
        : LocationNotAllowedView();
      });
      
    });

    return sensorsView;

    
  }
}

class LocationAllowedView extends StatefulWidget{

  LocationAllowedView({ super.key });

  @override
  State<LocationAllowedView> createState() => _LocationAllowedViewState();
}

class _LocationAllowedViewState extends State<LocationAllowedView> {

  String currentPosition = "Unknown";
  CompassEvent? _lastRead;
  

  @override
  Widget build(BuildContext context) {

    return Center(child: 
      _buildCompass()
    );
  }

  Widget _buildCompass(){
    return StreamBuilder<CompassEvent>(
      stream: FlutterCompass.events, 
      builder: (context, snapshot){
        if ( snapshot.hasError){
          return Text("Error reading");
        }
        if ( snapshot.connectionState == ConnectionState.waiting ){
          return Center(child: CircularProgressIndicator());
        }

        double? direction = snapshot.data!.heading;

        if ( direction == null ){
          return Center(
            child: Text("Your device doesn't have the required sensors")
          );
        }

        return Container(
          padding: EdgeInsets.all(40),
          child: Material(
            shadowColor: Colors.purple,
            shape: CircleBorder( 
              side: BorderSide( 
                color: Colors.blue.shade900.withAlpha(50),
                width: 10
                )
              ),
            clipBehavior: Clip.antiAlias,
            elevation: 10,
            color: Colors.red.withAlpha(50),
            child: Container(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: ( direction * ( math.pi / 180 ) * -1 ),
                child: const Icon(
                  Icons.straight, 
                  size: 120,
                )
              )
            ),
          )
        );
          
        
      }
    );
  }
}

class LocationNotAllowedView extends StatelessWidget{
  LocationNotAllowedView( { super.key } );
  @override
  Widget build(BuildContext context) {
    return(
      Row(
        children: [
          
          Text("No location access. Retry button.")
        ],
      )
    );
  }
}

class LoadingLocationView extends StatelessWidget{

  LoadingLocationView( {super.key} );
   @override
  Widget build(BuildContext context) {
    return(
      Center(child: CircularProgressIndicator())
    );
  }
}