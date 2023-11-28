
import 'dart:convert';
import 'dart:io';


import 'package:http/http.dart' as http;
import 'package:path_finders/src/types/coordinates.dart';
import 'package:path_provider/path_provider.dart';

class LocalFiles { 
  
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get targetsWithIdFile async{
    final path = await _localPath;
    return File( "$path/targetsWithId.json");
  }

  static Future<File> get targetsWithCoordinatesFile async{
    final path = await _localPath;
    return File( "$path/targetsWithCoordinates.json");
  }

  static Future<List<dynamic>> getDecodedJsonFromFile( File file ) async{

    if ( !await file.exists() ){ //file doesn't exist
      await file.writeAsString("");
    }
    final String jsonString = await file.readAsString();

    return jsonString.isEmpty
      ?jsonDecode( "[]" )
      :jsonDecode( jsonString );

  }
  
}

class AppearancesCounterFile {

  static Future<File> get _snackBarCounterFile async{
    final path = await LocalFiles._localPath;
    return File( "$path/snackbarCounter.txt");
  }

  static Future<int> getSnackBarCounter()async{

    final snackBarFile = await _snackBarCounterFile;
    if ( ! await snackBarFile.exists() ){
      await snackBarFile.writeAsString("1");
      return 1;
    }
    else{
      final counter = int.tryParse( await snackBarFile.readAsString() );
      if ( counter != null && counter < 5 ){
        await snackBarFile.writeAsString( "${counter + 1}" );
        return counter;
      }
      return 0;
    }

  }

}

class TargetsFiles {

  static Future<File> writeTargetWithId( String targetId, { String? targetName} ) async{

    final targetsFile = await LocalFiles.targetsWithIdFile;

    final List<dynamic> targetMap = await LocalFiles.getDecodedJsonFromFile( targetsFile ); 

    if ( targetMap.where((element) => element["targetId"] == targetId).isEmpty ){
      targetMap.add({
        "targetId": targetId,
        "targetName": targetName
      });
    }
    return await targetsFile.writeAsString( jsonEncode( targetMap ) );
   
  }

  static Future<void> writeTargetWithCoordinates( String targetName, Coordinates coordinates ) async{
      
    final targetsWithCoordinatesFile = await LocalFiles.targetsWithCoordinatesFile;

    final List<dynamic> targetMap = await LocalFiles.getDecodedJsonFromFile( targetsWithCoordinatesFile );

    if ( targetMap.where((element) => element["targetName"] == targetName).isEmpty ){
      targetMap.add({
        "targetName": targetName,
        "longitude": coordinates.longitude,
        "latitude": coordinates.latitude
      });
    }
    
    await targetsWithCoordinatesFile.writeAsString( jsonEncode( targetMap ) );

  }

  // await targetsFile.writeAsString(""); used to delete for testing
  static Future<List> getTargetsWithIdFromFile() async{

      final targetsFile = await LocalFiles.targetsWithIdFile;
      final List targetsJson = await LocalFiles.getDecodedJsonFromFile( targetsFile );

      return targetsJson;
  }

  static Future<List> getTargetsWithCoordinatesFromFile() async{

      final targetsWithCoordinatesFile = await LocalFiles.targetsWithCoordinatesFile;
      
      return await LocalFiles.getDecodedJsonFromFile( targetsWithCoordinatesFile );

  }

  static Future<void> removeTargetWithIdFromFile( String targetId )async{

      final targetsFile = await LocalFiles.targetsWithIdFile;
      final List targetsJson = await LocalFiles.getDecodedJsonFromFile( targetsFile );

      targetsJson.removeWhere(( jsonObject ) => jsonObject["targetId"] == targetId );
      await targetsFile.writeAsString( jsonEncode( targetsJson ));
  }

    static Future<void> removeTargetWithCoordinatesFromFile( String targetName )async{

      final targetsWithCoordinatesFile = await LocalFiles.targetsWithCoordinatesFile;
      final List targetsJson = await LocalFiles.getDecodedJsonFromFile( targetsWithCoordinatesFile );

      targetsJson.removeWhere(( jsonObject ) => jsonObject["targetName"] == targetName );
      await targetsWithCoordinatesFile.writeAsString( jsonEncode( targetsJson ));
  }

}

class UserFile {
  
  static Future<File> get _userIdFile async{
    final path = await LocalFiles._localPath;
    return File( "$path/userId.txt");
  }

  /// Returns a valid userId else null.
  static Future<String?> getUserId ()async{

    final userIdFile = await _userIdFile;

    try{
      final String content = await userIdFile.readAsString();

      if ( content.isEmpty ){
        await setRandomUserIdFuture();
        return await getUserId();
      }
      else if( content.length != 6 ){
        await userIdFile.writeAsString('');
        await setRandomUserIdFuture();
        return await getUserId();
      }
      else{
        return content;
      }

    }
    catch( error ){
      if ( error is PathNotFoundException ){
        await userIdFile.writeAsString("");
        return await getUserId();
      }
      else {
        return null;
      }
    }
  }

  static Future<void> writeUserId( String userId ) async{

    final userIdFile = await _userIdFile;
    await userIdFile.writeAsString( userId );

  }

  static Future<void> deleteUserIdFuture()async{
    final userIdFile = await _userIdFile;
    await userIdFile.delete();
  }

  static Future<void> setRandomUserIdFuture() async{
    
    final res =  await http.get(
      Uri.parse('https://path-finders-backend.vercel.app/api/users/generateId')
    ); 
    final decodedJson = jsonDecode(res.body);


    if ( decodedJson["data"] != null ){

      final String userId = decodedJson["data"]["userId"].toString();
      await UserFile.writeUserId( userId );
    } 
    else if( decodedJson["error"] != null){
      throw( decodedJson["error"]["message"] );
    }
    else{
      throw( "Network error." );
    }
    
  }
}