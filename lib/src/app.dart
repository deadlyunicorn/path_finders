import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:path_finders/notifications/notification_controller.dart';
import 'package:path_finders/src/custom/isLandscape.dart';
import 'package:path_finders/src/settings/button.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:path_finders/src/using_the_app_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'settings/settings_controller.dart';

import 'package:path_finders/src/friends/friends_view.dart';
import 'package:path_finders/src/location_services_checker_view.dart';
import 'package:path_finders/src/navigation_bar/navigation_bar.dart';
import 'package:path_finders/src/profile/profile_view.dart';
import 'package:path_finders/src/providers/location_services_provider.dart';
import 'package:path_finders/src/providers/target_with_id_listings_provider.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/providers/targets_with_coordinates_provider.dart';
import 'package:path_finders/src/tracker/tracker_view.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {

  
  const MyApp({
    super.key,
    required this.settingsController,
  });

  
  final SettingsController settingsController;
  
  static final _defaultLightColorScheme = ColorScheme.fromSwatch();
  static final _defaultDarkColorScheme = ColorScheme.fromSwatch( brightness: Brightness.dark );

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  void initState() {
    NotificationController.startListeningNotificationEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_)=>widget.settingsController
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

              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''), // English, no country code
                Locale('el', 'GR'), // English, no country code
              ],
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.appTitle,

              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme ?? MyApp._defaultLightColorScheme 
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme ?? MyApp._defaultDarkColorScheme
              ),
              themeMode: widget.settingsController.themeMode,


              home:  Scaffold(
                appBar: isLandscape(context)
                ? null
                : AppBar(
                  elevation: 1,
                  backgroundColor: Theme.of( context).primaryColor.withAlpha( 100 ),
                  title: const Text( "Path Finders" ),
                  actions: [
                    SettingsDialogButton( settingsController: widget.settingsController )
                  ],
                  
                ),
                body: Container(
                  padding: const EdgeInsets.only( bottom: 20, top: 20 ),
                  alignment: Alignment.center,
                  child: const PageSelector(),
                ),
              
                bottomNavigationBar: const CustomNavigationBar() ,
              )
            )
          ),
        ); 
      },

    );
  }
}



class PageSelector extends StatelessWidget{
  
  const PageSelector({ super.key });

  @override
  Widget build(BuildContext context) {


    //Future that reads if it has been displayed.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 

      IntroFinishFile
        .introHasBeenFinished()
        .then(
          ( isTrue ) {
            if ( isTrue ){

            }
            else{

              showDialog(
                barrierDismissible: false,
                context: context, 
                builder: ( context ) => UsingTheAppDialog()
              );

            }
          }
        );
      
    });



    var appState = context.watch<CurrentPageState>();
    int selectedIndex = appState.currentPageIndex;

    return MultiProvider(
      providers: [ 
        ChangeNotifierProvider(
          create: (context) => TargetWithIdListingsProvider()
        ),
        ChangeNotifierProvider(
          create: (context) => TargetProvider()
        ),
        ChangeNotifierProvider(
          create: (_) => LocationServicesProvider() 
        ),
        ChangeNotifierProvider(
          create: (_) => TargetWithCoordinatesListingsProvider()
        )
      ],
      child: IndexedStack(
        index: selectedIndex,
        children: const [
          FriendsView(),
          LocationServicesCheckerView(child: TrackerView()),
          LocationServicesCheckerView(child: ProfileView()) 
        ],
      )
    );
  }

}

class CurrentPageState extends ChangeNotifier {

  int _currentPageIndex = 1;

  int get currentPageIndex => _currentPageIndex;

  void setCurrentPageIndex( int value){
    _currentPageIndex = value;
    notifyListeners();
  }
}
