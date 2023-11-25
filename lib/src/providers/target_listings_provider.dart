import 'package:flutter/material.dart';
import 'package:path_finders/src/storage_services.dart';

class TargetListingsProvider with ChangeNotifier{

  List _targetEntries = [];

  void initializeTargetEntries( List initialEntriesFromFile){

    _targetEntries = initialEntriesFromFile;
  }

  Future<void> addTargetEntry( String targetId, { String? targetName } ) async{

    await TargetsFile.writeTarget(targetId, targetName: targetName);

    _targetEntries.add( { 
      "targetId": targetId,
      "targetName": targetName
    } );
    
    notifyListeners();
  }

  Future<void> removeTargetEntry( String targetId ) async{

    await TargetsFile.removeTargetFromFile( targetId );
    _targetEntries.remove( targetId );
    notifyListeners();
  }

  List get targetEntries => _targetEntries;
 
}