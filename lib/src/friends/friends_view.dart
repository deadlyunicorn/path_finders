import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:flutter/material.dart';
import 'package:path_finders/src/custom/is_landscape.dart';
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

    final appLocalizations = AppLocalizations.of(context);

    double listHeight = isLandscape(context)? MediaQuery.of(context).size.height * 0.35 :MediaQuery.of(context).size.height * 0.2 ;
    double listWidth = isLandscape(context)? MediaQuery.of(context).size.width / 2.5 :MediaQuery.of(context).size.width;


    return (
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          heightIsSmall(context)
            ?const SizedBox.shrink()
            :const SelectionHeader(),
          Flex(
            mainAxisAlignment: MainAxisAlignment.center,
            direction: isLandscape(context)? Axis.horizontal :Axis.vertical,
            children: [
              Column(
                children: [
                  ListHeader(text: appLocalizations!.friends_static),
                  SizedBox(
                    height: listHeight,
                    width: listWidth,
                    child: const StaticEntriesView(),
                  )
                ],
              ),
              Column(
                children: [
                  ListHeader(text: appLocalizations.friends_live ),
                  SizedBox(
                    height: listHeight,
                    width: listWidth,
                    child: const LiveEntriesView(),
                  )
                ],
              )
            ],
          ),
          const EntryInsertionButtons(),
        ],
      )
    );
  }
}

class SelectionHeader extends StatelessWidget{

  const SelectionHeader({super.key});

  @override
  Widget build(BuildContext context) {

    final appLocalizations = AppLocalizations.of( context );
    
    return RichText(
            textScaler: const TextScaler.linear( 1.5 ),
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge,
              text: appLocalizations!.friends_currentSelection,
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
