import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:path_finders/notifications/notification_controller.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:path_finders/src/using_the_app_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'sample_feature/sample_item_list_view.dart';
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

    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ChangeNotifierProvider(
      create: (_)=>CurrentPageState(),
      builder: (BuildContext context, Widget? child) {
        return DynamicColorBuilder(
          builder: ( lightColorScheme, darkColorScheme ) => MaterialApp( 
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightColorScheme ?? MyApp._defaultLightColorScheme 
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkColorScheme ?? MyApp._defaultDarkColorScheme
            ),
            themeMode: widget.settingsController.themeMode,


            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
            home: Scaffold(
              appBar: AppBar(
                 elevation: 1,
                 backgroundColor: Theme.of( context).primaryColor.withAlpha( 100 ),
                 title: const Text( "Path Finders" ),
                 actions: const [
                   Icon( Icons.settings )
                 ],
              ),
              body: Container(
                padding: const EdgeInsets.only( bottom: 20, top: 20 ),
                alignment: Alignment.center,
                child: const PageSelector(),
              )
              ,
              // Navigator( 
              //   onGenerateRoute: ( routeSettings ){
              //     return MaterialPageRoute(builder: (_) => routeSelection(routeSettings, settingsController));
              //   },
              // ) ,
              bottomNavigationBar: const CustomNavigationBar() ,
            )
          )
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

StatelessWidget routeSelection(RouteSettings routeSettings, SettingsController settingsController){


  switch (routeSettings.name) {
    /*case SettingsView.routeName:
      // return SettingsView(controller: settingsController);
    case SampleItemDetailsView.routeName:
      return const SampleItemDetailsView();
    case SampleItemListView.routeName:
    */
    default:
      return const SampleItemListView();
  }
}