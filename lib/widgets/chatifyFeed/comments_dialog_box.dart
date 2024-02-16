import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/widgets/chatifyFeed/comment_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentsDialogBox extends StatelessWidget {
  const CommentsDialogBox({required this.postId, super.key});
  final String postId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(AppConstants.posts)
          .doc(postId)
          .collection(AppConstants.comments)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final comments = snapshot.data!.docs;
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          insetPadding: const EdgeInsets.symmetric(horizontal: 15),
          title: Text(
            textAlign: TextAlign.center,
            "Comments",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          content: comments.isEmpty
              ? const SizedBox(
                  child: Text("No comments yet!"),
                )
              : SizedBox(
                  height: 350,
                  width: double.maxFinite,
                  child: ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      // final comments = snapshot.data!.docs;
                      // print(comments[0][AppConstants.text]);
                      return CommentItem(
                        userId: comments[index][AppConstants.userId],
                        text: comments[index][AppConstants.text],
                        dateTime: (comments[index][AppConstants.timestamp]
                                as Timestamp)
                            .toDate(),
                      );
                    },
                  )),
        );
      },
    );
    // print("yes");
  }
}
