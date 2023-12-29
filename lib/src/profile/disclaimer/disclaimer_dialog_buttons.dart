import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/custom/styles.dart';
import 'package:path_finders/src/custom/storage_services.dart';

class DisclaimerDialogButtons extends StatelessWidget {
  const DisclaimerDialogButtons({
    super.key,
    required this.appLocalizations,
  });

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          style: squaredButtonStyle,
          child: Text( appLocalizations.dialog_nevermind, style: TextStyle( color: Theme.of(context).colorScheme.error ),)
        ),
        TextButton(
          style: squaredButtonStyle,
          onPressed: ()async{
            await DisclaimerAcceptionFile.acceptDisclaimer();
            
            if ( context.mounted ){
              Navigator.pop(context);
            }
          }, 
          child: Text( appLocalizations.dialog_confirm )
        )
        
      ],
    );
  }
}