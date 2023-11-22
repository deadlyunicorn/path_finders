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

    final Future<String> mockDelay = Future<String>.delayed(
    const Duration( seconds: 1),
    () => "Loaded",
  );

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

              }

              return StreamBuilder(
                stream: TargetLocationServices.targetLocationIntervalStream(), 
                builder: ( context, index){

                  print( " hello ??" );

                  return ListView.builder(
                    itemCount:  listingsProvider.targetEntries.length,
                    itemBuilder: (context, index) {

                      final targetId = listingsProvider.targetEntries.elementAt(index);

                      return Consumer<TargetProvider>( builder: (context, targetProvider, child) 
                        =>  FutureBuilder(
                          future: TargetLocationServices.getTargetDetails( targetId ), 
                          builder: ( context, snapshot ) {

                            print( snapshot );
                            if ( snapshot.hasData && snapshot.data != null ){
                              print ( snapshot.data );
                              print( "snapshot is above");
                            }


                            Widget trailingIcon;
                            switch ( snapshot.connectionState ){

                              case ConnectionState.waiting:
                                trailingIcon = const CircularProgressIndicator ( strokeWidth: 0.1,);
                                break;

                              case ConnectionState.done:
                                if ( snapshot.hasData ){
                                  trailingIcon = const Icon( Icons.done, color: Colors.green, );
                                }
                                else{
                                  trailingIcon = const Icon ( Icons.close, color: Colors.red );
                                }
                                break;

                              default:
                                trailingIcon = const Icon( Icons.warning, color: Colors.yellow );
                                break;

                            }


                            return ListTile(
                              title: Text( targetId ), 
                              trailing: trailingIcon ,
                              onTap: () {
                                if ( snapshot.hasData ){
                                  targetProvider.setTargetName( listingsProvider.targetEntries.elementAt(index));
                                }
                              },
                              onLongPress: () {
                                listingsProvider.removeTargetEntry( targetId );

                              },
                            );

                          }
                        )
                      );
                    },
                  );
                  
                } 
              ); 
            },
          )
        ),
    );
  }
}