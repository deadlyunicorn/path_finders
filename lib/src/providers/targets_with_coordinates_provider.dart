import 'package:path_finders/src/providers/target_listings_abstract.dart';
import 'package:path_finders/src/custom/storage_services.dart';
import 'package:path_finders/src/types/coordinates.dart';

class TargetWithCoordinatesListingsProvider extends TargetListingsProviderAbstract{

  static const List<Map<String, dynamic>> _sampleData = [ //oh no..
      { 
        "targetName" : "China",
        "latitude"   : 31.2183202,
        "longitude"  : 120.2284013
      },
      {
        "targetName" :"Mexico",
        "latitude"   :19.3904678,
        "longitude"  :-99.455446,
      },
      {
        "targetName" :"Finland",
        "latitude"   :65.0679042,
        "longitude"  :25.58678
      },
      {
        "targetName" :"South Africa",
        "latitude"   :-33.925108,
        "longitude"  :18.5315826 
      }
    ];


  Future<void> add( String targetName, Coordinates coordinates ) async{
    await TargetsFiles.writeTargetWithCoordinates( targetName, coordinates );
    notifyListeners();
  }

  @override
  Future<void> remove( String targetName ) async{

    if (super.targetEntries.where((element) => element["targetName"] == targetName ).isNotEmpty ){
      await TargetsFiles.removeTargetWithCoordinatesFromFile( targetName );
      // _targetWithCoordinatesEntries.removeWhere((element) => element["targetName"] == targetName );
      notifyListeners();

    }

  }

  Future<void> initializeListingsFuture()async{
    
    final targetData = await TargetsFiles.getTargetsWithCoordinatesFromFile();
    var tempData = [..._sampleData];
    tempData.removeWhere((element) => targetData.map((e) => e ["targetName"]).contains(element["targetName"]));
    tempData.addAll(  [ ...targetData ] ); 
    super.initialize( tempData );

  }

 
}