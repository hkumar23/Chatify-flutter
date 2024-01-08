import 'package:chatify2/screens/contact_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chatify2/widgets/chat/new_message.dart';
import 'package:chatify2/widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  static const routeName='/chat-screen';
  // ChatScreen(
  //   this.themeBrightness,
  //   this.toggleTheme,
  //   );
  // final Brightness themeBrightness;
  // final Function() toggleTheme;

  @override
  Widget build(BuildContext context) {
    var otherUserData=ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    // print(otherUserData['userId']);
    // print(otherUserId);
    return Scaffold(
      appBar: AppBar(
        // leading: null,
        automaticallyImplyLeading: false,
        // IconButton(
        //   onPressed: ()=> Navigator.of(context).pop(),
        //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
        // ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(ContactProfileScreen.routeName,arguments: otherUserData['userId']),
          child: Container(
            // width: 200,
            color: Colors.transparent,
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              children:[ 
                CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      otherUserData["userImage"],
                      ),
                  ),
                const SizedBox(width: 11,),           
                Text(
                      otherUserData["username"],
                      style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      )
                    ),
                ]
            ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: (){},
        //     icon: Icon(
        //         Icons.light_mode,
        //         color: Theme.of(context).colorScheme.onSurface,
        //        ),
        //   ),
        // ],  
        ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            Expanded(child: Messages(otherUserData['userId'])),
            NewMessage(otherUserData['userId']),
          ],
        ),
      ),
    );
  }
}
