class DistanceFormatter {

  static String metersFormatter( int distanceInMeters ){

    String distanceString = distanceInMeters.toString();
    int distanceStringLength = distanceString.length;
    
    if ( distanceInMeters >= 1000 ){

      List distanceInKilometersList = [];
      for ( int i = 0; distanceStringLength - 3 * i > 0; i++ ){

        distanceInKilometersList.add ( 
          distanceString.substring( 
            distanceStringLength - 3 * i - 3 > 0
              ?distanceStringLength - 3 * i - 3
              :0
            , distanceStringLength - 3 * i
          ) 
        );

      }
      String distanceInKilometersString = distanceInKilometersList.reversed.join(',');
      int indexOfLastComma = distanceInKilometersString.lastIndexOf(',');
      
      return "${distanceInKilometersString
        .replaceFirst( ',', '.', indexOfLastComma )
        .substring( 0, indexOfLastComma + 2)} km" ;
    }
    else {
      return "$distanceInMeters m";
    }

  }
}