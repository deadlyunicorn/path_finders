import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/profile/user_registration_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_finders/src/providers/location_services_provider.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:provider/provider.dart';


class LocationSharingWidget extends StatelessWidget{

  final bool isSharing;
  final String userId;
  final Function() refresh;

  const LocationSharingWidget({ 
    super.key, 
    required this.isSharing,
    required this.userId,
    required this.refresh
  });


  Stream<DateTime?> _locationUpdateStream()async*{
    while ( true ){

      final updatedAt = await _uploadLocationFuture();
      yield updatedAt;
      await Future.delayed( const Duration( seconds: 30 ) );
    }
  }

  @override
  Widget build(BuildContext context) {

    final locationServicesProvider = context.watch<LocationServicesProvider>();
    
    if ( isSharing ){

      return FutureBuilder(

        future: AppVault.userHashExistsFuture( userId ), 
        builder: (context, userHashSnapshot){
          

          if ( userHashSnapshot.connectionState == ConnectionState.done ){ 
            // userHash was checked.

            if ( userHashSnapshot.hasData  ){
              //hasHash exists -- doesn't return null.
              return StreamBuilder(
                stream: _locationUpdateStream(),
                builder: (context, updatedAtStreamSnapshot) {

                  if ( updatedAtStreamSnapshot.hasError ){
                    return ErrorSharingLocationWidget( refresh: refresh);
                  }

                  if ( updatedAtStreamSnapshot.connectionState == ConnectionState.active ){
                    //connection still open

                    final updatedAt = updatedAtStreamSnapshot.data?.toLocal();

                    //this one switches the switch if the user
                    //disables gps after the app thinks he has it enabled.
                    locationServicesProvider.sensors
                      .hasLocationPermission
                      .then(
                        ( hasGPS ) {
                        if ( !hasGPS ){
                          refresh();
                        }
                      }
                    );

                    return Column(
                      children: [
                        const Text(
                          "Sharing Location",
                          textScaler: TextScaler.linear(1.2)
                        ),
                        updatedAt != null
                          ? Text("Updated at ${updatedAt.hour.toString().padLeft(2,'0')} : ${updatedAt.minute.toString().padLeft(2,'0')}")
                          : const Text("Updating...")
                      ]
                    );
                  }
                  else if (  updatedAtStreamSnapshot.connectionState == ConnectionState.active  ){
                    return const Text( 
                      "There was a network error", 
                      textAlign: TextAlign.center
                    );
                  }
                  else{
                    return const CircularProgressIndicator();
                  }
                }
              );

            }
            else{
              return Container(
              margin: const EdgeInsets.only( top: 4 ),
              width: 100,
              child: ErrorSharingLocationWidget( refresh: refresh)
              );
            }
          }
          else{
            //userHash wasn't checked yet.
            return const LinearProgressIndicator( 
              borderRadius: BorderRadius.all( 
                Radius.circular( 4 )
              )
            );
          }
            
        }
      );
    }
    else{ //User is not sharing their location

      return FutureBuilder(
        future: _stopLocationSharingFuture(), 
        builder: (context, snapshot) =>
          ( snapshot.connectionState == ConnectionState.done )
            ?const Text("Location is not being shared.")
            :const Text("Stopping..")
        );
    }
    
  }

  Future<DateTime> _stopLocationSharingFuture() async{

    final userHash = await AppVault.getUserHash();

    final res = await http.put( 
      Uri.parse( "https://path-finders-backend.vercel.app/api/users/update" ),
      body: jsonEncode( {
        "userId" : int.parse(userId),
        "hash": userHash,
        "stopSharing": "true" 
      }) 
    );
    return DateTime.parse( jsonDecode( res.body )["data"]["updatedAt"] );
  }

  Future<DateTime?> _uploadLocationFuture() async{

    try{

      final currentPosition = await Geolocator.getCurrentPosition();

      final userHash = await AppVault.getUserHash();

      final longitude = currentPosition.longitude;
      final latitude = currentPosition.latitude;

      final res = await http.put( 
        Uri.parse( "https://path-finders-backend.vercel.app/api/users/update" ),
        body: jsonEncode( {
          "userId" : int.parse(userId),
          "hash": userHash,
          "location": {
            "longitude": longitude,
            "latitude": latitude
          }
        }) 
      );
      // await Future.delayed( Duration(seconds: 2)); //await to be updated
      final decodedJson = jsonDecode( res.body );

      if ( decodedJson["error"] != null ){
        return Future.error( decodedJson["error"]["message"] );
      }
      return DateTime.parse( decodedJson["data"]["updatedAt"] );

    }
    catch(_){
      return null;
    }
    
  }
}

class ErrorSharingLocationWidget extends StatelessWidget{ 

  final Function refresh;
  const ErrorSharingLocationWidget( {super.key, required this.refresh});

  @override
  Widget build(BuildContext context) {
    
    return IconButton( 
        icon: const Icon(Icons.refresh), 
        tooltip: "Regenerate ID",
        onPressed: ()async{
          await AppVault.deleteUserHashFuture();
          await UserFile.deleteUserIdFuture();
          refresh();
        }
      );
  }
}