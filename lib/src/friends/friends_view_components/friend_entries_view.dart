import 'package:flutter/material.dart';
import 'package:path_finders/src/providers/target_listings_provider.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:path_finders/src/target_location_fetch.dart';
import 'package:provider/provider.dart';

class FriendEntriesView extends StatelessWidget{

  const FriendEntriesView({ 
    Key? key, 
  }):super(key:key);

  

  @override
  Widget build(BuildContext context) {


    return Expanded(
      flex: 3,
      child:
        Consumer<TargetListingsProvider>( 
          builder: (context, listingsProvider, child) 
          =>  FutureBuilder(
            future: TargetsFile.getTargetsFromFile(), 
            builder: (context, snapshot) {

              final snapshotData = snapshot.data;
              


              if ( snapshot.connectionState == ConnectionState.done 
                  && snapshotData != null 
              ){

                //This code seems to work.
                //
                //One of the main benefits of writing it this way
                //is that on entry addition/removal
                //we don't need to return a loading screen.
                //We still keep our old entry list loaded.
                listingsProvider.initializeTargetEntries( snapshotData );
                

                return StreamBuilder(
                  stream: TargetLocationServices.targetLocationIntervalStream(), 
                  builder: ( context, streamerSnapshot ){

                    if ( streamerSnapshot.connectionState == ConnectionState.active ){
                      return ListView.builder(
                        itemCount:  listingsProvider.targetEntries.length,
                        itemBuilder: (context, index) {

                          //using .read() instead of .watch()
                          //to not rebuild/refetch when changing targets.
                          final targetProvider = context.read<TargetProvider>();
                          
                          final targetId = listingsProvider.targetEntries.elementAt(index);
                          
                          if ( 
                            targetId == targetProvider.targetName
                          ){
                            print( "ok");
                            // targetProvider.setTargetLocation( snapshotData.getCoordinates()! );
                          }




                          return FutureBuilder(
                            future: TargetLocationServices.getTargetDetails( targetId ), 
                            builder: ( context, snapshot ) {

                              final snapshotData = snapshot.data; 
                              Widget leadingIcon;

                              switch ( snapshot.connectionState ){

                                case ConnectionState.waiting:
                                  leadingIcon = const CircularProgressIndicator ( strokeWidth: 0.1,);
                                  break;

                                case ConnectionState.done:
                                  if ( snapshot.hasData && snapshotData != null ){

                                    if ( snapshotData.hasErrorMessage() ){
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

                              return ListTile(
                                title: Text( targetId ), 
                                leading: SizedBox( width: 32, height: 32, child: leadingIcon) ,
                                trailing:  ( snapshotData != null && snapshotData.hasErrorMessage() )
                                  ? Text( snapshotData.getErrorMessage()! )
                                  : ( snapshotData == null && snapshot.connectionState == ConnectionState.done )
                                    ? const Text("Network error") 
                                    : const SizedBox.shrink(),
                                onTap: () {
                                  if ( snapshotData != null && !snapshotData.hasErrorMessage() ){

                                    targetProvider.setTargetName( targetId ) ;
                                    targetProvider.setTargetLocation( snapshotData.getCoordinates()! ) ;

                                  }
                                },
                                onLongPress: () {
                                  listingsProvider.removeTargetEntry( targetId );

                                },
                              );

                            }
                          );
                        },
                      );
                    }
                    else{
                      return const CircularProgressIndicator();
                    }
                  } 
                ); 

              }

              else { 
                return const CircularProgressIndicator();
              }
            },
          )
        ),
    );
  }
}