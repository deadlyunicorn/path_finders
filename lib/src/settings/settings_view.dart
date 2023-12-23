import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/settings/bug_report_button.dart';
import 'package:path_finders/src/settings/color_theme_menu.dart';
import 'package:path_finders/src/settings/locale_settings_drop_menu.dart';
import 'package:path_finders/src/settings/leave_review_button.dart';
import 'package:path_finders/src/settings/sponsor_button.dart';


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
                ColorThemeMenu(appLocalizations: appLocalizations, settingsController: settingsController),
                LocaleSettingsDropMenu(appLocalizations: appLocalizations, settingsController: settingsController)

              ],
            ),
            Column(
              children: [
                LeaveReviewButton(appLocalizations: appLocalizations),
                SponsorButton(appLocalizations: appLocalizations),
                BugReportButton(appLocalizations: appLocalizations)

              ],
            )
          ],
        ) 
        
      ),
    );
  }
}
