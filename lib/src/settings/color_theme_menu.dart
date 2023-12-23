import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/settings/settings_controller.dart';

class ColorThemeMenu extends StatelessWidget {
  const ColorThemeMenu({
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
    );
  }
}
