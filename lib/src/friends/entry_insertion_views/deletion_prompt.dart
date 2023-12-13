import 'package:flutter/material.dart';
import 'package:path_finders/src/providers/target_listings_abstract.dart';

showDeletionConfirmationDialog( BuildContext context, TargetListingsProviderAbstract provider, String? initialTargetName ){
  showDialog(
    context: context, 
    builder: (context)
      =>AlertDialog(
        title: Text("Confirm deletion"),
        actionsAlignment: MainAxisAlignment.center,
        actions: [

          TextButton(
            onPressed: (){
                Navigator.pop(context);
            }, 
            child: const Text("Nevermind")
          ),

          TextButton(
            onPressed: ()async{
              if ( initialTargetName != null ){

                await provider.remove( initialTargetName );
              }
              while ( Navigator.canPop(context) ){
                
                Navigator.pop(context);
              }
            }, 
            child: Text("Confirm")
          ),
        ],
      )
    );
  }