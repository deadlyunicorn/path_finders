import 'package:flutter/widgets.dart';
import 'package:path_finders/src/profile/user_registration_service.dart';

class ProfileView extends StatelessWidget{

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {

    
    
    return Center( 
      child: Column( 
        children: [
          const Text("Your ID is: ######"),
          const Text("Toggle Visibility"),
          const Text("Regenerate ID"),

          Text( "User profile will be in here "),
          FutureBuilder(
            future: AppVault().showKeys(), 
            builder: (context, snapshot){
              print("hello world!  ${ DateTime.now().toString().toString()}" );

              return snapshot.hasData
              ? Text( snapshot.data! )
              : Text( "error" );
            }
              ,
          ),
        ]
      )
    );
  }
}