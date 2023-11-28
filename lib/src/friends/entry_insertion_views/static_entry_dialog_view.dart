
import 'package:flutter/material.dart';
import 'package:path_finders/src/custom/snackbar_custom.dart';

import 'package:path_finders/src/providers/targets_with_coordinates_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';

class StaticEntryDialog extends StatefulWidget{

  final TargetWithCoordinatesListingsProvider staticListingsProvider;

  const StaticEntryDialog({super.key, required this.staticListingsProvider});

  @override
  State<StaticEntryDialog> createState() => _StaticEntryDialogState();
}

class _StaticEntryDialogState extends State<StaticEntryDialog> {

  String _targetName="";
  double? _latitude;
  double? _longitude;

  @override
  Widget build(BuildContext context) {

    final listingsProvider = widget.staticListingsProvider;

    return AlertDialog(
      title: const Text("Enter location coordinates"),

      content: Column( 
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.name,
            onChanged: (value) {
              setState(() {
                _targetName = value;
              });
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
            keyboardType: TextInputType.number,
            onChanged: (value){
              final latitude = double.tryParse(value);
              if ( latitude == null ){
                ScaffoldMessenger
                .of(context)
                .showSnackBar(
                  CustomSnackBar(
                    duration: const Duration( milliseconds: 500),
                    bgColor: Colors.red.shade700.withAlpha( 100 ),
                    textContent: "Invalid latitude (Not a valid number)", 
                    context: context
                  )
                );

              }
              else if (  latitude > 90 || latitude < -90  ){
                ScaffoldMessenger
                .of(context)
                .showSnackBar(
                  CustomSnackBar(
                    duration: const Duration( milliseconds: 500),
                    bgColor: Colors.red.shade700.withAlpha( 100 ),
                    textContent: "Invalid latitude (Not a valid value)", 
                    context: context
                  )
                );
              }
              _latitude = latitude;
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
            keyboardType: TextInputType.number,
            onChanged: (value){

              final longitude = double.tryParse(value);
              if ( longitude == null ){
                ScaffoldMessenger
                .of(context)
                .showSnackBar(
                  CustomSnackBar(
                    duration: const Duration( seconds: 1),
                    bgColor: Colors.red.shade700.withAlpha( 100 ),
                    textContent: "Invalid longitude (Not a valid number)", 
                    context: context
                  )
                );

              }
              else if (  longitude > 180 || longitude < -180  ){
                ScaffoldMessenger
                .of(context)
                .showSnackBar(
                  CustomSnackBar(
                    duration: const Duration( seconds: 1),
                    bgColor: Colors.red.shade700.withAlpha( 100 ),
                    textContent: "Invalid longitude (Not a valid value)", 
                    context: context
                  )
                );
              }
              _longitude = longitude;

              
            },
            decoration: const InputDecoration(
              labelText: "Longitude",
              hintText: "A cool number like 73.141",
            ),
          )

        ]), 
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context,"Cancel");
        }, child: const Text("Cancel")),
        TextButton(
            onPressed: () async{

              final longitude = _longitude;
              final latitude  = _latitude;

              if( _targetName.isNotEmpty 
               && latitude != null
               && longitude != null 
               && ( latitude < 90 && latitude > -90 )
               && ( longitude < 180 && longitude > -180  )){

                (() async{
                
                  await listingsProvider.addTargetWithCoordinatesEntry( _targetName, Coordinates(_latitude!, _longitude!) );
                  if ( context.mounted ){
                    Navigator.pop(context, "Submit");
                  } 
                })();

              }
            }, 
            child: const Text("Submit")
        )
      ],
    );

  }
}