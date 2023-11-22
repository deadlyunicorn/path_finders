import 'package:path_finders/src/types/coordinates.dart';

class TargetDetails{

  final Coordinates? _coordinates;
  final DateTime? _updatedAt;
  final String? _errorMessage;

  const TargetDetails( { 
    coordinates, 
    updatedAt, 
    errorMessage
  } )
    :
    _coordinates  = coordinates,
    _updatedAt    = updatedAt,
    _errorMessage = errorMessage 
  ;

  bool hasErrorMessage(){
    return _errorMessage != null;
  }

  Coordinates? getCoordinates(){
    return _coordinates;
  }

  DateTime? getUpdatedAt(){
    return _updatedAt;
  }

  String? getErrorMessage(){
    return _errorMessage;
  }

  



}