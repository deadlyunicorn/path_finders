import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_finders/src/logger_instance.dart';
import 'package:path_finders/src/profile/user_registration_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_finders/src/storage_services.dart';


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

  Stream<Future<DateTime>> _locationUpdateStream()async*{
    while ( true ){
      yield _uploadLocationFuture();
      await Future.delayed( const Duration( minutes: 2 ) );
    }
  }

  Future<DateTime> _uploadLocationFuture() async{

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

          LoggerInstance.log.i("userHash was checked");
          if ( snapshot.hasData ){ // userHash exists //else throws error
            return Column(
              children: [
                const Text(
                  "Sharing Location",
                  textScaler: TextScaler.linear(1.2)
                ),
                StreamBuilder(
                  stream: _locationUpdateStream(),
                  builder: (context, snapshot) {

                    if ( snapshot.connectionState != ConnectionState.done ){
                      return FutureBuilder(
                        future: snapshot.data, 
                        builder: (context, snapshot) {

                          if ( snapshot.hasError ){
                            return ErrorSharingLocationWidget( refresh: refresh);
                          }
                          else{
                            final updatedAt = snapshot.data?.toLocal();

                            return snapshot.connectionState == ConnectionState.waiting
                              ?const Text("Updating...")
                              : updatedAt != null
                                ? Text("Updated at ${updatedAt.hour.toString().padLeft(2,'0')} : ${updatedAt.minute.toString().padLeft(2,'0')}")
                                : const Text("There was a network error.");
                          }
                        }
                          
                      );
                    }
                    else{
                      return const Text("No longer sharing..");//const SizedBox.shrink();//
                    }
                  }
                )
              ]
            );
          }
          else{
          
              return Container(
                margin: const EdgeInsets.only( top: 4 ),
                width: 100,
                child: snapshot.error != null 
                ?ErrorSharingLocationWidget( refresh: refresh)
                :const LinearProgressIndicator( borderRadius: BorderRadius.all( Radius.circular( 4 )),)
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