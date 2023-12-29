import 'package:flutter/material.dart';
import 'package:path_finders/src/friends/friends_view_components/static_entries_list.dart';

import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/providers/targets_with_coordinates_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticEntriesView extends StatelessWidget{

  const StaticEntriesView({ 
    super.key
  });

  @override
  Widget build(BuildContext context) {

    
    final staticListingsProvider = context.watch<TargetWithCoordinatesListingsProvider>(); 


    return FutureBuilder(
        future: staticListingsProvider.initializeListingsFuture(), 
        builder: ( context, targetsSnapshot ) {
            


            if ( targetsSnapshot.connectionState == ConnectionState.done ){

            final listings = staticListingsProvider.targetEntries;

            final targetProvider = context.watch<TargetProvider>();
            setTargetToLastSelectedStaticEntry(targetProvider, listings);

            return StaticEntriesList(
              listings: listings, 
              targetProvider: targetProvider, 
              staticListingsProvider: staticListingsProvider
            );
            
          }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          
        }
    );
  }

  void setTargetToLastSelectedStaticEntry(TargetProvider targetProvider, List<dynamic> listings) {
    if ( targetProvider.targetName == "North Pole" ){ //North Pole is the default at launch
    
      WidgetsBinding.instance.addPostFrameCallback(
        (_)async { 
          //We will set the selected entry at launch to be the last selected static entry
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final lastStaticTarget = prefs.getString( 'staticTarget');
          if ( lastStaticTarget != null && lastStaticTarget.isNotEmpty && lastStaticTarget != "North Pole" ){
    
            for (final element in listings) {
                  if ( element["targetName"] == lastStaticTarget ){
    
                    final coordinates = Coordinates( element["latitude"], element["longitude"] );
                    targetProvider.setTarget(targetName: lastStaticTarget, targetLocation: coordinates);
                    
                  } 
                }
              
          }
          
        }
      );
    
    }
  }
}
