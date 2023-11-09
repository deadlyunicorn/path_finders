import 'package:flutter/material.dart';

class TargetListingsProvider extends ChangeNotifier{

  Set<String> _targetEntries = { "12-312", "23-312" };

  addTargetEntry( String targetEntry ){
    _targetEntries.add( targetEntry );
    notifyListeners();
  }

  removeTargetEntry( String key ){
    _targetEntries.remove(key);
    notifyListeners();
  }

  Set<String> get targetEntries => _targetEntries;
 
}