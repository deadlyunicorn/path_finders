import 'package:flutter/material.dart';
import 'package:path_finders/src/storage_services.dart';

class UsingTheAppDialog extends StatefulWidget{

  static const List<String> _descriptions = [
    "View the compass at the 'Target' menu. \nThe app has two compass modes. \nThe default one works like a normal compass.",
    "The second one keeps the magnet stable, thus the magnet points towards the moving elements of the compass. \nTap on the magnet to toggle modes.",
    "Add Static ( using coordinates ) \nor Live entries to track, on the 'Friends' menu. \n( 'Live' requires internet connection )",
    "Share your location on the 'Profile' menu. ( requires an internet connection )"
  ];


  static List<String> _imageSources = [
    "assets/images/intro/compass_1.jpg",
    "assets/images/intro/compass_2.jpg",
    "assets/images/intro/entries.jpg",
    "assets/images/intro/profile.jpg",
  ];



  @override
  State<UsingTheAppDialog> createState() => _UsingTheAppDialogState();
}

class _UsingTheAppDialogState extends State<UsingTheAppDialog> {

  int i = 0;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
          title: Text( "Using the App"),
          children: [

            Image.asset(
              UsingTheAppDialog._imageSources[i],
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height/2,
            ),
            Padding(  
              padding: EdgeInsets.all( 8 ),
              child: Container(
                alignment: Alignment.center,
                height: 128,
                child: Text(
                  "${ UsingTheAppDialog._descriptions[i] }",
                  textAlign: TextAlign.center,
                )
              ) 
            ),
            Flex( //BUTTONS
              direction: Axis.horizontal,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Expanded(
                  child: ( i > 0 ) 
                  ? Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: (){
                          setState(() {
                            i--;
                          });
                        },
                        icon: Icon(Icons.arrow_back)
                      )
                    ],) 
                  : SizedBox.shrink()
                ),
                Expanded(
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ( i < UsingTheAppDialog._descriptions.length - 1  ) 
                        ?IconButton(
                          onPressed: (){
                            setState(() {
                              i++;
                            });
                          }, 
                          icon: Icon(Icons.arrow_forward)
                        )
                        :TextButton(
                          onPressed: ()async{
                            await IntroFinishFile.finishIntro();
                            Navigator.pop(context);
                          }, 
                          child: Text( "Let's go!" )
                        )
                    ],
                  ) 
                )
              ],  
            )
            
          ],
        );
  }
}