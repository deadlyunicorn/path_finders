
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class SensorsController with ChangeNotifier{

  SensorsController();


  Future<Position> _determinePosition() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if( !serviceEnabled ){
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if ( permission == LocationPermission.denied ){
      permission = await Geolocator.requestPermission();
      if ( permission == LocationPermission.denied){
        return Future.error("Location permission denied");
      }
    }
    else if ( permission == LocationPermission.deniedForever ){
      return Future.error( "Please enable the location permission via your settings");
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Position> get determinePosition => _determinePosition();
}

