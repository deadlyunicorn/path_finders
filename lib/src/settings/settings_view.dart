import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/custom/styles.dart';
import 'package:path_finders/src/settings/bug_report_dialog.dart';
import 'package:url_launcher/url_launcher.dart';


import 'settings_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.settingsController});

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {


    final appLocalizations = AppLocalizations.of( context );

    return Scaffold(
      appBar: AppBar(
        title:  Text( appLocalizations!.settings ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the SettingsController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // SettingsController is updated, which rebuilds the MaterialApp.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            
            Column(
              children: [
                Row(
                  children: [
                    Text( "${appLocalizations.settings_theme}: ", style: Theme.of(context).textTheme.bodyLarge ),
                    DropdownButton<ThemeMode>(
                      // Read the selected themeMode from the controller
                      value: settingsController.themeMode,
                      // Call the updateThemeMode method any time the user selects a theme.
                      onChanged: settingsController.updateThemeMode,
                      items: [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text( appLocalizations.settings_systemTheme),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text( appLocalizations.settings_lightMode ),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text( appLocalizations.settings_darkMode),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text( "${appLocalizations.settings_language}: ", style: Theme.of(context).textTheme.bodyLarge ),
                    DropdownButton(
                      value: settingsController.locale,
                      items: [
                        DropdownMenuItem(
                          child: Text( "🇺🇸 English - ${appLocalizations.lang_english}" ),
                          value: "en",
                        ),
                        DropdownMenuItem(
                          child: Text( "🇬🇷 Greek - ${appLocalizations.lang_greek}" ),
                          value: "el",
                        ),
                      ], 
                      onChanged: (value) {
                        if ( value != null ){
                          settingsController.updateLocaleSetting( value );
                        }
                      },
                    )
                  ],
                )

              ],
            ),
            Column(
              children: [
                TextButton(
                  style: squaredButtonStyle,
                  onPressed: ()async{
                    
                    ScaffoldMessenger.of(context)
                    .showSnackBar( CustomSnackBar(textContent: "Not yet Implmented - Contact Dev", context: context));
                    
                    final appId = ""; //To be implemented

                    try{

                       await launchUrl( 
                        Uri.parse("market://details?id=$appId"),
                        mode: LaunchMode.externalApplication 
                       );

                    }
                    catch( error ){ //no playstore installed?!
                      await launchUrl( 
                        Uri.parse("https://play.google.com/store/apps/details?id=$appId"),
                        mode: LaunchMode.externalApplication 
                       );

                    }
                   
                  }, 
                  child: Text( appLocalizations.reviewText )
                ),
                TextButton(
                  style: squaredButtonStyle,
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (context) => BugReportDialog()
                    );
                  }, 
                  child: Text( appLocalizations.bugReport )
                )
                

              ],
            )
          ],
        ) 
        
      ),
    );
  }
}
