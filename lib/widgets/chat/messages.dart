import 'package:chatify2/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages(this.otherUserId,this.chatId,this.currentUserId, {super.key});
  final String otherUserId;
  final String chatId;
  final currentUserId;
  @override
  Widget build(BuildContext context) {
    // var userSnapshot;
    // FirebaseAuth.instance.authStateChanges().listen((User? user){
    //   if(user!=null){
    //     userSnapshot=user;
    //   }
    // });
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
            Timestamp chatTimeStamp=chatDocs[index]["createdOn"];
            return 
            // Text(userSnapshot.uid);
            MessageBubble(
              chatDocs[index]["text"],
              chatDocs[index]["userId"]==currentUserId,
              chatDocs[index]["userImage"],
              chatDocs[index]["userName"],
              chatTimeStamp.toDate(),
              key: ValueKey(chatDocs[index].id),
              );
          },
        );
      }
      );
  }
}