import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_finders/src/friends/id_formatter.dart';
import 'package:path_finders/src/providers/friend_locator_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:provider/provider.dart';


class FriendsView extends StatefulWidget {

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {
  Map<String, Coordinates> sampleData = {
    "China"  :  Coordinates( 31.2183202, 120.2284013),
    "Mexico" :  Coordinates( 19.3904678, -99.455446 ),
    "Finland":  Coordinates( 65.0679042, 25.58678   ),
    "South Africa" : Coordinates( -33.925108, 18.5315826 )
  };

  List<Widget> sampleDataTiles = [];
  String friendToAdd = "";

  @override
  Widget build(BuildContext context) {

    FriendLocatorProvider appState = context.watch();  

    return (
      Column(
        children: [
          Text("Currently ${appState.friendlyNameOfPoint} is selected."),
          Expanded(
            flex: 3,
            child:
            ListView.builder(
              itemCount:  sampleData.length,
              itemBuilder: (context, index) {
                final key = sampleData.keys.elementAt(index);
                final value = sampleData[key];
                return ListTile(
                  title: Text( key ),
                  onTap: () {
                    appState.setPointOfInterest( value! );
                    appState.setFriendlyNameOfPoint( key );
                  }
                );
              },
            )
          ),
          Expanded(
            child: 
            ListView(
              children: [
                ListTile(
                  title: const Center (child: Text("Add with ID") ),
                  onTap: () => showDialog(
                    context: context, 
                    builder: (context) => AlertDialog(
                      title: const Text("Enter user ID"),
                      content: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          CustomInputFormatter(),
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: (value) {
                          setState(() {
                            friendToAdd = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "ID",
                          hintText: "##-###",
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context,"Cancel");
                        }, child: Text("Cancel")),
                        TextButton(
                          onPressed: (){
                            friendToAdd.length < 5 ? null 
                            : ((){
                              Navigator.pop(context, "Submit");
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  print( friendToAdd );
                                  return const AlertDialog(
                                    content: LinearProgressIndicator(),
                                  );
                                } 
                              );
                            })();
                          }, 
                          child: Text("Submit")
                        ),
                      ],
                    )
                  ),
                )
              ]
            )
          ),
          Text("Enable Scan")
        ],
      )
    );
  }
}
