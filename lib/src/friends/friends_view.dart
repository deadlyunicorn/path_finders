import 'package:flutter/material.dart';
import 'package:path_finders/src/friends/entry_insertion_buttons.dart';
import 'package:path_finders/src/friends/friends_view_components/live_entries_view.dart';
import 'package:path_finders/src/friends/friends_view_components/static_entries_view.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:provider/provider.dart';


class FriendsView extends StatefulWidget {

  const FriendsView( {super.key });

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {

  String friendToAdd = "";

  @override
  Widget build(BuildContext context) {

    return (
      const Column(
        children: [
          SelectionHeader(),
          ListHeader(text: "Static Entries"),
          StaticEntriesView(),
          ListHeader(text: "Live Entries"),
          LiveEntriesView(),
          EntryInsertionButtons(),
        ],
      )
    );
  }
}

class SelectionHeader extends StatelessWidget{

  const SelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    
    return RichText(
            textScaler: const TextScaler.linear( 1.5 ),
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge,
              text: "Current selection: ",
              children: [
                TextSpan(
                  text: context.watch<TargetProvider>().targetName,
                  style: const TextStyle(
                    decoration: TextDecoration.underline
                  ),
                ),
              ]
            ),
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
      margin: const EdgeInsets.only( top: 8 ),
      child: Text( 
        text, 
        textScaler: const TextScaler.linear( 1.4 )
      ),
    );
  }  
}
