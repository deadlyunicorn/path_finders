import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/profile/disclaimer/disclaimer_dialog_buttons.dart';
import 'package:path_finders/src/profile/disclaimer/disclaimer_dialog_header.dart';

class DisclaimerDialog extends StatelessWidget {
  const DisclaimerDialog({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

  final appLocalizations = AppLocalizations.of( context )!;

    return Dialog(
      shape: RoundedRectangleBorder(  
        borderRadius: BorderRadius.circular( 4 ),
      ),
      child: SizedBox(
        width: max( MediaQuery.sizeOf(context).width/2, 500),
        child: Padding(
          padding: const EdgeInsets.all( 8.0 ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DisclaimerDialogHeader(),
              const SizedBox.square( dimension: 12 ),
              Text(
                appLocalizations.dialog_liveSharing_disclaimer,
                textAlign: TextAlign.center),
              DisclaimerDialogButtons(appLocalizations: appLocalizations)
              
            
            
            ],
          ) 
        ),
      )
    );
  }
}
