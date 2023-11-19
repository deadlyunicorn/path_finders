import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_finders/src/logger_instance.dart';
import 'package:http/http.dart' as http;


class AppVault {

  static const _storage =  FlutterSecureStorage();

  static Future<String?> getUserHash() async {
    return await _storage.read( key: 'userHash' );
  } 

  static Future<bool> userHashExistsFuture( String userId ) async{

    String? userHash = await _storage.read( key: 'userHash' );

    if ( userHash == null || userHash.isEmpty ){
      LoggerInstance.log.i("There is no user hash in secure store.");

      final userHashResponse = await http.post( 
        Uri.parse( "https://path-finders-backend.vercel.app/api/users/register"),
        headers: {
          "Content-type" : "application/json"
        },
        body: jsonEncode({
          "userId": userId
        })
      );

      final decodedJson = jsonDecode( userHashResponse.body );
      
      if ( decodedJson["data"] != null ){

        final String hash = decodedJson["data"]["hash"];
        await _storage.write(key: "userHash", value: hash );
        LoggerInstance.log.i("Saved new userHash");
        return await userHashExistsFuture( userId );

      }
      else if( decodedJson["error"] != null){
        throw decodedJson["error"]["message"];
      }
      else{
        throw "Network Error.";
      }
    }

    // if userhash exists {
    // Map<String,String> value = await _storage.readAll();
    // value["userHash"]; userHash
    return  _storage.containsKey(key: "userHash");
  }

  static Future<void> deleteUserHashFuture() async{
    await _storage.delete(key: "userHash");
  }

}

