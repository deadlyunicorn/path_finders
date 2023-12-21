import 'package:flutter/material.dart';

bool isLandscape( BuildContext context ){
  return MediaQuery.of(context).size.aspectRatio > 1.5 ;
}