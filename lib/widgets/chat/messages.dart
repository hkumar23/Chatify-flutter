import 'package:chatify2/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  Messages(this.otherUserId);
  final String otherUserId;

  @override
  Widget build(BuildContext context) {
    // var userSnapshot;
    // FirebaseAuth.instance.authStateChanges().listen((User? user){
    //   if(user!=null){
    //     userSnapshot=user;
    //   }
    // });
    var currUserSnapshot=FirebaseAuth.instance.currentUser;
    List<String> userIds=[otherUserId,currUserSnapshot!.uid];
    userIds.sort();
    String chatId="${userIds[0]}_"+"${userIds[1]}";
    // print(userIds);
    // print(chatId);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').orderBy("createdOn",descending: true).snapshots(), 
      builder: (ctx,chatSnapshot){
        if(
          chatSnapshot.connectionState == ConnectionState.waiting ||
          chatSnapshot.data==null
          ){
          return const Center(child: CircularProgressIndicator(),);
        }

        // print(chatSnapshot);
        final chatDocs=chatSnapshot.data!.docs;
        // print(chatDocs);
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx,index){
            return 
            // Text(userSnapshot.uid);
            MessageBubble(
              chatDocs[index]["text"],
              chatDocs[index]["userId"]==currUserSnapshot.uid,
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