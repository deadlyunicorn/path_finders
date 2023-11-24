import 'package:flutter/material.dart';
import 'package:path_finders/src/storage_services.dart';

class TargetListingsProvider with ChangeNotifier{

  Set<String> _targetEntries = {};

  void initializeTargetEntries( Set<String> initialEntriesFromFile){
    _targetEntries = initialEntriesFromFile;
  }

  Future<void> addTargetEntry( String targetEntry ) async{

    await TargetsFile.writeTarget(targetEntry);
    _targetEntries.add( targetEntry );
    notifyListeners();
  }

  Future<void> removeTargetEntry( String targetEntry ) async{

    await TargetsFile.removeTargetFromFile( targetEntry );
    _targetEntries.remove( targetEntry );
    notifyListeners();
  }

  Set<String> get targetEntries => _targetEntries;
 
}