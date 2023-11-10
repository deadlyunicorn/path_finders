import 'dart:math' as math;

class Coordinates {

  /// latitude in decimal degrees.
  double latitude;
  /// longitude in decimal degrees.
  double longitude;

  Coordinates(  this.latitude, this.longitude );

  /// Find the distance from current point ( 0, 0 ) to point B.
  /// this can also be reffered to as ΔCoordinates.
  Coordinates getDifference( Coordinates pointB ){

    return Coordinates( pointB.latitude - latitude, pointB.longitude - longitude );
  }

  /// Find the distance from point A ( 0, 0 ) to point B.
  static Coordinates getDifferenceOfSpecific( Coordinates pointA, Coordinates pointB ){

    return Coordinates( pointB.latitude - pointA.latitude, pointB.longitude - pointA.longitude );
  }

  /// How many rads ( clockwise ) should you rotate from North
  /// in order to face the coordinate location.
  double getRotationFromNorthTo( Coordinates pointB ){

    Coordinates deltaCoordinates = getDifference(pointB);
    double latitude = deltaCoordinates.latitude;
    double longitude = deltaCoordinates.longitude;

    
    if ( longitude >= 0 ){
     
      if ( latitude >= 0 ){
        return math.atan2( longitude, latitude );
      }
      else{  // latitude < 0
        return  -math.atan2( latitude, longitude ) + math.pi / 2 ;
      }
    }
    else{ // longitude < 0

      if ( latitude >= 0 ){
        // math.tan() returns a negative here.
        return  math.atan2(  longitude, latitude );
      }
      else{ // latitude < 0
        return  -math.atan2( latitude, longitude ) - 3 * math.pi / 2 ;
      }
    }

  }


  static const int _equatorRadiusInMeters = 6378000; // 6_378 km // 6_378_000 meters
  static const double _degreesToRadians = math.pi / 180;
  /// Get the distance from the current coordinates,
  /// to point B in meters.
  /// 
  /// Uses the Haversine formula.
  /// Error is about 0.1% or 1 meter per kilometer.
  int distanceInMetersTo(
    Coordinates pointB,
  ){
    
    double latitudeInRadsA = latitude * _degreesToRadians;
    double longitudeInRadsA = longitude * _degreesToRadians;

    double latitudeInRadsB = pointB.latitude * _degreesToRadians;
    double longitudeInRadsB = pointB.longitude * _degreesToRadians;

    double angularSeparationFactor = 
      math.pow( 
        math.sin( 
          ( latitudeInRadsB - latitudeInRadsA ) / 2 
        ),
        2 
      ) +
      math.cos( latitudeInRadsA ) *
      math.cos( latitudeInRadsB ) *
      math.pow(
        math.sin(
          ( longitudeInRadsB - longitudeInRadsA ) / 2
        ),
        2
      )
    ;

    double centralAngle = 2 * 
      math.atan2( 
        math.sqrt( angularSeparationFactor ),
        math.sqrt( 1 - angularSeparationFactor ) 
    );

    return (centralAngle * _equatorRadiusInMeters).round();  

  }

  


  @override
  /// Get Coordinates as a String.
  /// 
  /// Format is "$latitude, $longitude"
  /// e.g. "20.2341, 42.1231".
  String toString() {
    return "$latitude, $longitude";
  }


}