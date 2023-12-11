
import 'package:flutter/material.dart';

var squaredButtonStyle =  ButtonStyle( 
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)
                              )
                            )
                          );