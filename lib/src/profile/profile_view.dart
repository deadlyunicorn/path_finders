import 'package:flutter/material.dart';
import 'package:path_finders/src/copying_service.dart';
import 'package:path_finders/src/custom/styles.dart';
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

          if ( userIdSnapshot.connectionState == ConnectionState.done ){


            final userIdSnapshotData = userIdSnapshot.data;

            if (  userIdSnapshot.hasData && userIdSnapshotData != null ){

                final String userId = userIdSnapshotData;

                return Column( 
                  children: [
                    TextButton(
                      style: const ButtonStyle( 
                        shape: MaterialStatePropertyAll( 
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all( Radius.circular( 4 ) )
                          )
                        )
                       ),
                      onPressed: (){},
                      onLongPress: (){
                        CopyService.copyTextToClipboard( userId, context: context);
                      },
                      child: Text(
                        "Your ID is: #${userId.substring(0,3)}-${userId.substring(3)}",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith( color: Theme.of(context).colorScheme.onBackground )
                      ), 
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
                                width: 24,
                              ),
                            ]
                          ),
                          SizedBox(
                            height: 72,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                value: isSharing, 
                                onChanged: ( wantsToShareLocation )async{

                                  if ( wantsToShareLocation ){
                                    if ( await DisclaimerAcceptionFile.disclaimerIsAccepted() ){
                                      setState(() {
                                          isSharing = wantsToShareLocation;
                                        });
                                    }
                                    else{
                                      await showDisclaimerDialog(context);
                                      if ( await DisclaimerAcceptionFile.disclaimerIsAccepted() ){
                                        setState(() {
                                          isSharing = wantsToShareLocation;
                                        });
                                      }

                                    }
                                  }
                                  else{
                                    setState(() {
                                      isSharing = wantsToShareLocation;
                                    });
                                  }

                                    
                                  
                                }
                              ),
                            ) 
                          ),
                          SizedBox(
                            height: 64,
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
            else if ( userIdSnapshot.hasError ){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${userIdSnapshot.error}",
                    textScaler: const TextScaler.linear( 1.1 ),
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

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              const CircularProgressIndicator(),
              FutureBuilder(
                future: Future.delayed( const Duration( seconds: 4) ), 
                builder: ( context, delaySnapshot ){

                  if ( delaySnapshot.connectionState == ConnectionState.done ){
                    return const Positioned(
                      bottom: -75,
                      child: Text( 
                        "This is taking a while..\n"
                        "Are you connected to the internet?",
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return const SizedBox.shrink();

                  
                } 
              )
              

            ],
          );
        }
      )
    );
  }
}

showDisclaimerDialog( BuildContext context ){

  return showDialog(
    context: context, 
    builder: ( context )=> Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular( 4 )
      ),
      child: Padding(
        padding: const EdgeInsets.all( 8.0 ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon( Icons.warning, color: Colors.yellow),
              SizedBox.square( dimension: 12 ),
              Text( "Disclaimer", 
                style: Theme.of(context).textTheme.headlineSmall,
                ),
              SizedBox.square( dimension: 12 ),
              Icon( Icons.warning, color: Colors.yellow),
              ],
            ),
            SizedBox.square( dimension: 12 ),
            const Text(
              "You are about to share your location to the internet.\n"
              "Anyone will be able to see your coordinates, alongside your in-app ID.\n"
              "\nPlease proceed with caution - and only if you know what the above means.",
              textAlign: TextAlign.center),
            
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                  style: squaredButtonStyle,
                  child: Text("Nevermind", style: TextStyle( color: Theme.of(context).colorScheme.error ),)
                ),
                TextButton(
                  style: squaredButtonStyle,
                  onPressed: ()async{
                    await DisclaimerAcceptionFile.acceptDisclaimer();
                    Navigator.pop(context);
                  }, 
                  child: Text("Proceed")
                )

              ],
            )
            


          ],
        ) 
      )
    )
  );

}