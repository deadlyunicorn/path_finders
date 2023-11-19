import 'package:flutter/services.dart';

class CustomInputFormatter extends TextInputFormatter{

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    
    int indexOfDash = newValue.text.indexOf('-');

    if ( 
      ( RegExp(r'^[0-9\-]+$').hasMatch( newValue.text ) || newValue.text.isEmpty )
      && ( indexOfDash == 3 || indexOfDash == -1 ) 
      && newValue.text.lastIndexOf('-') <= 3
    ){

      if ( newValue.text.length >= 4 && indexOfDash == -1 ){

        return TextEditingValue(
          // ignore: prefer_interpolation_to_compose_strings
          text: newValue.text.substring( 0, 3 ) + "-" + newValue.text.substring( 3 )
        );
      }

      return newValue;
      
    }
    return oldValue;
  }
}