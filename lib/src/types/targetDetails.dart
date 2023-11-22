import 'package:path_finders/src/types/coordinates.dart';

class TargetDetails{

  final Coordinates? coordinates;
  final DateTime updatedAt;
  final String? _errorMessage;

  TargetDetails( { 
    this.coordinates, 
    required this.updatedAt, 
    String? errorMessage
  } )
  : _errorMessage = errorMessage;

  bool hasErrorMessage(){
    return _errorMessage == null;
  }



}