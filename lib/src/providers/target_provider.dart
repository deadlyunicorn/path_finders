import 'package:flutter/material.dart';
import 'package:path_finders/src/types/coordinates.dart';

class TargetProvider with ChangeNotifier{

  Coordinates _targetLocation = Coordinates( 0, 0);
  String _targetName = "Earth's Center";

  void setTargetLocation( Coordinates newLocation ){

    _targetLocation = newLocation;
    notifyListeners();

  }

  void setTargetName( String newName ){
    
    _targetName = newName;
    notifyListeners();

  }

  Coordinates get targetLocation => _targetLocation;
  String get targetName => _targetName;

}