import 'package:flutter/material.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:provider/provider.dart';

class FriendsEntriesView extends StatelessWidget{

  final Map<String, Coordinates> listItems;

  const FriendsEntriesView({ 
    Key? key, 
    required this.listItems,
  }):super(key:key);

  @override
  Widget build(BuildContext context) {


    return Expanded(
      flex: 3,
      child:
      ListView.builder(
        itemCount:  listItems.length,
        itemBuilder: (context, index) {
          final key = listItems.keys.elementAt(index);
          final value = listItems[key];
          return Consumer<TargetProvider>(
            builder: (context, targetProvider, child) 
              => ListTile(
                  title: Text( key ), 
                  onTap: () {
                    targetProvider.setTargetLocation( value! );
                    targetProvider.setTargetName( key );
                  }
              )
          );
        },
      )
    );
  }
}