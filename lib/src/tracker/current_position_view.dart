import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_finders/src/custom/copying_service.dart';
import 'package:path_finders/src/types/coordinates.dart';

class CurrentPositionView extends StatelessWidget {
  const CurrentPositionView({
    super.key,
    required this.appLocalizations,
    required this.currentLocation,
  });

  final AppLocalizations appLocalizations;
  final Coordinates currentLocation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
    
         Text(
            appLocalizations.tracking_currentPositionIs
          ),
          TextButton(
            style: const ButtonStyle(
              shape: MaterialStatePropertyAll( 
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all( Radius.circular( 4 ) )
                )
              )
            ),
            onPressed: (){},
            onLongPress: ()async{
              await CopyService.copyTextToClipboard( 
                context: context,
                "${ currentLocation.latitude.toStringAsFixed(7)}, ${ currentLocation.longitude.toStringAsFixed(7) }" 
              );
            }, 
            child: Text(  
            "${ currentLocation.latitude.toStringAsFixed(7)}, ${ currentLocation.longitude.toStringAsFixed(7) }",
            textScaler: const TextScaler.linear( 1.5 ),
            textAlign: TextAlign.center,
            )
          )
    
      ],
    );
  }
}