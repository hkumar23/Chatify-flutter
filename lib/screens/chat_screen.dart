import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chatify2/widgets/chat/new_message.dart';
import 'package:chatify2/widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Chatify",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: Colors.white,
            ),
          ),
        actions: [
          DropdownButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
              ),
            items: const [
            DropdownMenuItem(
              value: "logout",
                child: 
                // Icon(Icons.logout),
                Row(
                  children: [
                  Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text("Logout"),
                ]
                ),
              ),
            ],
            onChanged: (itemIdentifier){
              if(itemIdentifier=="logout"){
                FirebaseAuth.instance.signOut();
              }
            },
            )
        ],
        ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            Expanded(child: Messages()),
            const NewMessage(),
          ],
        ),
      ),
    );
  }
}
