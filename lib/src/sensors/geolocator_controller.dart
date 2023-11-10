
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeolocatorController with ChangeNotifier{

  GeolocatorController();
  

  Future<bool> _hasLocationPermission() async{
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if( !serviceEnabled ){
      return false;
      // return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if ( permission == LocationPermission.denied ){
      permission = await Geolocator.requestPermission();
      if ( permission == LocationPermission.denied){
        return false;
        // return Future.error("Location permission denied");
      }
    }
    else if ( permission == LocationPermission.deniedForever ){
      return false;
      // return Future.error( "Please enable the location permission via your settings");
    }

    return true;
  }

  Future<bool> get hasLocationPermission => _hasLocationPermission();
}

