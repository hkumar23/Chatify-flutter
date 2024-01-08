import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String otherUserId;
  const NewMessage(this.otherUserId);
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage="";
  final _controller = TextEditingController();
  
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _controller.dispose();
  //   super.dispose();
  // }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    _controller.clear(); 
    var currentUser=FirebaseAuth.instance.currentUser;
    var userSnapshot= await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();

    List<String> otherUserIds=[widget.otherUserId,currentUser.uid];
    otherUserIds.sort();
    String chatId="${otherUserIds[0]}_"+"${otherUserIds[1]}";
    // print(userSnapshot["username"]);
    FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').add({
      "text":_enteredMessage,
      "createdOn":Timestamp.now(),
      "userId":currentUser.uid,
      "userName":userSnapshot["username"],
      "userImage":userSnapshot["image_url"],
    });
    setState(() {           
      _enteredMessage="";
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

              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
                  icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      padding: EdgeInsets.all(7),
                      // color: Theme.of(context).colorScheme.inversePrimary,
                      child: Icon(
                        Icons.send_rounded,
                        color: Theme.of(context).colorScheme.onSurface,
                        ),
                    ),
                ),
                label: const Text("Send a message..."),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              onChanged: (value){
                setState(() {
                  _enteredMessage=value;                  
                });
              },
              controller: _controller,
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.all(5),
          //   padding: const EdgeInsets.all(5),        
          //   decoration: BoxDecoration(
          //     borderRadius: const BorderRadius.all(Radius.circular(50)),
          //     color: Theme.of(context).colorScheme.inversePrimary),
          //   child: IconButton(
          //     iconSize: 30,
          //     icon: Icon(
          //       Icons.send,
          //       color: Theme.of(context).colorScheme.onSurface,
          //       ),
          //     onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          //     ),
          // ),
        ],
      ),
    );
  }
}