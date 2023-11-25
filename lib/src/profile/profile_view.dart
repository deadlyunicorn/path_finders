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
                    Text("Your ID is: #${userId.substring(0,3)}-${userId.substring(3)}", 
                      textScaler: const TextScaler.linear(2)
                    ),
                    const SizedBox(
                      child: Text("App logo goes here"),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text( "Toggle Visibility", textScaler: TextScaler.linear( 2 ) ),
                              SizedBox( width: 5 ),
                              Image(
                                image: AssetImage('assets/images/deadlyunicorn.png'),
                                height: 24,
                              ),
                            ]
                          ),
                          SizedBox(
                            height: 72,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                value: isSharing, 
                                onChanged: ( newValue ){
                                  setState(() {
                                    isSharing = newValue;
                                  });
                                }
                              ),
                            ) 
                          ),
                          SizedBox(
                            height: 42,
                            child: Center(
                                child: LocationSharingWidget(
                                  isSharing: isSharing,
                                  userId: userId,
                                  refresh: refreshProfileView,
                              )
                            ) 
                          )
                        ],
                      ),
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