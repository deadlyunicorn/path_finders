import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

List<Widget> dialogActions( 
  {
    void Function()? deletionHandler, 
    required Future<void> Function() submissionHandler,
    required void Function() cancellationHandler,
    required BuildContext context
  }  ) {

    final appLocalizations = AppLocalizations.of(context);
    return [

        deletionHandler != null 
          ?TextButton(
            onPressed: deletionHandler, 
            child: Text( appLocalizations!.dialog_delete ,style:const TextStyle( color: Colors.red) )
          )
          :const SizedBox.shrink(),

        Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: cancellationHandler, 
              child: Text( appLocalizations!.dialog_nevermind )
            ),
       
            TextButton(
                onPressed: submissionHandler,
                child: Text(  appLocalizations.dialog_confirm )
            )

          ]
        )
    ];
  } 