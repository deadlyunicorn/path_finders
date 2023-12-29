import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:path_finders/src/types/coordinates.dart';
import 'package:path_finders/src/types/target_details.dart';

class TargetLocationServices {

  
  static Future<TargetDetails?> getTargetDetails( String targetIdWithDash ) async{
    
    final DateTime? updatedAt;
    final String? errorMessage;
    final String targetId = targetIdWithDash.replaceAll('-', '');
    
    final targetInfoBody = await http.get( Uri.parse("https://path-finders-backend.vercel.app/api/users/$targetId" ))
      .then( ( response ) => jsonDecode( response.body )  );

    if( targetInfoBody["error"] != null ){

        errorMessage = targetInfoBody["error"]["message"];

        return TargetDetails(
          errorMessage: errorMessage,
        );
    }
    else if ( targetInfoBody["data"] != null ){

      updatedAt = DateTime.tryParse( targetInfoBody["data"]["updatedAt"].toString() );


      if ( targetInfoBody["data"]["location"] != null ){

        final double longitude = targetInfoBody["data"]["location"]["coordinates"]["longitude"];
        final double latitude = targetInfoBody["data"]["location"]["coordinates"]["latitude"];
      
        return TargetDetails(
          coordinates: Coordinates(latitude, longitude), 
          updatedAt: updatedAt ?? DateTime.now()
        );
      }
      
    }
    
    

    return null;


  }

  static Stream<int> targetLocationIntervalStream( )async*{

    int fetchCount = 0;  
    
    while ( true ){

      fetchCount ++   ;
      yield fetchCount;
      
      await Future.delayed( 
        const Duration(
           seconds: 30
          //  seconds: 5
        ) 
      );
    }
  }

}