import 'package:flutter/material.dart';

class BugReportDialog extends StatelessWidget {

  
  @override
  Widget build(BuildContext context) {
    
    return AlertDialog(
                        title: Text( "Bug Report Locale Need" ),
                        actions: [
                          Row( 
                                      children: [
                                        TextButton(
                                          onPressed: (){},
                                          child: Text("Cancel") 
                                        ),
                                        TextButton(
                                          onPressed: (){},
                                          child: Text("Submit") 
                                        )
                                      ]
                                    )
                        ],
                        content:
                          SingleChildScrollView(
                            child:Padding(
                              padding: EdgeInsets.all( 8 ),
                              child:  Column(
                                  children: [
                                    Text( "Problem Summary"),
                                    TextField(),
                                    Text( "Detailed Description"),
                                    TextField( maxLines: 14,)
                                  ],
                                ),
                            )
                          )
                      );
  }
}