import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:path_finders/src/friends/friends_view_components/entry_lists/live_entries_list.dart';
import 'package:provider/provider.dart';
import 'package:path_finders/src/providers/target_with_id_listings_provider.dart';
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
                    
                    final entryCount = targetsWithIdListingsProvider.targetEntries.length;
                    final List liveEntries = targetsWithIdListingsProvider.targetEntries;

                    return LiveEntriesList(
                      entryCount: entryCount,
                      liveEntries: liveEntries,
                      appLocalizations: appLocalizations
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
