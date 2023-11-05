import 'package:flutter/material.dart';

class LocationNotAllowedView extends StatelessWidget{
  LocationNotAllowedView( { super.key } );
  @override
  Widget build(BuildContext context) {
    return(
      Row(
        children: [
          
          Text("No location access. Retry button.")
        ],
      )
    );
  }
}