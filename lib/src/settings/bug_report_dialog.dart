import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:http/http.dart' as http;
import 'package:path_finders/src/custom/snackbar_custom.dart';
import 'package:path_finders/src/custom/styles.dart';
import 'package:path_finders/src/types/exceptions.dart';

class BugReportDialog extends StatefulWidget {

  const BugReportDialog( { super.key });

  @override
  State<BugReportDialog> createState() => _BugReportDialogState();
}

class _BugReportDialogState extends State<BugReportDialog> {

  String? errorMessage;
  String bugSummary = "";
  String bugDescription = "";


  @override
  Widget build(BuildContext context) {

    final appLocalizations = AppLocalizations.of( context );

    
    return AlertDialog(
        title: Text( appLocalizations!.bugReport ),
        actions: [

          Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: squaredButtonStyle,
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text( appLocalizations.dialog_nevermind ) 
              ),
              TextButton(
                style: squaredButtonStyle,
                onPressed: ()async{

                  try{

                      if ( bugSummary.isNotEmpty && bugDescription.isNotEmpty ){

                      await http.post( 
                        Uri.parse( "https://path-finders-backend.vercel.app/api/bugReport"),
                        headers: {
                          "Content-type" : "application/json"
                        },
                        body: jsonEncode({
                          "bugSummary"    : bugSummary,
                          "bugDescription": bugDescription
                        })
                      );
                      
                      if ( context.mounted ){
                        
                        Navigator.pop( context );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger
                        .of( context )
                        .showSnackBar(
                          CustomSnackBar(
                            duration: const Duration( seconds: 2),
                            bgColor: Theme.of(context).colorScheme.primary.withAlpha( 220 ),
                            textContent: AppLocalizations.of(context)!.bugSent,
                            textStyle: TextStyle( color: Theme.of(context).colorScheme.onPrimary ),
                            context: context
                          )
                        );
                      } 


                    }else{
                      throw( MissingInputException );
                    }

                  }catch( error ){
                    
                    if ( !context.mounted) return ;
                    String message = UknownException.getLocalizedMessage(context);
                    
                    if ( error is SocketException ){  
                      message = appLocalizations.exception_networkError;
                    }
                    else if( error == MissingInputException ){
                      message = MissingInputException.getLocalizedMessage(context);
                    }

                    setState(() {
                        errorMessage = message;
                      }); 

                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context)
                      .showSnackBar( 
                        CustomSnackBar(
                          duration: const Duration( seconds:  2),
                          bgColor: Theme.of(context).colorScheme.error.withAlpha(220),
                          textStyle: TextStyle( color: Theme.of(context).colorScheme.onError ),
                          textContent: message,
                          context: context)
                      );

                  }
                  
                  // final responseBody = json.decode(res.body);
                  
                },
                child: Text( appLocalizations.dialog_confirm ) 
              )
            ]
          )
        ],
        content:
          SingleChildScrollView(
            child:Padding(
              padding: const EdgeInsets.all( 8 ),
              child:  Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text( appLocalizations.bug_summary ),
                    const SizedBox( height:  16),
                    TextField(
                      onChanged: (value) {

                        setState((){
                          bugSummary = value;
                        });
                      },
                    ),
                    const SizedBox( height:  16),
                    Text(appLocalizations.bug_description),
                    TextField( 
                      minLines: 2,
                      maxLines: 14,
                      onChanged: (value) {

                        setState(() {
                          bugDescription = value;
                        });
                      },
                    ),
                    const SizedBox( height: 8 ),
                    Text(
                      errorMessage??"",
                      textAlign: TextAlign.center,
                      style: TextStyle( color: Theme.of(context).colorScheme.error ),
                    )
                  ],
                ),
            )
          )
   
    );
  }
}