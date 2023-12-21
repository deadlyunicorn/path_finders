import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MissingInputException implements Exception {

  MissingInputException();

  final String _message = "There is an invalid input field";

  static String getLocalizedMessage( BuildContext context ){

    return AppLocalizations.of(context)!.exception_invalidInput;
  
  }

  String get  message  => _message;
  
}

class UknownException implements Exception {

  UknownException();

  final String _message = "There is an uknown error";

  static String getLocalizedMessage( BuildContext context ){

    return AppLocalizations.of(context)!.exception_invalidInput;
  
  }

  String get  message  => _message;
  
}