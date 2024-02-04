import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages(this.otherUserId, this.chatId, this.currentUserId,
      {super.key});
  final String otherUserId;
  final String chatId;
  final String currentUserId;
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
        stream: FirebaseFirestore.instance
            .collection(AppConstants.chats)
            .doc(chatId)
            .collection(AppConstants.messages)
            .orderBy(AppConstants.createdOn, descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting ||
              chatSnapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // print(chatSnapshot);
          final chatDocs = chatSnapshot.data!.docs;
          // print(chatDocs);
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) {
              Timestamp chatTimeStamp = chatDocs[index][AppConstants.createdOn];
              // Text(userSnapshot.uid);
              return MessageBubble(
                chatDocs[index][AppConstants.text],
                chatDocs[index][AppConstants.userId] == currentUserId,
                chatTimeStamp.toDate(),
                key: ValueKey(chatDocs[index].id),
              );
            },
          );
        });
  }
}
