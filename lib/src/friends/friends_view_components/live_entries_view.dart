import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:path_finders/src/friends/friends_view_components/entry_insertion_views/live_entry_dialog_view.dart';
import 'package:path_finders/src/providers/target_with_id_listings_provider.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/storage_services.dart';
import 'package:path_finders/src/target_location_fetch.dart';

class LiveEntriesView extends StatelessWidget{

  const LiveEntriesView({
    super.key,
  });

  

  @override
  Widget build(BuildContext context) {

    final appLocalizations = AppLocalizations.of( context )!;


    return FutureBuilder(
          future: TargetsFiles.getTargetsWithIdFromFile(), 
          builder: (context, snapshot) {

          final targetsMapListSnapshot = snapshot.data;
          
          ////using .read() instead of .watch()
          ////to not rebuild/refetch when changing targets.
          final targetProvider = context.watch<TargetProvider>();
          final targetsWithIdListingsProvider = context.watch<TargetWithIdListingsProvider>();
          

          
          if ( snapshot.connectionState == ConnectionState.done ){
            
            if ( targetsMapListSnapshot != null ){ 
              
              //We have ID entries in our file.
              if( targetsWithIdListingsProvider.targetEntries != targetsMapListSnapshot ){
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  targetsWithIdListingsProvider.set( targetsMapListSnapshot );
                });
              } 

              return StreamBuilder(
                stream: TargetLocationServices.targetLocationIntervalStream(), 
                builder: ( context, intervalStreamerSnapshot ){

                  if ( intervalStreamerSnapshot.connectionState == ConnectionState.active ){

                    return ListView.builder(

                      itemCount:  targetsWithIdListingsProvider.targetEntries.length,
                      itemBuilder: (context, index) {

                        
                        final targetEntry = targetsWithIdListingsProvider.targetEntries.elementAt(index);
                        
                        final String targetId = targetEntry["targetId"];
                        final String? targetName = targetEntry["targetName"];

                        return FutureBuilder(

                          future: TargetLocationServices.getTargetDetails( targetId ), 
                          builder: ( context, targetDetailsFutureSnapshot ) {

                            final targetDetailsSnapshotData = targetDetailsFutureSnapshot.data; 
                            Widget leadingIcon;

                            //Setting the leading icon of the entry.
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


                            // Updating the target provider's location whenever there is new data.
                            if ( targetId == targetProvider.targetName ){

                              if ( 
                                targetDetailsFutureSnapshot.connectionState == ConnectionState.done
                                && targetDetailsSnapshotData != null 
                              ){
                                
                                final targetLocationFromServer = targetDetailsSnapshotData.getCoordinates();
                                final targetLocationFromProvider = targetProvider.targetLocation;
        
                                //Updating the Target Provider in case
                                //Our streamer has returned new data about them.
                                //
                                //this basically updates the "Your distance is: XX m" widget.
                                if ( 
                                  targetLocationFromServer != null 
                                  && targetLocationFromServer.latitude != targetLocationFromProvider.latitude 
                                  && targetLocationFromServer.longitude != targetLocationFromProvider.longitude 
                                ){

                                  WidgetsBinding.instance.addPostFrameCallback((duration) { 
                                    targetProvider.setTargetLocation( targetLocationFromServer );
                                  });

                                }
                                
                              }

                            }


                            return Container ( 
                              margin: const EdgeInsets.all( 8 ),
                              decoration: targetProvider.targetName == targetId 
                                ? BoxDecoration( //target is selected
                                  border: Border.all(
                                    color: Theme.of( context ).highlightColor
                                  ),
                                  borderRadius: BorderRadius.circular( 4 ),
                                )
                                :null,
                              child: ListTile(
                                title:  Flex( 
                                  direction: Axis.horizontal,
                                  children: [
                                    Flexible(
                                      child: Text( 
                                        ( targetName != null && targetName.isNotEmpty ) ? targetName :"#$targetId",
                                        overflow: TextOverflow.fade, 
                                        maxLines: 1,
                                        softWrap: false,
                                      ),
                                    ), 
                                    //show targetName if exists
                                    //else targetId

                                    const SizedBox( width: 5 ),
                                    
                                    targetName != null && targetName.isNotEmpty
                                    //target name exists? show targetId
                                    //else nothing
                                    ? Text( "#$targetId", textScaler: const TextScaler.linear(0.6) ) 
                                    : const SizedBox.shrink()

                                  ]
                                ),
                                leading: SizedBox( 
                                  width: 32, 
                                  height: 32, 

                                  child: leadingIcon
                                
                                ) ,
                                trailing: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 200
                                    ),
                                    child: Flex(
                                    direction: Axis.horizontal,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        
                                        child: Text(
                                            targetDetailsSnapshotData != null 
                                            ? ( targetDetailsSnapshotData.hasErrorMessage()
                                              ? targetDetailsSnapshotData.getErrorMessage()! 
                                              : appLocalizations.entry_live_isSharing )
                                            : ( targetDetailsFutureSnapshot.connectionState == ConnectionState.done 
                                              ? appLocalizations.exception_networkError
                                              : "" ),
                                              overflow: TextOverflow.fade,
                                              textAlign: TextAlign.end,
                                              maxLines: 1,

                                          ) 
                                          
                                      )
                                    ],
                                  ) 
                                ),
                                onTap: () {
                                  if ( targetDetailsSnapshotData != null 
                                    && !targetDetailsSnapshotData.hasErrorMessage() 
                                  ){

                                    targetProvider.setTargetName( targetId ) ;
                                    targetProvider.setTargetLocation( targetDetailsSnapshotData.getCoordinates()! ) ;

                                  }
                                },
                                onLongPress: () {
                                  showDialog(
                                    context: context, 
                                    builder: ( context ) => LiveEntryDialog(
                                      listingsProvider: targetsWithIdListingsProvider,
                                      targetId: targetId,
                                      targetName: targetName,
                                    )
                                  );

                                },
                              )
                            );
                          }
                        );
                      },
                    );
                  }
                  else{
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                } 
              ); 

            }
            return Center( child: Text( appLocalizations.friends_noEntries ) ); 
          
          }
          else { 
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
    );
  }
}