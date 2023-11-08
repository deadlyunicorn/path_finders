import 'package:flutter/material.dart';
import 'package:path_finders/src/types/coordinates.dart';

class FriendLocatorProvider with ChangeNotifier{

  Coordinates _pointOfInterest = Coordinates( 0, 0);
  String _friendlyNameOfPoint = "Earth's Center";

  void setPointOfInterest( Coordinates newValue ){

    _pointOfInterest = newValue;
    notifyListeners();

  }

  void setFriendlyNameOfPoint( String newName ){
    
    _friendlyNameOfPoint = newName;
    notifyListeners();

  }

  get pointOfInterest => _pointOfInterest;
  get friendlyNameOfPoint => _friendlyNameOfPoint;

}