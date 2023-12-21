import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:path_finders/src/custom/styles.dart';

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
            style: squaredButtonStyle,
            onPressed: deletionHandler, 
            child: Text( appLocalizations!.dialog_delete ,style:const TextStyle( color: Colors.red) )
          )
          :const SizedBox.shrink(),

        Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              style: squaredButtonStyle,
              onPressed: cancellationHandler, 
              child: Text( appLocalizations!.dialog_nevermind )
            ),
       
            TextButton(
                style: squaredButtonStyle,
                onPressed: submissionHandler,
                child: Text(  appLocalizations.dialog_confirm )
            )

          ]
        )
    ];
  } 