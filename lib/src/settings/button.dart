import 'package:flutter/material.dart';
import 'package:path_finders/src/settings/settings_controller.dart';
import 'package:path_finders/src/settings/settings_view.dart';

class SettingsDialogButton extends StatelessWidget {
            
  final SettingsController settingsController;
  SettingsDialogButton({ super.key, required this.settingsController });

  @override
  Widget build(BuildContext context) {


    return IconButton(
                    onPressed: (){
                      showDialog(
                        context: context, 
                        builder: ( context ) =>  Dialog.fullscreen(
                          child: SettingsView(settingsController: settingsController)
                        ),
                      );
                    },  
                    icon: Icon( Icons.settings )
                  );
  }
}
