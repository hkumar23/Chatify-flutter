import 'package:chatify2/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // var userSnapshot;
    // FirebaseAuth.instance.authStateChanges().listen((User? user){
    //   if(user!=null){
    //     userSnapshot=user;
    //   }
    // });
    var userSnapshot=FirebaseAuth.instance.currentUser;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').orderBy("createdOn",descending: true).snapshots(), 
      builder: (ctx,chatSnapshot){
        if(
          chatSnapshot.connectionState == ConnectionState.waiting ||
          chatSnapshot==null
          ){
          return const Center(child: CircularProgressIndicator(),);
        }
        final chatDocs=chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx,index){
            return 
            // Text(userSnapshot.uid);
            MessageBubble(
              chatDocs[index]["text"],
              chatDocs[index]["userId"]==userSnapshot!.uid,
              chatDocs[index]["userImage"],
              chatDocs[index]["userName"],
              key: ValueKey(chatDocs[index].id),
              );
          },
        );
      }
      );
  }
}