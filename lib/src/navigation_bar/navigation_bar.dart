import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:path_finders/src/page_selector.dart';

class CustomNavigationBar extends StatelessWidget{

  const CustomNavigationBar({ super.key });

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<CurrentPageState>();
    int selectedIndex = appState.currentPageIndex;

    final appLocalizations = AppLocalizations.of(context);
    
    return(
      NavigationBar(
        height: 64,
        backgroundColor: Theme.of(context).primaryColor.withAlpha( 100 ),
        destinations:  [
          NavigationDestination(
            icon: Icon(Icons.group), 
            label: appLocalizations!.navigation_friends
          ),
          NavigationDestination(
            icon: Icon(Icons.gps_fixed), 
            label: appLocalizations!.navigation_track,
          ),
          NavigationDestination(
            icon: Icon(Icons.person), 
            label: appLocalizations!.navigation_profile,
          )],
        selectedIndex: selectedIndex,
        onDestinationSelected: ( value ){
          appState.setCurrentPageIndex(value);
        },
      )
    );
  }
}