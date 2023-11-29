import 'package:flutter/material.dart';
import 'package:path_finders/src/storage_services.dart';

class TargetWithIdListingsProvider with ChangeNotifier{

  List _targetWithIdEntries = [];

  void notifyConsumers(){
    notifyListeners();
  }

  void setTargetWithIdEntries( List targetWithIdEntries){
    _targetWithIdEntries = targetWithIdEntries;
    notifyListeners();
  }

  Future<void> addTargetWithIdEntry( String targetId, { String? targetName } ) async{

    await TargetsFiles.writeTargetWithId(targetId, targetName: targetName);
    _targetWithIdEntries.add( { "targetId": targetId, "targetName": targetName } );
    notifyListeners();
  }

  Future<void> removeTargetWithIdEntry( String targetId ) async{

    await TargetsFiles.removeTargetWithIdFromFile( targetId );
    _targetWithIdEntries.removeWhere((element) => element["targetId"] == targetId );
    notifyListeners();
  }

  List get targetEntries => _targetWithIdEntries;
 
}