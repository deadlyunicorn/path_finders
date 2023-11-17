
import 'dart:convert';
import 'dart:io';

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

  static Future<File> writeTarget( String targetId ) async{
    
    final targetsFile = await LocalFiles.targetsFile;
    final String jsonListString = await targetsFile.readAsString();

    final List<dynamic> targetMap = jsonListString.isEmpty
    ?jsonDecode( "[]" )
    :jsonDecode( jsonListString );

    targetMap.add({
      "targetId": targetId
    });

    return await targetsFile.writeAsString( jsonEncode( targetMap ) );
  }

      // await targetsFile.writeAsString(""); used to delete for testing
  static Future<Set<String>> getTargetsFromFile() async{

      final targetsFile = await LocalFiles.targetsFile;
      final contents = await targetsFile.readAsString();
      final dynamic targetsJson = json.decode(contents);

      final Set<String> finalSet = {};

      for( var target in targetsJson ){
        String? targetId = target["targetId"];
        if ( targetId !=null && targetId.isNotEmpty ){
          finalSet.add( targetId.toString() );
        }
      }

      return finalSet;

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
        return null;
      }
      else if( content.length != 6 ){
        await userIdFile.writeAsString('');
        return null;
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
}