import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/widgets/chatifyFeed/comment_item.dart';
import 'package:chatify2/widgets/chatifyFeed/new_comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentsDialogBox extends StatefulWidget {
  const CommentsDialogBox({required this.postId, super.key});
  final String postId;

  @override
  State<CommentsDialogBox> createState() => _CommentsDialogBoxState();
}

class _CommentsDialogBoxState extends State<CommentsDialogBox> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(AppConstants.posts)
          .doc(widget.postId)
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              comments.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Text("No comments yet!"),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom == 0
                          ? 370
                          : 270,
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
                      ),
                    ),
              NewComment(
                postId: widget.postId,
              ),
            ],
          ),
        );
      },
    );
    // print("yes");
  }
}
