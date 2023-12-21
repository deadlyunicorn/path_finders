import 'package:flutter/material.dart';

bool isLandscape( BuildContext context ){


  return MediaQuery.of(context).size.aspectRatio > 1.5 ;


}

bool heightIsSmall( BuildContext context ){

  return MediaQuery.of(context).size.height < 600;

}