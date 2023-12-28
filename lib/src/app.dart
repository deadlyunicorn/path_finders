import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/ui/with_foreground_task.dart';
import 'package:path_finders/src/page_selector.dart';
import 'settings/settings_controller.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:path_finders/src/navigation_bar/navigation_bar.dart';
import 'package:path_finders/src/custom/is_landscape.dart';
import 'package:path_finders/src/settings/button.dart';


/// The Widget that configures your application.
class MyApp extends StatelessWidget {

  
  const MyApp({
    super.key,
    required this.settingsController,
  });

  
  final SettingsController settingsController;
  
  static final _defaultLightColorScheme = ColorScheme.fromSwatch();
  static final _defaultDarkColorScheme = ColorScheme.fromSwatch( brightness: Brightness.dark );

  @override
  Widget build(BuildContext context) {

    return WithForegroundTask(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_)=>settingsController
          ),
          ChangeNotifierProvider(
            create: (_)=>CurrentPageState()
          ),
      
        ],
        builder: (BuildContext context, Widget? child) {
      
          return Consumer<SettingsController>(
            builder: (context, value, child) => DynamicColorBuilder(
              builder: ( lightColorScheme, darkColorScheme ) => MaterialApp( 
      
                restorationScopeId: 'path-finders',
                locale: Locale( settingsController.locale ), 
      
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en', ''), // English, no country code
                  Locale('el', 'GR'),
                ],
                onGenerateTitle: (BuildContext context) => "Path Finders",
      
                theme: ThemeData(
                  useMaterial3: true,
                  colorScheme: lightColorScheme ?? _defaultLightColorScheme 
                ),
                darkTheme: ThemeData(
                  useMaterial3: true,
                  colorScheme: darkColorScheme ?? _defaultDarkColorScheme
                ),
                themeMode: settingsController.themeMode,
      
      
                home:  Scaffold(
                  appBar: heightIsSmall(context)
                  ? null
                  : AppBar(
                    elevation: 1,
                    backgroundColor: Theme.of( context).primaryColor.withAlpha( 100 ),
                    title: const Text( "Path Finders" ),
                    actions: [
                      SettingsDialogButton( settingsController: settingsController )
                    ],
                    
                  ),
                  body: Container(
                    padding: const EdgeInsets.all( 20 ),
                    alignment: Alignment.center,
                    child: const PageSelector(),
                  ),
                
                  bottomNavigationBar: const CustomNavigationBar() ,
                )
              )
            ),
          ); 
        },
      
      ),
    );
  }
}




