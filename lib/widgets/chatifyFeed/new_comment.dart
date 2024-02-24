import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/misc/app_language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewComment extends StatefulWidget {
  const NewComment({super.key, required this.postId});
  final String postId;
  @override
  State<NewComment> createState() => _NewCommentState();
}

class _NewCommentState extends State<NewComment> {
  String? _enteredMessage = "";
  final currUserId = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController _controller = TextEditingController();

  Future<void> _sendMessage() async {
    FocusScope.of(context).unfocus();
    _controller.clear();

    final commentsRef = FirebaseFirestore.instance
        .collection(AppConstants.posts)
        .doc(widget.postId)
        .collection(AppConstants.comments);
    await commentsRef.add({
      AppConstants.text: _enteredMessage,
      AppConstants.timestamp: Timestamp.now(),
      AppConstants.userId: currUserId,
    });
    setState(() {
      _enteredMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      // margin: const EdgeInsets.only(top: 8),
      // padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: _enteredMessage!.isEmpty ? null : _sendMessage,
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
                label: const Text(AppLanguage.addAComment),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value.trim();
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
