import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:path_finders/src/custom/is_landscape.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/tracker/format_distance.dart';
import 'package:path_finders/src/types/coordinates.dart';

class DistanceToTargetView extends StatefulWidget {
  const DistanceToTargetView({
    super.key,
    required this.distanceToTarget,
    required this.appLocalizations,
    required this.appState,
    required this.targetLocation,
    required this.notificationIsEnabled
  });

  final int distanceToTarget;
  final AppLocalizations appLocalizations;
  final TargetProvider appState;
  final Coordinates targetLocation;
  final bool notificationIsEnabled;

  @override
  State<DistanceToTargetView> createState() => _DistanceToTargetViewState();
}

class _DistanceToTargetViewState extends State<DistanceToTargetView> {

  int lastDistanceSnapshot = 0;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: isLandscape(context)? MediaQuery.sizeOf(context).width * 0.5 :MediaQuery.sizeOf(context).width * 0.85,
      child: Padding(
        padding: const EdgeInsets.only( top: 8 ),
        child: widget.distanceToTarget < 15
          ?Text(
            widget.appLocalizations.tracking_nearby,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          )
          :Column( 
            children:[
              Text( 
                " ${ widget.appLocalizations.tracking_distanceToIs(widget.appState.targetName)}",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 48,
                  ),
                  Text( 
                    DistanceFormatter.metersFormatter( widget.distanceToTarget ),
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 48,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: IconButton(
                        onPressed: ()async{
                          await launchUrl( Uri.parse( "http://maps.google.com/maps?daddr=${widget.targetLocation.toString()}" ));
                        },
                        tooltip: widget.appLocalizations.tracking_showOnMap,
                        color: Theme.of(context).colorScheme.primary,
                        icon: const Icon ( Icons.navigation ),
                      ),
                    ),
                  )
                  
                ],
              )
            ]
          ),
      ),
    );
  }

}
