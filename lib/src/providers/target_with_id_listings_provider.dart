import 'package:path_finders/src/providers/target_listings_abstract.dart';
import 'package:path_finders/src/storage_services.dart';

class TargetWithIdListingsProvider extends TargetListingsProviderAbstract{

  void notifyConsumers(){
    notifyListeners();
  }

  Future<void> add( String targetId, { String? targetName } ) async{

    await TargetsFiles.writeTargetWithId(targetId, targetName: targetName);
    super.targetEntries.add( { "targetId": targetId, "targetName": targetName } );
    notifyListeners();
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> remove( String targetId ) async{

    await TargetsFiles.removeTargetWithIdFromFile( targetId );
    super.targetEntries.removeWhere((element) => element["targetId"] == targetId );
    notifyListeners();
  }

 
}