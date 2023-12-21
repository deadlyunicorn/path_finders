import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:path_finders/src/friends/friends_view.dart';
import 'package:path_finders/src/location_services_checker_view.dart';
import 'package:path_finders/src/profile/profile_view.dart';
import 'package:path_finders/src/providers/location_services_provider.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/providers/target_with_id_listings_provider.dart';
import 'package:path_finders/src/providers/targets_with_coordinates_provider.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:path_finders/src/tracker/tracker_view.dart';
import 'package:path_finders/src/using_the_app_dialog.dart';

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
                builder: ( context ) => const UsingTheAppDialog()
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
