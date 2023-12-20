import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/friends/entry_insertion_views/deletion_prompt.dart';
import 'package:path_finders/src/friends/entry_insertion_views/dialog_actions.dart';

import 'package:path_finders/src/providers/targets_with_coordinates_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';

class StaticEntryDialog extends StatelessWidget{

  final TargetWithCoordinatesListingsProvider staticListingsProvider;

  final Coordinates? _coordinates;
  final String? _targetName;

  const StaticEntryDialog(
    { 
      super.key,
      required this.staticListingsProvider,
      String? targetName,
      Coordinates? coordinates
    }
  ) : _targetName = targetName, _coordinates = coordinates;

  

  @override
  Widget build(BuildContext context) {

    String? targetName = _targetName;
    double? latitude;
    double? longitude;

    if ( _coordinates != null ){

      latitude = _coordinates.latitude;
      longitude = _coordinates.longitude;

    }

    final targetListingsWithCoordinates = staticListingsProvider;

    return AlertDialog(
      title: const Text("Enter location coordinates"),

      content: Container(
        width: MediaQuery.of(context).size.width - 100,
        child: SingleChildScrollView(
          child: Column( 
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: TextEditingController( text: targetName),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                    targetName = value;
                },
                decoration: const InputDecoration(
                  labelText: "Friendly Name",
                  hintText: "A wonderful location",
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              TextField(
                controller: TextEditingController(
                  text: latitude?.toString()
                ),
                keyboardType: TextInputType.number,
                onChanged: (value){

                    latitude = double.tryParse(value);
                
                },
                decoration: const InputDecoration(
                  labelText: "Latitude",
                  hintText: "A cool number like 11.04124",
                ),

              ),

              const SizedBox(
                height: 20,
              ),

              TextField(
                controller: TextEditingController(
                  text: longitude?.toString()
                ),
                keyboardType: TextInputType.number,
                onChanged: (value){

                  longitude = double.tryParse(value);

                },
                decoration: const InputDecoration(
                  labelText: "Longitude",
                  hintText: "A cool number like 73.141",
                ),
                
              )

            ]
          ),
        ) ,
      ), 
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: dialogActions(
        submissionHandler: ()async{
          await submissionHandler( 
            latitude: latitude,
            longitude: longitude,
            targetName: targetName,
            initialTargetName: _targetName,
            context: context,
            targetListingsWithCoordinates: targetListingsWithCoordinates
          );
        }, 
        cancellationHandler:  (){
          Navigator.pop(context,"Cancel");
        },
        deletionHandler: (){
            showDeletionConfirmationDialog(context, targetListingsWithCoordinates, _targetName);
        }

      )
    );

  }
}

Future<void> submissionHandler(  
  { 
    required double? longitude, 
    required double? latitude, 
    required String? targetName,
    required String? initialTargetName,
    required TargetWithCoordinatesListingsProvider targetListingsWithCoordinates,
    required BuildContext context
  } ) async{

              if( 
              targetName != null && targetName.isNotEmpty
               && latitude != null
               && longitude != null 
               && ( latitude < 90 && latitude > -90 )
               && ( longitude < 180 && longitude > -180  )){


                (() async{
                  

                  if ( initialTargetName != null ){
                    await targetListingsWithCoordinates.remove( initialTargetName );
                  }
                  await targetListingsWithCoordinates.remove(targetName);
                  await targetListingsWithCoordinates.add( targetName, Coordinates( latitude, longitude) );
                  if ( context.mounted ){
                    Navigator.pop(context, "Submit");
                  } 
                })();

              }

              else{
                ScaffoldMessenger
                .of( context )
                .showSnackBar(
                  CustomSnackBar(
                    duration: const Duration( seconds: 2),
                    bgColor: Theme.of(context).colorScheme.error.withAlpha( 220 ),
                    textContent: AppLocalizations.of(context)!.snackbar_invalidData,
                    context: context
                  )
                );
              }
            }
