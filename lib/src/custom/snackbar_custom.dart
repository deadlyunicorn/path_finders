import 'dart:math';

import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar { 

  final BuildContext context;
  final String textContent;
  final Color? bgColor;
  final TextStyle? textStyle;

  CustomSnackBar({ 
    super.key, required this.textContent,
    required this.context,
    this.bgColor,
    this.textStyle,
    super.elevation,
    super.duration = const Duration( seconds: 4 ) })
  :super(
    content: Text(
      textContent,
      textAlign: TextAlign.center,
      style: textStyle !=null 
        ? textStyle.copyWith( fontWeight: FontWeight.w600 )
        : TextStyle( color: Theme.of(context).colorScheme.onPrimary ).copyWith( fontWeight: FontWeight.w600 )
    ),
    width: max(MediaQuery.sizeOf(context).width/2 , min( MediaQuery.sizeOf(context).width - 50, 500) ) ,
    backgroundColor: bgColor ?? Theme.of(context).colorScheme.primary.withAlpha( 220 ),
    behavior: SnackBarBehavior.floating,
  );

}