import 'dart:math' as math;

class Coordinates {

  double latitude;
  double longitude;

  Coordinates(  this.latitude, this.longitude );

  /// Find the distance from current point ( 0, 0 ) to point B.
  Coordinates getDifference( Coordinates pointB ){

    return Coordinates( pointB.latitude - latitude, pointB.longitude - longitude );
  }

  /// Find the distance from point A ( 0, 0 ) to point B.
  Coordinates getDifferenceOfSpecific( Coordinates pointA, Coordinates pointB ){
    return Coordinates( pointB.latitude - pointA.latitude, pointB.longitude - pointA.longitude );
  }

  /// How many degrees ( clockwise ) should you rotate from North
  /// in order to face the coordinate location.
  double getRotationFromNorth(){

    if ( longitude > 0 ){
     
      if ( latitude > 0 ){
        return num.parse( math.atan( ( longitude / latitude ) ).toStringAsFixed(2) ) as double;
      }
      else{  // latitude < 0
        return num.parse( ( -math.atan( ( latitude  / longitude ) ) + math.pi / 2  ).toStringAsFixed(2) ) as double;
      }
    }
    else{ // longitude < 0

      if ( latitude > 0 ){
        // math.tan() returns a negative here.
        return num.parse( math.atan(  ( longitude / latitude ) ).toStringAsFixed(2) ) as double;
      }
      else{ // latitude < 0
        return num.parse( ( - math.atan( latitude / longitude ) - math.pi / 2 ).toStringAsFixed(2) ) as double;
      }
    }
  }


  @override
  String toString() {
    return "$latitude, $longitude";
  }


}