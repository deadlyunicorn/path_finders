import 'package:flutter/material.dart';
import 'package:path_finders/src/friends/entry_insertion_buttons.dart';
import 'package:path_finders/src/friends/friends_view_components/live_entries_view.dart';
import 'package:path_finders/src/friends/friends_view_components/static_entries_view.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:provider/provider.dart';


class FriendsView extends StatefulWidget {

  const FriendsView( {super.key });

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {

  final Map<String, Coordinates> sampleData = {
    "China"  :  Coordinates( 31.2183202, 120.2284013),
    "Mexico" :  Coordinates( 19.3904678, -99.455446 ),
    "Finland":  Coordinates( 65.0679042, 25.58678   ),
    "South Africa" : Coordinates( -33.925108, 18.5315826 )
  };

  String friendToAdd = "";

  @override
  Widget build(BuildContext context) {

    return (
      Column(
        children: [
          Text("Currently ${context.watch<TargetProvider>().targetName} is selected."),
          const ListHeader(text: "Static Entries"),
          StaticEntriesView( listItems: sampleData ),
          const ListHeader(text: "Live Entries"),
          const LiveEntriesView(),
          const EntryInsertionButtons(),
        ],
      )
    );
  }
}

class ListHeader extends StatelessWidget{ 

  final String text;
  const ListHeader( { required this.text, super.key } );


  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.all( 8 ),
      child: Text( 
        text, 
        textScaler: const TextScaler.linear( 1.8 )
      ),
    );
  }  
}
