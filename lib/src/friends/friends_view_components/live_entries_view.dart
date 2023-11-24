import 'package:flutter/material.dart';
import 'package:path_finders/src/providers/target_listings_provider.dart';
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
        Consumer<TargetListingsProvider>( 
          builder: (context, listingsProvider, child) 
          =>  FutureBuilder(
            future: TargetsFile.getTargetsFromFile(), 
            builder: (context, snapshot) {

              final targetsSetSnapshot = snapshot.data;
              


              if ( targetsSetSnapshot != null ){

                //This code seems to work.
                //
                //One of the main benefits of writing it this way
                //is that on entry addition/removal
                //we don't need to return a loading screen.
                //We still keep our old entry list loaded.
                listingsProvider.initializeTargetEntries( targetsSetSnapshot );
                

                return StreamBuilder(
                  stream: TargetLocationServices.targetLocationIntervalStream(), 
                  builder: ( context, intervalStreamerSnapshot ){

                    if ( intervalStreamerSnapshot.connectionState == ConnectionState.active ){
                      return ListView.builder(
                        itemCount:  listingsProvider.targetEntries.length,
                        itemBuilder: (context, index) {

                          //using .read() instead of .watch()
                          //to not rebuild/refetch when changing targets.
                          final targetProvider = context.read<TargetProvider>();
                          
                          final targetId = listingsProvider.targetEntries.elementAt(index);
                          




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
                                  var coordinates = targetDetailsSnapshot.getCoordinates();
                                  if ( coordinates != targetProvider.targetLocation ){

                                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
                                      //the above ensures that it will run after 
                                      //everything has been built
                                      // *prevents exception*
                                      targetProvider.setTargetLocation( targetDetailsSnapshot.getCoordinates()! );
                                    });

                                  }
                                 
                                }

                              }


                              return ListTile(
                                title: Text( targetId ), 
                                leading: SizedBox( width: 32, height: 32, child: leadingIcon) ,
                                trailing:  ( targetDetailsSnapshot != null && targetDetailsSnapshot.hasErrorMessage() )
                                  ? Text( targetDetailsSnapshot.getErrorMessage()! )
                                  : ( targetDetailsSnapshot == null && snapshot.connectionState == ConnectionState.done )
                                    ? const Text("Network error") 
                                    : const SizedBox.shrink(),
                                onTap: () {
                                  if ( targetDetailsSnapshot != null && !targetDetailsSnapshot.hasErrorMessage() ){

                                    targetProvider.setTargetName( targetId ) ;
                                    targetProvider.setTargetLocation( targetDetailsSnapshot.getCoordinates()! ) ;

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
        ),
    );
  }
}