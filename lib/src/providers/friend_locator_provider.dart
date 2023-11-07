import 'package:flutter/material.dart';
import 'package:path_finders/src/types/coordinates.dart';

class FriendLocatorProvider with ChangeNotifier{

  Coordinates _pointOfInterest = Coordinates( 0, 0);

  void setPointOfInterest( Coordinates newValue ){

    _pointOfInterest = newValue;
    notifyListeners();

  }

  get pointOfInterest => _pointOfInterest;
  

}