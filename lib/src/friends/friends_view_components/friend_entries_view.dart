import 'package:flutter/material.dart';
import 'package:path_finders/src/providers/target_listings_provider.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:provider/provider.dart';

class FriendEntriesView extends StatelessWidget{

  const FriendEntriesView({ 
    Key? key, 
  }):super(key:key);

  

  @override
  Widget build(BuildContext context) {
    final Future<String> _mockDelay = Future<String>.delayed(
    const Duration( seconds: 1),
    () => "Loaded",
  );

    return Expanded(
      flex: 3,
      child:
        Consumer<TargetListingsProvider>( 
          builder: (context, listingsProvider, child) 
          =>  ListView.builder(
            itemCount:  listingsProvider.targetEntries.length,
            itemBuilder: (context, index) {
              final entry = listingsProvider.targetEntries.elementAt(index);
              return Consumer<TargetProvider>( builder: (context, targetProvider, child) 
                => FutureBuilder(
                  future: _mockDelay,
                  builder: (context, snapshot) { 
                    
                    Widget trailingIcon;
                    switch ( snapshot.connectionState ){

                      case ConnectionState.waiting:
                        trailingIcon = CircularProgressIndicator ( strokeWidth: 0.1,);
                        break;

                      case ConnectionState.done:
                        if ( snapshot.hasData ){
                          trailingIcon = Icon( Icons.done, color: Colors.green, );
                        }
                        else{
                          trailingIcon = Icon ( Icons.close, color: Colors.red );
                        }
                        break;

                      default:
                        trailingIcon = Icon( Icons.warning, color: Colors.yellow );
                        break;

                    }

                    return ListTile(
                      title: Text( entry ), 
                      trailing: trailingIcon ,
                      onTap: () {
                        if ( snapshot.hasData ){
                          listingsProvider.removeTargetEntry("rofl");
                          targetProvider.setTargetName( listingsProvider.targetEntries.elementAt(index));
                        }
                        print( entry );
                      }
                    );
                  }
                )
              );
            },
          )
        ),
    );
  }
}