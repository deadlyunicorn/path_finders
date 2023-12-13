import 'package:flutter/material.dart';

List<Widget> dialogActions( 
  {
    void Function()? deletionHandler, 
    required Future<void> Function() submissionHandler,
    required void Function() cancellationHandler
  }  ) => [

        deletionHandler != null 
          ?TextButton(
            onPressed: deletionHandler, 
            child: Text( "Delete" ,style: TextStyle( color: Colors.red) )
          )
          :SizedBox.shrink(),

        Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: cancellationHandler, 
              child: const Text("Cancel")
            ),
       
            TextButton(
                onPressed: submissionHandler,
                child: const Text("Submit")
            )

          ]
        )
    ];