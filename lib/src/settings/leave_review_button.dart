import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/custom/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class LeaveReviewButton extends StatelessWidget {
  const LeaveReviewButton({
    super.key,
    required this.appLocalizations,
  });

  final AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: squaredButtonStyle,
      onPressed: ()async{
        
        
        const appId = "com.deadlyunicorn.path_finders";  //edit inside gradle
    
        try{
    
           await launchUrl( 
            Uri.parse("market://details?id=$appId"),
           );
    
        }
        catch( error ){ //no playstore installed?!
          await launchUrl( 
            Uri.parse("https://play.google.com/store/apps/details?id=$appId"),
           );
    
        }
       
      }, 
      child: Text( appLocalizations.reviewText )
    );
  }
}
