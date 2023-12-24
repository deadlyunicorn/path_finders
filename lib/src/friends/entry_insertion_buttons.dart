import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:path_finders/src/friends/friends_view_components/entry_insertion_views/live_entry_dialog_view.dart';
import 'package:path_finders/src/friends/friends_view_components/entry_insertion_views/static_entry_dialog_view.dart';

import 'package:path_finders/src/providers/target_with_id_listings_provider.dart';
import 'package:path_finders/src/providers/targets_with_coordinates_provider.dart';
import 'package:provider/provider.dart';

class EntryInsertionButtons extends StatelessWidget{

  const EntryInsertionButtons( {super.key});

  @override
  Widget build(BuildContext context) {

    final appLocalizations = AppLocalizations.of(context);

    final liveListingsProvider = context.watch<TargetWithIdListingsProvider>();
    final staticListingsProvider = context.watch<TargetWithCoordinatesListingsProvider>();

    
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                FilledButton.tonal(
                  onPressed: () => showDialog(
                    context: context, 
                    builder: (context) => 
                      StaticEntryDialog( staticListingsProvider: staticListingsProvider ),
                  ), 
                  child: Text( appLocalizations!.friends_addStatic),
                ),
                IconButton(
                  icon: const Icon ( Icons.refresh, ),
                  onPressed: (){
                    liveListingsProvider.notifyConsumers();
                  } 
                ),
                FilledButton.tonal(

                  onPressed: () => showDialog(
                    context: context, 
                    builder: (context) {
                      return LiveEntryDialog( listingsProvider: liveListingsProvider );
                    }
                  ),
                  child: Text( appLocalizations.friends_addLive ) 
                )
                
              ]
            );
  }
}
