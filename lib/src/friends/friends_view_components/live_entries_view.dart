import 'package:flutter/material.dart';
import 'package:path_finders/src/providers/target_with_id_listings_provider.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:path_finders/src/target_location_fetch.dart';
import 'package:provider/provider.dart';

class LiveEntriesView extends StatelessWidget{

  const LiveEntriesView({ 
    Key? key, 
  }):super(key:key);

  

  @override
  Widget build(BuildContext context) {


    return Expanded(
      flex: 3,
      child:
        FutureBuilder(
          future: TargetsFiles.getTargetsWithIdFromFile(), 
          builder: (context, snapshot) {

          final targetsMapListSnapshot = snapshot.data;
          
          ////using .read() instead of .watch()
          ////to not rebuild/refetch when changing targets.
          final targetProvider = context.watch<TargetProvider>();
          final targetsWithIdListingsProvider = context.watch<TargetWithIdListingsProvider>();
          

          if ( targetsMapListSnapshot != null ){

            

            //This code seems to work.
            //
            //One of the main benefits of writing it this way
            //is that on entry addition/removal
            //we don't need to return a loading screen.
            //We still keep our old entry list loaded.
            targetsWithIdListingsProvider.initializeTargetWithIdEntries( targetsMapListSnapshot );
            

            return StreamBuilder(
              stream: TargetLocationServices.targetLocationIntervalStream(), 
              builder: ( context, intervalStreamerSnapshot ){

                if ( intervalStreamerSnapshot.connectionState == ConnectionState.active ){

                  return ListView.builder(

                    itemCount:  targetsWithIdListingsProvider.targetEntries.length,
                    itemBuilder: (context, index) {

                      
                      final targetEntry = targetsWithIdListingsProvider.targetEntries.elementAt(index);
                      
                      final String targetId = targetEntry["targetId"];
                      final String? targetName = targetEntry["targetName"];

                      return FutureBuilder(
                        future: TargetLocationServices.getTargetDetails( targetId ), 
                        builder: ( context, snapshot ) {

                          final targetDetailsSnapshot = snapshot.data; 
                          Widget leadingIcon;

                          switch ( snapshot.connectionState ){

                            case ConnectionState.waiting:
                              leadingIcon = const CircularProgressIndicator ( strokeWidth: 0.1,);
                              break;

                            case ConnectionState.done:
                              if ( snapshot.hasData && targetDetailsSnapshot != null ){

                                if ( targetDetailsSnapshot.hasErrorMessage() ){
                                  leadingIcon = const Icon( Icons.warning, color: Colors.yellow );
                                }
                                else{
                                  leadingIcon = const Icon( Icons.done, color: Colors.green, );
                                }
                                break;

                              }
                              else{
                                leadingIcon = const Icon ( Icons.error, color: Colors.red );
                                break;
                              }

                            default:
                              leadingIcon = const Icon ( Icons.error, color: Colors.red );
                              break;

                          }


                          // Updating the target provider's location whenever there is new data.
                          if ( intervalStreamerSnapshot.connectionState == ConnectionState.active ){

                            

                            if ( 
                              targetId == targetProvider.targetName
                              && targetDetailsSnapshot != null
                              && !targetDetailsSnapshot.hasErrorMessage()
                            ){
                              
                              final targetLocationFromServer = targetDetailsSnapshot.getCoordinates();
                              final targetLocationFromProvider = targetProvider.targetLocation;
      

                              if ( targetLocationFromServer != null 
                                && targetLocationFromProvider != null
                                && targetLocationFromServer.latitude != targetLocationFromProvider.latitude 
                                && targetLocationFromServer.longitude != targetLocationFromProvider.longitude 
                              ){

                                WidgetsBinding.instance.addPostFrameCallback((duration) async { 
                                  //the above ensures that it will run after 
                                  //everything has been built
                                  // *prevents exception*

                                  //it will basically run BEFORE the interval stream
                                  //to update the selected target inside the provider.

                                  //we still need the stream to refetch the status 
                                  //of the other targets.
                                  targetProvider.setTargetLocation( targetLocationFromServer );
                                });

                              }
                              
                            }

                          }


                          return Container ( 
                            margin: const EdgeInsets.all( 8 ),
                            decoration: targetProvider.targetName == targetId 
                            ? BoxDecoration(
                              border: Border.all(
                                color: Theme.of( context ).highlightColor
                              ),
                              borderRadius: BorderRadius.circular( 4 ),
                            )
                            :null,
                              child:ListTile(
                              title: Flex( 
                                direction: Axis.horizontal,
                                
                                children: [
                                  Text( targetName ?? "#$targetId" ),
                                  const SizedBox( width: 5 ),
                                  targetName != null 
                                  ? Text( "#$targetId", textScaler: const TextScaler.linear(0.6) ) 
                                  : const SizedBox.shrink()
                                ]
                              ),
                              leading: SizedBox( width: 32, height: 32, child: leadingIcon) ,
                              trailing:  ( targetDetailsSnapshot != null && targetDetailsSnapshot.hasErrorMessage() )
                                ? Text( targetDetailsSnapshot.getErrorMessage()! )
                                : ( targetDetailsSnapshot == null && snapshot.connectionState == ConnectionState.done )
                                  ? const Text("Network error") 
                                  : const SizedBox.shrink(),
                              onTap: () {
                                if ( targetDetailsSnapshot != null 
                                  && !targetDetailsSnapshot.hasErrorMessage() 
                                ){

                                  targetProvider.setTargetName( targetId ) ;
                                  targetProvider.setTargetLocation( targetDetailsSnapshot.getCoordinates()! ) ;

                                }
                              },
                              onLongPress: () {
                                targetsWithIdListingsProvider.removeTargetWithIdEntry( targetId );

                              },
                            )
                          );
                        }
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
            ); 

          }
          else if ( snapshot.connectionState == ConnectionState.done ){
            return const Center( child: Text( "No friend entries." ) ); 
          }
          else { 
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}