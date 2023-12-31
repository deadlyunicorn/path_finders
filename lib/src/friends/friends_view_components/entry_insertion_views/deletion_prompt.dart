import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:flutter/material.dart';
import 'package:path_finders/src/custom/styles.dart';
import 'package:path_finders/src/providers/target_listings_abstract.dart';

showDeletionConfirmationDialog( BuildContext context, TargetListingsProviderAbstract provider, String? initialTargetName ){

  final appLocalizations = AppLocalizations.of( context );

  showDialog(
    context: context, 
    builder: (context)
      =>AlertDialog(
        title: Text( appLocalizations!.dialog_delete_confirmation ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [

          TextButton(
            style: squaredButtonStyle,
            onPressed: (){
                Navigator.pop(context);
            }, 
            child: Text( appLocalizations.dialog_nevermind )
          ),

          TextButton(
            style: squaredButtonStyle,
            onPressed: ()async{
              
              if ( initialTargetName != null ){

                await provider.remove( initialTargetName );
              }
              if( !context.mounted ) return;
              while ( Navigator.canPop(context) ){
                Navigator.pop(context);
              }
              
            }, 
            child: Text( appLocalizations.dialog_confirm )
          ),
        ],
      )
    );
  }