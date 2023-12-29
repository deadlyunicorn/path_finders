import 'package:flutter/material.dart';
import 'package:path_finders/src/friends/friends_view_components/entry_insertion_views/static_entry_dialog_view.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/providers/targets_with_coordinates_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticEntriesList extends StatelessWidget {
  const StaticEntriesList({
    super.key,
    required this.listings,
    required this.targetProvider,
    required this.staticListingsProvider,
  });

  final List listings;
  final TargetProvider targetProvider;
  final TargetWithCoordinatesListingsProvider staticListingsProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    
        itemCount:  listings.length,//listItems.length,
        itemBuilder: (context, index) {
          
          final currentElement = listings[index];
          final String targetName = currentElement["targetName"];//listItems.keys.elementAt(index);
          final Coordinates targetCoordinates = Coordinates( currentElement["latitude"], currentElement["longitude"]); //listItems[targetName];
    
          return  Container ( 
    
              margin: const EdgeInsets.all( 8 ),
              decoration: targetProvider.targetName == targetName 
              ? BoxDecoration(
                border: Border.all(
                  color: Theme.of( context ).highlightColor
                ),
                borderRadius: BorderRadius.circular( 4 ),
              )
              :null,
              child: ListTile(
                title: Text( targetName ),
                onTap: () async{
                  
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setString( 'staticTarget', targetName );
    
                  targetProvider.setTarget(targetName: targetName, targetLocation: targetCoordinates);
    
    
                },
                onLongPress: (){
                  showDialog(
                    context: context, 
                    builder: (context) => 
                      StaticEntryDialog( 
                        staticListingsProvider: staticListingsProvider,
                        coordinates: targetCoordinates,
                        targetName: targetName,
                      )
                  );
                  // listingsProvider.removeTargetWithCoordinatesEntry(targetName);
                }
                ,
            )
          );
    
        },
    );
  }
}