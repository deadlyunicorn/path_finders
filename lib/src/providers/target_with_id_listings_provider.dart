import 'package:flutter/material.dart';
import 'package:path_finders/src/storage_services.dart';

class TargetWithIdListingsProvider with ChangeNotifier{

  List _targetWithIdEntries = [];

  void initializeTargetWithIdEntries( List initialEntriesFromFile){

    _targetWithIdEntries = initialEntriesFromFile;
  }

  Future<void> addTargetWithIdEntry( String targetId, { String? targetName } ) async{

    await TargetsFiles.writeTargetWithId(targetId, targetName: targetName);
    notifyListeners();
  }

  Future<void> removeTargetWithIdEntry( String targetId ) async{

    await TargetsFiles.removeTargetWithIdFromFile( targetId );
    notifyListeners();
  }

  List get targetEntries => _targetWithIdEntries;
 
}