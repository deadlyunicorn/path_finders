import 'package:flutter/material.dart';
import 'package:path_finders/src/storage_services.dart';

class TargetListingsProvider with ChangeNotifier{

  List _targetEntries = [];

  void initializeTargetEntries( List initialEntriesFromFile){

    _targetEntries = initialEntriesFromFile;
  }

  Future<void> addTargetWithIdEntry( String targetId, { String? targetName } ) async{

    await TargetsFiles.writeTargetWithId(targetId, targetName: targetName);

    _targetEntries.add( { 
      "targetId": targetId,
      "targetName": targetName
    } );
    
    notifyListeners();
  }

  Future<void> removeTargetWithIdEntry( String targetId ) async{

    await TargetsFiles.removeTargetWithIdFromFile( targetId );
    _targetEntries.remove( targetId );
    notifyListeners();
  }

  List get targetEntries => _targetEntries;
 
}