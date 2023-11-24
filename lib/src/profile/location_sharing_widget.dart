import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/logger_instance.dart';
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
      await Future.delayed( const Duration( minutes: 2 ) );
    }
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
      return DateTime.parse( jsonDecode( res.body )["data"]["updatedAt"] );

    }
    catch(_){
      return null;
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
    // await Future.delayed( Duration(seconds: 2)); //await to be updated
    return DateTime.parse( jsonDecode( res.body )["data"]["updatedAt"] );
  }

  @override
  Widget build(BuildContext context) {
    
    if ( isSharing ){
      return FutureBuilder(

        future: AppVault.userHashExistsFuture( userId ), 
        builder: (context, snapshot){
          

          if ( snapshot.hasData && snapshot.connectionState == ConnectionState.done ){ // userHash exists //else throws error
          LoggerInstance.log.i("userHash was checked");

            return 
              StreamBuilder(
                stream: _locationUpdateStream(),
                builder: (context, updatedAtSnapshot) {

                  

                  if ( updatedAtSnapshot.connectionState != ConnectionState.done ){
                    //connection still open

                        if ( updatedAtSnapshot.hasError ){
                          return ErrorSharingLocationWidget( refresh: refresh);
                        }
                        else{
                          final updatedAt = updatedAtSnapshot.data?.toLocal();

                          //this one switches the switch if the user
                          //disables gps after the app thinks he has it enabled.
                          context.watch<LocationServicesProvider>().sensors
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
                                : updatedAtSnapshot.connectionState == ConnectionState.done
                                  ? const Text("There was a network error.")
                                  : const Text("Updating...")
                            ]
                          );
                        }
                  }
                  else{
                    return const Text("No longer sharing..");//const SizedBox.shrink();//
                  }
                }
              );
          }
          else{
          
            return Container(
              margin: const EdgeInsets.only( top: 4 ),
              width: 100,
              child: snapshot.connectionState == ConnectionState.done 
              ?ErrorSharingLocationWidget( refresh: refresh)
              :const SizedBox.shrink() //const LinearProgressIndicator( borderRadius: BorderRadius.all( Radius.circular( 4 )),)
            );
          }
            
        }
      );
    }
    else{

      return FutureBuilder(
        future: _stopLocationSharingFuture(), 
        builder: (context, snapshot) =>
          ( snapshot.connectionState == ConnectionState.done )
            ?const Text("Location is not being shared.")
            :const Text("Stopping..")
        );
    }
    
  }
}

class ErrorSharingLocationWidget extends StatelessWidget{ 

  final Function refresh;
  const ErrorSharingLocationWidget( {super.key, required this.refresh});

  @override
  Widget build(BuildContext context) {
    
    return Column ( 
        children: [
          const Text( "There was an error." ),
          IconButton( 
            icon: const Icon(Icons.refresh), 
            tooltip: "Regenerate ID",
            onPressed: ()async{
              await AppVault.deleteUserHashFuture();
              await UserFile.deleteUserIdFuture();
              refresh();
            }
          ),
        ]
      );
  }
}