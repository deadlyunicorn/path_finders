import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    final appLocalizations = AppLocalizations.of( context );
    
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
                        "${appLocalizations!.profile_yourIdIs} #${userId.substring(0,3)}-${userId.substring(3)}",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith( color: Theme.of(context).colorScheme.onBackground ),
                        textAlign: TextAlign.center,
                      ), 
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                appLocalizations.profile_toggleVis, 
                                textScaler: const TextScaler.linear( 2 )
                                ),
                              const SizedBox( width: 5 ),
                              const Image(
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
                                      if ( !mounted ) return;
                                      showDisclaimerDialog(context);
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
                    child: Text( appLocalizations!.errors_retry )
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
                    return Positioned(
                      bottom: -75,
                      child: Text( 
                        appLocalizations!.errors_locationSharingTimeout,
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

  final appLocalizations = AppLocalizations.of( context );

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
                const Icon( 
                  shadows: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 4,
                    )
                  ],
                  Icons.warning, 
                  color: Colors.yellow,
                ),
                const SizedBox.square( dimension: 12 ),
                Text( "Disclaimer", 
                  style: Theme.of(context).textTheme.headlineSmall,
                  ),
                const SizedBox.square( dimension: 12 ),
                const Icon( 
                  shadows: [
                        BoxShadow(
                          color: Colors.black,
                          blurRadius: 4,
                        )
                      ],
                  Icons.warning, 
                  color: Colors.yellow
                ),
              ],
            ),
            const SizedBox.square( dimension: 12 ),
            Text(
              appLocalizations!.dialog_liveSharing_disclaimer,
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
                  child: Text( appLocalizations.dialog_nevermind, style: TextStyle( color: Theme.of(context).colorScheme.error ),)
                ),
                TextButton(
                  style: squaredButtonStyle,
                  onPressed: ()async{
                    await DisclaimerAcceptionFile.acceptDisclaimer();
                    
                    if ( context.mounted ){
                      Navigator.pop(context);
                    }
                  }, 
                  child: Text( appLocalizations.dialog_confirm )
                )

              ],
            )
            


          ],
        ) 
      )
    )
  );

}