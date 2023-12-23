import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/settings/settings_controller.dart';

class LocaleSettingsDropMenu extends StatelessWidget {
  const LocaleSettingsDropMenu({
    super.key,
    required this.appLocalizations,
    required this.settingsController,
  });

  final AppLocalizations appLocalizations;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text( "${appLocalizations.settings_language}: ", style: Theme.of(context).textTheme.bodyLarge ),
        DropdownButton(
          value: settingsController.locale,
          items: [
            DropdownMenuItem(
              value: "en",
              child: Text( "🇺🇸 English - ${appLocalizations.lang_english}" ),
            ),
            DropdownMenuItem(
              value: "el",
              child: Text( "🇬🇷 Greek - ${appLocalizations.lang_greek}" ),
            ),
          ], 
          onChanged: (value) {
            if ( value != null ){
              settingsController.updateLocaleSetting( value );
            }
          },
        )
      ],
    );
  }
}
