import 'package:flutter/material.dart';
import 'package:path_finders/src/profile/location_sharing_widget.dart';
import 'package:path_finders/src/storage_services.dart';

class ProfileView extends StatefulWidget{

  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  bool isSharing = false;
  
  void refreshProfileView(){
    setState(() {
      isSharing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Center( 

      child: FutureBuilder(
            future: UserFile.getUserId(), 
            builder: (context, userIdSnapshot){

              if (  userIdSnapshot.hasData && userIdSnapshot.data != null ){

                final String userId = userIdSnapshot.data!;

                return Column( 
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Your ID is: #${userId.substring(0,3)}-${userId.substring(3)}", 
                          textScaler: const TextScaler.linear(2)
                        ),
                      ],
                    ),
                    const Text( "Toggle Visibility", textScaler: TextScaler.linear(1.5) ),
                    Switch(
                      value: isSharing, 
                      onChanged: ( newValue ){
                        setState(() {
                          isSharing = newValue;
                        });
                      }),
                    LocationSharingWidget(
                      isSharing: isSharing,
                      userId: userId,
                      refresh: refreshProfileView,
                    ),
                  ]
                );
              }
              else{
                
                return Column(
                  children: [
                    const Text(
                      "Session Error.",
                      textScaler: TextScaler.linear( 1.1 ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: (){
                        setState((){

                        });
                      }, 
                      child: const Text("Retry")
                    ),
                  ],
                ) ;
              }
              
            }
          )
    );
  }
}