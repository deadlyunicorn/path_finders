import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/friends/friends_view_components/entry_lists/live_entry_listing.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/target_location_fetch.dart';
import 'package:path_finders/src/types/target_details.dart';
import 'package:provider/provider.dart';

class LiveEntriesList extends StatelessWidget {
  const LiveEntriesList({
    super.key,
    required this.appLocalizations,
    required this.entryCount,
    required this.liveEntries
  });

  final AppLocalizations appLocalizations;
  final int entryCount;
  final List liveEntries;

  @override
  Widget build(BuildContext context) {

    final targetProvider = context.watch<TargetProvider>();


    return ListView.builder(
    
      itemCount:  entryCount,
      itemBuilder: (context, index) {
    
        
        final targetEntry = liveEntries.elementAt(index);
        
        final String targetId = targetEntry["targetId"] ?? "";
        final String targetName = targetEntry["targetName"] ?? "";
        // final selectedTargetName = targetProvider.targetName;

    
        return FutureBuilder(
    
          future: TargetLocationServices.getTargetDetails( targetId ), 
          builder: ( context, targetDetailsFutureSnapshot ) {
    
            final targetDetailsSnapshotData = targetDetailsFutureSnapshot.data; 
            Widget leadingIcon = const Icon ( Icons.error, color: Colors.red );
    
            //Setting the leading icon of the entry.
            leadingIcon = setLeadingIconBasedOnTargetConnectionStatus(
              targetDetailsFutureSnapshot, 
              leadingIcon, 
              targetDetailsSnapshotData
            );
    
    
            // Updating the target provider's location whenever there is new data.
            // liveTargetLocationUpdater(
            //   targetId, 
            //   selectedTargetName, 
            //   targetDetailsFutureSnapshot, 
            //   targetDetailsSnapshotData, 
            //   targetProvider
            // );
    
    
            final targetStatus = targetDetailsSnapshotData != null 
              ? ( targetDetailsSnapshotData.hasErrorMessage()
                ? targetDetailsSnapshotData.getErrorMessage()! 
                : appLocalizations.entry_live_isSharing )
              : ( targetDetailsFutureSnapshot.connectionState == ConnectionState.done 
                ? appLocalizations.exception_networkError
                : "" );
                            
            return LiveEntryListing(
              targetId: targetId, 
              targetName: targetName, 
              leadingIcon: leadingIcon, 
              targetStatus: targetStatus, 
              targetDetailsFutureSnapshot: targetDetailsFutureSnapshot, 
              targetProvider: targetProvider,
            );
          }
        );
      },
    );
  }

  // void liveTargetLocationUpdater(String targetId, String selectedTargetName, AsyncSnapshot<TargetDetails?> targetDetailsFutureSnapshot, TargetDetails? targetDetailsSnapshotData, TargetProvider targetProvider) {
  //   if ( targetId == selectedTargetName ){
        
  //     if ( 
  //       targetDetailsFutureSnapshot.connectionState == ConnectionState.done
  //       && targetDetailsSnapshotData != null 
  //     ){
        
  //       final targetLocationFromServer = targetDetailsSnapshotData.getCoordinates();
  //       final targetLocationFromProvider = targetProvider.targetLocation;
    
  //       //Updating the Target Provider in case
  //       //Our streamer has returned new data about them.
  //       //
  //       //this basically updates the "Your distance is: XX m" widget.
  //       if ( 
  //         targetLocationFromServer != null 
  //         && targetLocationFromServer.latitude != targetLocationFromProvider.latitude 
  //         && targetLocationFromServer.longitude != targetLocationFromProvider.longitude 
  //       ){
        
  //         WidgetsBinding.instance.addPostFrameCallback((duration) { 
  //           targetProvider.setTargetLocation( targetLocationFromServer );
  //         });
        
  //       }
        
  //     }
        
  //   }
  // }

  Widget setLeadingIconBasedOnTargetConnectionStatus(AsyncSnapshot<TargetDetails?> targetDetailsFutureSnapshot, Widget leadingIcon, TargetDetails? targetDetailsSnapshotData) {
    
    switch ( targetDetailsFutureSnapshot.connectionState ){
        
      case ConnectionState.waiting:
        leadingIcon = const CircularProgressIndicator ( strokeWidth: 0.1,);
        break;
        
      case ConnectionState.done:
        
        if ( targetDetailsFutureSnapshot.hasData && targetDetailsSnapshotData != null ){
        
          if ( targetDetailsSnapshotData.hasErrorMessage() ){
            leadingIcon = const Icon( Icons.warning, color: Colors.yellow );
          }
          else{
            leadingIcon = const Icon( Icons.done, color: Colors.green, );
          }
        
        }
        else{
          leadingIcon = const Icon ( Icons.error, color: Colors.red );
        }
        break;
        
      default:
        leadingIcon = const Icon ( Icons.error, color: Colors.red );
        break;
        
    }
    return leadingIcon;
  }
}
