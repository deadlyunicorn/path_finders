
import 'package:flutter/material.dart';

class LoadingLocationView extends StatelessWidget{

  LoadingLocationView( {super.key} );
   @override
  Widget build(BuildContext context) {
    return(
      Center(child: CircularProgressIndicator())
    );
  }
}