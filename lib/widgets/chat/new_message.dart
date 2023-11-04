import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage(this.userId);
  final String userId;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage="";
  final _controller = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    setState(() {      
      _controller.clear();
    });
    var currentUser=FirebaseAuth.instance.currentUser;
    var userSnapshot= await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();

    List<String> userIds=[widget.userId,currentUser.uid];
    userIds.sort();
    String chatId="${userIds[0]}_"+"${userIds[1]}";
    // print(userSnapshot["username"]);
    FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
      "text":_enteredMessage,
      "createdOn":Timestamp.now(),
      "userId":currentUser.uid,
      "userName":userSnapshot["username"],
      "userImage":userSnapshot["image_url"],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                label: Text("Send a message..."),
                border: OutlineInputBorder(),
              ),
              onChanged: (value){
                setState(() {
                  _enteredMessage=value;                  
                });
              },
              controller: _controller,
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(7),        
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              color: Theme.of(context).colorScheme.primary),
            child: IconButton(
              iconSize: 30,
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.onPrimary,
                ),
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              ),
          ),
        ],
      ),
    );
  }
}