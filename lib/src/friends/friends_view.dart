import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_finders/src/friends/friends_view_components/friend_entries_view.dart';
import 'package:path_finders/src/friends/friends_view_components/sample_entries_view.dart';
import 'package:path_finders/src/friends/id_formatter.dart';
import 'package:path_finders/src/providers/target_listings_provider.dart';
import 'package:path_finders/src/providers/target_provider.dart';
import 'package:path_finders/src/types/coordinates.dart';
import 'package:provider/provider.dart';


class FriendsView extends StatefulWidget {

  const FriendsView( {super.key });

  @override
  State<FriendsView> createState() => _FriendsViewState();
}

class _FriendsViewState extends State<FriendsView> {

  final Map<String, Coordinates> sampleData = {
    "China"  :  Coordinates( 31.2183202, 120.2284013),
    "Mexico" :  Coordinates( 19.3904678, -99.455446 ),
    "Finland":  Coordinates( 65.0679042, 25.58678   ),
    "South Africa" : Coordinates( -33.925108, 18.5315826 )
  };

  String friendToAdd = "";

  @override
  Widget build(BuildContext context) {

    return (
      Column(
        children: [
          Text("Currently ${context.watch<TargetProvider>().targetName} is selected."),
          SampleEntriesView( listItems: sampleData ),
          const FriendEntriesView(),
          Consumer<TargetListingsProvider>(
            builder: (context, listingsProvider, child) 
            =>Expanded(
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
                          }, child: const Text("Cancel")),
                          TextButton(
                              onPressed: (){
                                friendToAdd.length < 5 ? null 
                                : ((){
                                  print( listingsProvider.targetEntries );
                                  listingsProvider.addTargetEntry(friendToAdd);
                                  Navigator.pop(context, "Submit");
                                  
                                })();
                              }, 
                              child: const Text("Submit")
                          )
                        ],
                      )
                    )
                  )
                ]
              )
            )
          ),
          const Text("Your ID is: ######"),
          const Text("Toggle Visibility"),
          const Text("Regenerate ID"),
        ],
      )
    );
  }
}
