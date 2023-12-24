import 'dart:math';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/friends/friends_view_components/entry_insertion_views/deletion_prompt.dart';
import 'package:path_finders/src/friends/friends_view_components/entry_insertion_views/dialog_actions.dart';
import 'package:path_finders/src/friends/id_formatter.dart';
import 'package:path_finders/src/providers/target_with_id_listings_provider.dart';
import 'package:provider/provider.dart';

class LiveEntryDialog extends StatefulWidget{

  final String? _targetId; 
  final String? _targetName;
  final TargetWithIdListingsProvider listingsProvider;

  const LiveEntryDialog(
    {
      super.key, 
      String? targetId,
      String? targetName,
      required this.listingsProvider
    }) : _targetName = targetName, _targetId = targetId;

  @override
  State<LiveEntryDialog> createState() => _LiveEntryDialogState();
}

class _LiveEntryDialogState extends State<LiveEntryDialog> {

  String targetId = "133-337";
  String targetName = "easter egg"; //prevent restoring the widget vallue when isEmpty
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {

    final appLocalizations = AppLocalizations.of( context );

    //here
    if ( targetId == "133-337" ) targetId = widget._targetId ?? "";
    if ( targetName == "easter egg" ) targetName = widget._targetName ?? "";

    final targetListingsWithId = widget.listingsProvider;

    return AlertDialog(
      title: Text( appLocalizations!.entry_live_insertion ),
      content: SizedBox(
        width: min(MediaQuery.of(context).size.width - 100, 500) ,
        child: SingleChildScrollView(
          child: Column( 
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: targetId == widget._targetId 
                  ? TextEditingController( text: targetId )
                  :null ,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  CustomInputFormatter(),
                  LengthLimitingTextInputFormatter(7),
                ],
                onChanged: (value) {
                  setState( (){
                    targetId = value;
                  });
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
                controller: targetName == widget._targetName 
                ?TextEditingController( text: targetName )
                :null,
                onChanged: (value){
                  setState((){
                    targetName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: appLocalizations.entry_friendlyName,
                  hintText: appLocalizations.entry_friendlyNameHint,
                ),

              ),
              const SizedBox( height:8 ),
              Text( 
                errorMessage,
                style: TextStyle( color: Theme.of(context).colorScheme.error )
              )

            ]
          ) 
        )
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: dialogActions(
        context: context,
        deletionHandler: widget._targetId == null  ? null 
          :(){
            showDeletionConfirmationDialog(context, targetListingsWithId, widget._targetId);
          },
        cancellationHandler: (){
          Navigator.pop(context,"Cancel");
        },
        submissionHandler: () async{

          
          if( targetId.isNotEmpty && targetId.length == 7 ){ 
            await targetListingsWithId.remove( targetId );
            if ( widget._targetId != null ) await targetListingsWithId.remove( widget._targetId ?? "" );
            await targetListingsWithId.add( targetId, targetName: targetName );
            if ( context.mounted ){
              Navigator.pop(context, "Submit");
            } 
          }
          else{
            setState( (){
              errorMessage = appLocalizations.errors_invalidUserId;
            });

            ScaffoldMessenger.of(context).hideCurrentSnackBar();

            ScaffoldMessenger
            .of( context )
            .showSnackBar(
              CustomSnackBar(
                duration: const Duration( seconds: 2),
                bgColor: Theme.of(context).colorScheme.error.withAlpha( 220 ),
                textContent: errorMessage,
                textStyle: TextStyle( color: Theme.of(context).colorScheme.onError ),
                context: context
              )
            );
          }
        }, 
      )
    );

  }
}