import 'package:flutter/material.dart';

class CustomSnackBar extends SnackBar { 

  final BuildContext context;
  final String textContent;
  final Color? bgColor;

  CustomSnackBar({ 
    super.key, required this.textContent,
    required this.context,
    this.bgColor,
    Duration duration = const Duration( seconds: 4 ) })
  :super(
    content: Text(
      textContent,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).indicatorColor
      )
    ),
    duration: duration,
    backgroundColor: bgColor ?? Colors.blue.shade700.withAlpha( 100 ),
    behavior: SnackBarBehavior.floating,
  );

}