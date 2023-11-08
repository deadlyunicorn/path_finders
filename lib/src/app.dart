import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_finders/src/friends/friends_view.dart';
import 'package:path_finders/src/navigation_bar/navigation_bar.dart';
import 'package:path_finders/src/providers/friend_locator_provider.dart';
import 'package:path_finders/src/sensors/sensors_view.dart';
import 'package:provider/provider.dart';

import 'sample_feature/sample_item_list_view.dart';
import 'settings/settings_controller.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ChangeNotifierProvider(
      create: (_)=>CurrentPageState(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp( 
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
            useMaterial3: true
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true
          ),
          themeMode: settingsController.themeMode,


          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          home: Scaffold(
              appBar: AppBar(
                elevation: 1,
                foregroundColor: Colors.blue.shade600,
                title: const Text( "Path Finders" ),
              ),
              body: ChangeNotifierProvider<TargetProvider>(
                create: (_) => TargetProvider(),
                child: Container(
                  padding: const EdgeInsets.only( bottom: 20, top: 20 ),
                  alignment: Alignment.center,

                  child: const PageSelector(),
                )
              ),
              // Navigator( 
              //   onGenerateRoute: ( routeSettings ){
              //     return MaterialPageRoute(builder: (_) => routeSelection(routeSettings, settingsController));
              //   },
              // ) ,
              bottomNavigationBar: const CustomNavigationBar() ,
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

    var appState = context.watch<CurrentPageState>();
    int selectedIndex = appState.currentPageIndex;

    return IndexedStack(
      index: selectedIndex,
      children: const [
         FriendsView(),
         SensorsView()
      ],
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