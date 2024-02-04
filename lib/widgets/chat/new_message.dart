import 'package:chatify2/misc/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  final String chatId;
  const NewMessage(this.chatId, {super.key});
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = "";
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
    var currentUser = FirebaseAuth.instance.currentUser;
    var userSnapshot = await FirebaseFirestore.instance
        .collection(AppConstants.users)
        .doc(currentUser!.uid)
        .get();

    FirebaseFirestore.instance
        .collection(AppConstants.chats)
        .doc(widget.chatId)
        .collection(AppConstants.messages)
        .add({
      AppConstants.text: _enteredMessage,
      AppConstants.createdOn: Timestamp.now(),
      AppConstants.userId: currentUser.uid,
      AppConstants.fName: userSnapshot[AppConstants.fName],
      AppConstants.lName: userSnapshot[AppConstants.lName],
    });
    setState(() {
      _enteredMessage = "";
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
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendMessage,
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    padding: const EdgeInsets.all(7),
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
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
              controller: _controller,
            ),
          ),
        ],
      ),
    );
  }
}
