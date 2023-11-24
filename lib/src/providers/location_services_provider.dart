import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:path_finders/src/tracker/geolocator_controller.dart';

class LocationServicesProvider with ChangeNotifier{

  GeolocatorController _sensors = GeolocatorController();


  void reinvokeGeolocator ()async{
    try{
      await Geolocator.getCurrentPosition();
      _sensors = GeolocatorController();
      notifyListeners();
    }
    catch(_){}
  }
  
  Future<Position?> getPosition() async{
    try{
      final position = await Geolocator.getCurrentPosition();
      return position;
    }
    catch( _ ){
      return null;
    }
  }



  GeolocatorController get sensors => _sensors;

}