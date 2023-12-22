import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';

class CopyService {

  static Future<void> copyTextToClipboard( String text, { required BuildContext context } ) async{

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger
    .of(context)
    .showSnackBar(
      CustomSnackBar(
        context: context,
        duration: const Duration( seconds: 1 ),
        textContent: AppLocalizations.of(context)!.snackbar_copied,
      )
    );
    await Clipboard.setData( 
      ClipboardData(
          text: text
        ) 
      );
    await HapticFeedback.heavyImpact();
  }
}