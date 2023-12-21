import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class BugReportDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    String problemSummary = "";
    String problemDescription = "";

    final appLocalizations = AppLocalizations.of( context );
    
    return AlertDialog(
                        title: Text( appLocalizations!.bugReport ),
                        actions: [

                          Row( 
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: (){},
                                          child: Text( appLocalizations.dialog_nevermind ) 
                                        ),
                                        TextButton(
                                          onPressed: (){
                                            // print( problemSummary );
                                            // print( problemDescription );
                                            
                                          },
                                          child: Text( appLocalizations.dialog_confirm ) 
                                        )
                                      ]
                                    )
                        ],
                        content:
                          SingleChildScrollView(
                            child:Padding(
                              padding: EdgeInsets.all( 8 ),
                              child:  Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text( appLocalizations.bug_summary ),
                                    SizedBox( height:  16),
                                    TextField(
                                      onChanged: (value) {
                                        problemSummary = value;
                                      },
                                    ),
                                    SizedBox( height:  16),
                                    Text(appLocalizations.bug_description),
                                    TextField( 
                                      minLines: 2,
                                      maxLines: 14,
                                      onChanged: (value) {
                                        problemDescription = value;
                                      },
                                    )
                                  ],
                                ),
                            )
                          )
                      );
  }
}