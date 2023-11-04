import 'package:chatify2/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chatify2/widgets/contact_item.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  HomeScreen(
    this.themeBrightness,
    this.toggleTheme,
    );
  final Brightness themeBrightness;
  final void Function() toggleTheme;

  @override
  Widget build(BuildContext context) {
    // void navigateToChat(){

    // }
    var currenUser=FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Chatify",
          style: Theme.of(context).primaryTextTheme.headlineSmall!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          )
          ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.onPrimary,
                ),
              items: [
              DropdownMenuItem(
                value: "logout",
                  child: 
                  Row(
                    children: [
                    Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                    const SizedBox(width: 8),
                    const Text("Logout"),
                  ]
                  ),
                ),
              ],
              onChanged: (itemIdentifier){
                if(itemIdentifier=="logout"){
                  FirebaseAuth.instance.signOut();
                }
              },
              ),
          ),
          IconButton(
            onPressed: toggleTheme, 
            icon: Icon(
              themeBrightness==Brightness.dark ?
               Icons.dark_mode :
               Icons.light_mode,
               ),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ],  
        ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   "Chats",
            //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
            //     letterSpacing: 2,
            //     fontSize: 16,
            //     color: Theme.of(context).colorScheme.secondary,
            //   ),
            // ),
            // const Divider(),
            Expanded(
              child: 
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (ctx,usersSnap){
                  if(usersSnap.connectionState == ConnectionState.waiting ||
                  usersSnap.data==null){
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  // print(usersSnap.data!.docs.length);  
                  var userData=usersSnap.data!.docs;
                  return ListView.builder(
                      itemCount: userData.length,
                      itemBuilder: (ctx,index){
                        // print(currenUser!.uid);
                        return currenUser!.uid != userData[index].id ?
                        ContactItem(
                          userData[index]["image_url"],
                          userData[index]["username"],
                          userData[index]["email"],
                          (){
                            Navigator.of(context).pushNamed(ChatScreen.routeName,arguments: userData[index].id);
                          },
                        ) 
                        : SizedBox(height: 0,width: 0);                        
                      },
                    );
                },
                )
            ),
          ],
        ),
      ),
    );
  }
}