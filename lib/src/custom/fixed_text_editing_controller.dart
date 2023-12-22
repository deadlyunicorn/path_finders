import 'package:flutter/material.dart';

class FixedTextEditingController extends TextEditingController{

  FixedTextEditingController( { text } ){
    this.text = text;
    selection =  TextSelection.collapsed(offset: text.length);
  }


}
