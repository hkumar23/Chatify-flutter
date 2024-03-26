import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/utils/app_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    required this.userId,
    required this.text,
    required this.dateTime,
    super.key,
  });
  final String userId;
  final String text;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    String messageTime = AppMethods.calcTimeDiff(dateTime);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(AppConstants.users)
          .doc(userId)
          .snapshots(),
      builder: (context, userSnap) {
        // print(userId);
        if (userSnap.connectionState == ConnectionState.waiting ||
            !userSnap.hasData) {
          return const SizedBox();
        }
        final userData = userSnap.data!.data();
        return Padding(
          padding: const EdgeInsets.only(top: 11),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(userData![AppConstants.imageUrl]),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userData[AppConstants.userHandle],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          messageTime,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.4),
                                  ),
                        ),
                      ],
                    ),
                    Text(
                      text,
                      softWrap: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
