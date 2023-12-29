
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:path_finders/src/types/coordinates.dart';

class TargetProvider with ChangeNotifier{

  Coordinates _targetLocation = Coordinates(  90, 0 );
  String _targetName = "North Pole";

  void setTarget( { required String targetName, required Coordinates targetLocation }) async{

    await FlutterForegroundTask.saveData(key: "targetLocation", value: targetLocation.toString());
    await FlutterForegroundTask.saveData(key: "targetName", value: targetName);

    if ( await FlutterForegroundTask.isRunningService ) await FlutterForegroundTask.restartService();

    _targetLocation = targetLocation;
    _targetName = targetName;

    notifyListeners();


  }

  Coordinates get targetLocation => _targetLocation;
  String get targetName => _targetName;

}