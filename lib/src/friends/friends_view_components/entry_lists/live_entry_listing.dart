import 'package:flutter/material.dart';
import 'package:path_finders/src/friends/friends_view_components/entry_insertion_views/live_entry_dialog_view.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/providers/target_with_id_listings_provider.dart';
import 'package:path_finders/src/types/target_details.dart';
import 'package:provider/provider.dart';

class LiveEntryListing extends StatelessWidget {
  const LiveEntryListing({
    super.key,
    required this.targetId,
    required this.targetName,
    required this.leadingIcon,
    required this.targetStatus,
    required this.targetDetailsFutureSnapshot,
    required this.targetProvider
  });

  final String targetId;
  final String targetName;
  final Widget leadingIcon;
  final String targetStatus;
  final TargetProvider targetProvider;
  final AsyncSnapshot<TargetDetails?>? targetDetailsFutureSnapshot;

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext listingContext) {

    final targetDetailsSnapshotData = targetDetailsFutureSnapshot?.data; 

    return Container ( 
      margin: const EdgeInsets.all( 8 ),
      decoration: borderHighlighter(targetProvider, listingContext),
      child: ListTile(
        title:  Flex( 
          direction: Axis.horizontal,
          children: [
            Flexible(
              child: Text( 
                targetName.isNotEmpty  ? targetName :"#$targetId",
                overflow: TextOverflow.fade, 
                maxLines: 1,
                softWrap: false,
              ),
            ), 
            //show targetName if exists
            //else targetId
        
            const SizedBox( width: 5 ),
            
            targetName.isNotEmpty
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
                    targetStatus,
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
        
            targetProvider.setTarget(
              targetName: targetName, 
              targetLocation: targetDetailsSnapshotData.getCoordinates()!
            );
          }
        },
        onLongPress: () {
          showDialog(
            context: listingContext, 
            builder: ( context ) {
            
              final liveListingsProvider = listingContext.watch<TargetWithIdListingsProvider>();
              return LiveEntryDialog(
                targetId: targetId,
                targetName: targetName,
                listingsProvider: liveListingsProvider,
              );

            } 
          );
        
        },
      )
    );
  }

  BoxDecoration? borderHighlighter(TargetProvider targetProvider, BuildContext context) {
    return targetProvider.targetName == targetId 
    ? BoxDecoration( //target is selected
      border: Border.all(
        color: Theme.of( context ).highlightColor
      ),
      borderRadius: BorderRadius.circular( 4 ),
    )
    :null;
  }
}