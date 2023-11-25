import 'package:flutter/material.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:path_finders/src/types/coordinates.dart';

class TargetWithCoordinatesListingsProvider with ChangeNotifier{

  List _targetWithCoordinatesEntries = [];

  void initializeTargetWithCoordinatesEntries( List initialEntriesFromFile){

    _targetWithCoordinatesEntries = initialEntriesFromFile;
  }

  Future<void> addTargetWithCoordinatesEntry( String targetName, Coordinates coordinates ) async{

    await TargetsFiles.writeTargetWithCoordinates( targetName, coordinates );
    notifyListeners();
  }

  Future<void> removeTargetWithCoordinatesEntry( String targetName ) async{

    if ( _targetWithCoordinatesEntries.where((element) => element["targetName"] == targetName ).isNotEmpty ){
      
      await TargetsFiles.removeTargetWithCoordinatesFromFile( targetName );
      // _targetWithCoordinatesEntries.removeWhere((element) => element["targetName"] == targetName );
      notifyListeners();

    }

  }

  List get targetEntries => _targetWithCoordinatesEntries;
 
}