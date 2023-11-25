
import 'dart:convert';
import 'dart:io';


import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class LocalFiles { 
  
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get targetsFile async{
    final path = await _localPath;
    return File( "$path/targets.json");
  }
  
}

class TargetsFile {

  static Future<File> writeTarget( String targetId, { String? targetName} ) async{

    final targetsFile = await LocalFiles.targetsFile;
    try{
      final String jsonListString = await targetsFile.readAsString();

      final List<dynamic> targetMap = jsonListString.isEmpty
      ?jsonDecode( "[]" )
      :jsonDecode( jsonListString );


      if ( targetMap.where((element) => element["targetId"] == targetId).isEmpty ){
        targetMap.add({
          "targetId": targetId,
          "targetName": targetName
        });
      }
      
      return await targetsFile.writeAsString( jsonEncode( targetMap ) );

    }
    catch( error ){
      if ( error is PathNotFoundException ){
        await targetsFile.writeAsString("");
        return await writeTarget(targetId, targetName: targetName );
      }
      else{ 
        throw "Uknown error.";
      }
    }
    
  }

      // await targetsFile.writeAsString(""); used to delete for testing
  static Future<List> getTargetsFromFile() async{

      final targetsFile = await LocalFiles.targetsFile;
      final contents = await targetsFile.readAsString();
      final List targetsJson = json.decode(contents);



      // final Set<String> finalSet = {};

      // for( var target in targetsJson ){
      //   String? targetId = target["targetId"];
      //   if ( targetId !=null && targetId.isNotEmpty ){
      //     finalSet.add( targetId.toString() );
      //   }
      // }

      return targetsJson;

  }

  static Future<void> removeTargetFromFile( String targetId )async{

      final targetsFile = await LocalFiles.targetsFile;
      final contents = await targetsFile.readAsString();
      final List targetsJson = json.decode( contents );

      targetsJson.removeWhere(( jsonObject ) => jsonObject["targetId"] == targetId );
      await targetsFile.writeAsString( jsonEncode( targetsJson ));
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