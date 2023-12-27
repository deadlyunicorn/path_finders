import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:path_finders/src/settings/settings_controller.dart';
import 'package:path_finders/src/settings/settings_view.dart';


class SettingsDialogButton extends StatelessWidget {
            
  final SettingsController settingsController;
  const SettingsDialogButton({ super.key, required this.settingsController });

  @override
  Widget build(BuildContext context) {


    return IconButton(
                    tooltip: AppLocalizations.of(context)!.settings,
                    onPressed: (){
                      showDialog(
                        context: context, 
                        builder: ( context ) =>  Dialog.fullscreen(
                          child: SettingsView(settingsController: settingsController)
                        ),
                      );
                    },  
                    icon:const Icon( Icons.settings )
                  );
  }
}
