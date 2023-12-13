import 'package:flutter/material.dart';
import 'package:path_finders/src/friends/entry_insertion_views/static_entry_dialog_view.dart';

import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/providers/targets_with_coordinates_provider.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticEntriesView extends StatelessWidget{

  const StaticEntriesView({ 
    super.key
  });

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> sampleData = [
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
    final listingsProvider = context.watch<TargetWithCoordinatesListingsProvider>(); 
    final targetProvider = context.watch<TargetProvider>();


    return Expanded(
      flex: 3,
      child: FutureBuilder(
        future: TargetsFiles.getTargetsWithCoordinatesFromFile(), 
        builder: ( context, targetsSnapshot ) {


          if ( targetsSnapshot.connectionState == ConnectionState.done ){
            
            final targetData = targetsSnapshot.data;

            if ( targetData != null ){
              //has no notifyListeners(), it is used to disappear entries on removal.
              listingsProvider.initialize( targetData );

              //If the user has added an entry named "China" it will remove it.
              sampleData.removeWhere((element) => targetData.map((e) => e ["targetName"]).contains(element["targetName"]));
              sampleData.addAll(  [ ...targetData ] ); 
            }

            if ( targetProvider.targetName == "North Pole" ){ //North Pole is the default at launch

              WidgetsBinding.instance.addPostFrameCallback(
                (_)async { 
                  //We will set the selected entry at launch to be the last selected static entry
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  final lastStaticTarget = prefs.getString( 'staticTarget');
                  if ( lastStaticTarget != null && lastStaticTarget.isNotEmpty && lastStaticTarget != "North Pole" ){

                    sampleData
                      .forEach(
                        (element) {
                          if ( element["targetName"] == lastStaticTarget ){
                            final coordinates = Coordinates( element["latitude"], element["longitude"] );
                            targetProvider.setTargetName(lastStaticTarget);
                            targetProvider.setTargetLocation( coordinates );
                          } 
                        }
                      );
                      
                  }
                  
                }
              );

            }

            return ListView.builder(

                itemCount:  sampleData.length,//listItems.length,
                itemBuilder: (context, index) {
                  
                  final currentElement = sampleData[index];
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

                          targetProvider.setTargetLocation( targetCoordinates );
                          targetProvider.setTargetName( targetName );


                        },
                        onLongPress: (){
                          showDialog(
                            context: context, 
                            builder: (context) => 
                              StaticEntryDialog( 
                                staticListingsProvider: listingsProvider,
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
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          
        }
      )
    );
  }
}