
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_finders/src/friends/entry_insertion_views/deletion_prompt.dart';
import 'package:path_finders/src/friends/entry_insertion_views/dialog_actions.dart';
import 'package:path_finders/src/friends/id_formatter.dart';
import 'package:path_finders/src/providers/target_with_id_listings_provider.dart';

class LiveEntryDialog extends StatelessWidget{

  final TargetWithIdListingsProvider listingsProvider;

  final String? _targetId; 
  final String? _targetName;

  const LiveEntryDialog(
    {
      super.key, 
      required this.listingsProvider,
      String? targetId,
      String? targetName,
    }) : _targetName = targetName, _targetId = targetId;



  @override
  Widget build(BuildContext context) {

    String? targetId = _targetId;
    String? targetName = _targetName;

    final targetListingsWithId = listingsProvider;

    return AlertDialog(
      title: const Text("Enter user ID"),
      content: Column( 
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: TextEditingController( text: targetId ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              CustomInputFormatter(),
              LengthLimitingTextInputFormatter(7),
            ],
            onChanged: (value) {
                targetId = value;
            },
            decoration: const InputDecoration(
              labelText: "ID",
              hintText: "###-###",
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          TextField(
            controller: TextEditingController( text: targetName ),
            onChanged: (value){
              targetName = value;
            },
            decoration: const InputDecoration(
              labelText: "Friendly Name",
              hintText: "A fellow lost soul",
            ),

          )
      ]), 
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: dialogActions(
        deletionHandler: (){
          showDeletionConfirmationDialog(context, targetListingsWithId, _targetId);
        },
        cancellationHandler: (){
          Navigator.pop(context,"Cancel");
        },
        submissionHandler: () async{
          
          final finalTargetId = targetId;

          //Return maybe causes bugs here??
          if( finalTargetId != null && finalTargetId.length == 7 ){ 
            await targetListingsWithId.remove(finalTargetId);
            if ( _targetId != null ) await targetListingsWithId.remove(_targetId);
            await targetListingsWithId.add( finalTargetId, targetName: targetName );
            if ( context.mounted ){
              Navigator.pop(context, "Submit");
            } 
          }
        }, 
      )
    );

  }
}