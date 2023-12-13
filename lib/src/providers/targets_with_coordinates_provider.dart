import 'package:path_finders/src/providers/target_listings_abstract.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:path_finders/src/types/coordinates.dart';

class TargetWithCoordinatesListingsProvider extends TargetListingsProviderAbstract{


  Future<void> add( String targetName, Coordinates coordinates ) async{
    await TargetsFiles.writeTargetWithCoordinates( targetName, coordinates );
    notifyListeners();
  }

  Future<void> remove( String targetName ) async{

    if (super.targetEntries.where((element) => element["targetName"] == targetName ).isNotEmpty ){
      await TargetsFiles.removeTargetWithCoordinatesFromFile( targetName );
      // _targetWithCoordinatesEntries.removeWhere((element) => element["targetName"] == targetName );
      notifyListeners();

    }

  }

 
}