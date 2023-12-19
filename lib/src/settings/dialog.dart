
import 'package:flutter/material.dart';
import 'package:path_finders/src/settings/settings_controller.dart';
import 'package:provider/provider.dart';

class SettingsDialog extends StatelessWidget{

  final SettingsController settingsController;
  SettingsDialog( {super.key, required this.settingsController });

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<SettingsController>();

    return Flex(
      direction: Axis.vertical,
      children: [
        Text( 
          "Settings", 
          style: Theme.of(context).textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        Switch(
          value: false,
          onChanged: ( newValue ){
            
            
            appState.updateThemeMode( ThemeMode.light );
            print ( settingsController.themeMode ) ;
          },
        )
      ],
    );
  }
}