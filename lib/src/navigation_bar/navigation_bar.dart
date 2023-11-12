import 'package:flutter/material.dart';
import 'package:path_finders/src/app.dart';
import 'package:provider/provider.dart';

class CustomNavigationBar extends StatelessWidget{

  const CustomNavigationBar({ super.key });

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<CurrentPageState>();
    int selectedIndex = appState.currentPageIndex;
    
    return(
      NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.group), 
            label: "Friends"
          ),
          NavigationDestination(
            icon: Icon(Icons.gps_fixed), 
            label: "Track",
          ),
          NavigationDestination(
            icon: Icon(Icons.person), 
            label: "Profile",
          )],
        selectedIndex: selectedIndex,
        onDestinationSelected: ( value ){
          appState.setCurrentPageIndex(value);
        },
      )
    );
  }
}