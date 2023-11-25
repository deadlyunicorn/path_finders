
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_finders/src/friends/id_formatter.dart';
import 'package:path_finders/src/providers/target_with_id_listings_provider.dart';

class LiveEntryDialog extends StatefulWidget{

  final TargetWithIdListingsProvider listingsProvider;

  const LiveEntryDialog({super.key, required this.listingsProvider});

  @override
  State<LiveEntryDialog> createState() => _LiveEntryDialogState();
}

class _LiveEntryDialogState extends State<LiveEntryDialog> {

  String targetId="";
  String? targetName;

  @override
  Widget build(BuildContext context) {

    final listingsProvider = widget.listingsProvider;

    return AlertDialog(
      title: const Text("Enter user ID"),

      content: Column( 
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              CustomInputFormatter(),
              LengthLimitingTextInputFormatter(7),
            ],
            onChanged: (value) {
              setState(() {
                targetId = value;
              });
            },
            decoration: const InputDecoration(
              labelText: "ID",
              hintText: "###-###",
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          TextField(
            onChanged: (value){
              targetName = value;

            },
            decoration: const InputDecoration(
              labelText: "Friendly Name",
              hintText: "A fellow lost soul",
            ),

          )
        ]), 
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context,"Cancel");
        }, child: const Text("Cancel")),
        TextButton(
            onPressed: () async{
              targetId.length < 5 ? null 
              : (() async{
                await listingsProvider.addTargetWithIdEntry( targetId, targetName: targetName );
                if ( context.mounted ){
                  Navigator.pop(context, "Submit");
                } 
              })();
            }, 
            child: const Text("Submit")
        )
      ],
    );

  }
}