import 'dart:math';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:path_finders/src/custom/fixed_text_editing_controller.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/friends/friends_view_components/entry_insertion_views/deletion_prompt.dart';
import 'package:path_finders/src/friends/friends_view_components/entry_insertion_views/dialog_actions.dart';

import 'package:path_finders/src/providers/targets_with_coordinates_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';

class StaticEntryDialog extends StatefulWidget{

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
  State<StaticEntryDialog> createState() => _StaticEntryDialogState();
}

class _StaticEntryDialogState extends State<StaticEntryDialog> {

  String errorMessage = "";
  String targetName   = "easter egg";
  double latitude  = 0.314; //user is unlikely to type this value - so it won't be replace by widget default when sb types 0
  double longitude = 0.314;


  @override
  Widget build(BuildContext context) {

    final appLocalizations = AppLocalizations.of(context);


    if ( targetName == "easter egg" ){
      targetName = widget._targetName ?? "";
    }
    if ( latitude == 0.314 ){
      latitude = widget._coordinates?.latitude ?? 0.0000 ;
    }
    if ( longitude == 0.314 ){
      longitude = widget._coordinates?.longitude ?? 0.0000 ;
    }


    final targetListingsWithCoordinates = widget.staticListingsProvider;

    return AlertDialog(
      title: Text( appLocalizations!.entry_static_insertion ),

      content: SizedBox(
        width: min(MediaQuery.of(context).size.width - 100, 500) ,
        child: SingleChildScrollView(
          child: Column( 
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller:  ( targetName == widget._targetName ) 
                ? FixedTextEditingController( 
                  text: targetName,
                ) : null,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  setState((){
                    targetName = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: appLocalizations.entry_friendlyName,
                  hintText: appLocalizations.entry_friendlyNameHint,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              TextField(
                controller: ( latitude == widget._coordinates?.latitude || latitude == 0 )
                  ?FixedTextEditingController(
                    text: latitude.toString()
                  ):null,
                keyboardType: TextInputType.number,
                onChanged: (value){
                  final tempValue = double.tryParse( value );
                  if ( tempValue != null ) {
                    setState((){
                      latitude = tempValue;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: appLocalizations.latitude,
                  hintText: appLocalizations.latitudeHint,
                ),

              ),

              const SizedBox(
                height: 20,
              ),

              TextField(
                controller: ( longitude == widget._coordinates?.longitude || longitude == 0 )
                  ?FixedTextEditingController(
                    text: longitude.toString()
                  ):null,
                keyboardType: TextInputType.number,
                onChanged: (value){

                  final tempValue = double.tryParse( value );
                  if ( tempValue != null ) {
                    setState((){
                      longitude = tempValue;
                    });
                  }

                },
                decoration: InputDecoration(
                  labelText: appLocalizations.longitude,
                  hintText: appLocalizations.longitudeHint,
                ),
                
              ),
              const SizedBox( height:8 ),
              Text( 
                errorMessage,
                style: TextStyle( color: Theme.of(context).colorScheme.error ),
                textAlign: TextAlign.center,
              )

            ]
          ),
        ) ,
      ), 
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: dialogActions(
        context: context,
        submissionHandler: ()async{
          final tempErrorMessage = await submitChangesOrReturnErrorMessage( 
            latitude: latitude,
            longitude: longitude,
            targetName: targetName,
            initialTargetName: widget._targetName,
            context: context,
            targetListingsWithCoordinates: targetListingsWithCoordinates
          );
          if ( tempErrorMessage.isNotEmpty ){
            setState(() {
              errorMessage = tempErrorMessage;
            });
          }
        }, 
        cancellationHandler:  (){
          Navigator.pop(context,"Cancel");
        },
        deletionHandler: widget._targetName != null ?(){
            showDeletionConfirmationDialog(context, targetListingsWithCoordinates, widget._targetName);
        }:null

      )
    );

  }
}

Future<String> submitChangesOrReturnErrorMessage(  
  { 
    required double? longitude, 
    required double? latitude, 
    required String? targetName,
    required String? initialTargetName,
    required TargetWithCoordinatesListingsProvider targetListingsWithCoordinates,
    required BuildContext context
  } ) async{

      String errorMessage = "";
      final appLocalizations = AppLocalizations.of(context)!;


      if ( targetName == null || targetName.isEmpty ){

        errorMessage = appLocalizations.errors_invalidTargetName;

      }
      else if ( latitude == null || latitude > 90 || latitude < -90  ){

        errorMessage = appLocalizations.errors_invalidLatitude;

      }
      else if( longitude == null || longitude > 180 || longitude < - 180 ){

        errorMessage = appLocalizations.errors_invalidLongitude;

      }
      else{
        if ( initialTargetName != null ){
          await targetListingsWithCoordinates.remove( initialTargetName );
        }
        await targetListingsWithCoordinates.remove(targetName);
        await targetListingsWithCoordinates.add( targetName, Coordinates( latitude, longitude) );
        if ( context.mounted ){
          Navigator.pop(context, "Submit");
        } 
        return errorMessage;
      }

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger
      .of( context )
      .showSnackBar(
        CustomSnackBar(
          duration: const Duration( seconds: 2),
          bgColor: Theme.of(context).colorScheme.error.withAlpha( 220 ),
          textContent: errorMessage,
          textStyle: TextStyle( color: Theme.of(context).colorScheme.onError ),
          context: context
        )
      );

      return errorMessage;
}
