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
                        Text("Your ID is: $userId", 
                          textScaler: 2
                        ),
                        IconButton( 
                          icon: const Icon(Icons.refresh), 
                          tooltip: "Regenerate ID",
                          onPressed: (){
                            print("hello world");
                          }
                        ),
                      ],
                    ),
                    const Text( "Toggle Visibility", textScaler: 1.5 ),
                    Switch(
                      value: isSharing, 
                      onChanged: ( newValue ){
                        setState(() {
                          isSharing = newValue;
                        });
                      }),
                    LocationSharingWidget(
                      isSharing: isSharing,
                      userId: userId 
                    ),
                  ]
                );
              }
              else{
                return const Text(
                  "Your ID is missing. Are you connected to the internet?",
                  textScaler: 2
                );
              }
              
            }
          )
    );
  }
}