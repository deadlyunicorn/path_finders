
import 'package:flutter/material.dart';

import 'package:path_finders/src/providers/targets_with_coordinates_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';

class StaticEntryDialog extends StatefulWidget{

  final TargetWithCoordinatesListingsProvider staticListingsProvider;

  const StaticEntryDialog({super.key, required this.staticListingsProvider});

  @override
  State<StaticEntryDialog> createState() => _StaticEntryDialogState();
}

class _StaticEntryDialogState extends State<StaticEntryDialog> {

  String targetName="";
  double? latitude;
  double? longitude;

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
                targetName = value;
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
              latitude = double.tryParse(value) ;
            },
            inputFormatters: [
              // 
            ],
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
              longitude = double.tryParse(value) ;
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
              ( targetName.isNotEmpty 
               && latitude != null
               && longitude != null 
              ) 
              ?(() async{
                await listingsProvider.addTargetWithCoordinatesEntry( targetName, Coordinates(latitude!, longitude!) );
                if ( context.mounted ){
                  Navigator.pop(context, "Submit");
                } 
              })()
              :null;
            }, 
            child: const Text("Submit")
        )
      ],
    );

  }
}