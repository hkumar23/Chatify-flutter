import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/models/post.dart';
import 'package:chatify2/utils/app_methods.dart';
import 'package:chatify2/widgets/chatifyFeed/comments_dialog_box.dart';
import 'package:chatify2/widgets/chatifyFeed/expandable_caption.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PostItem extends StatefulWidget {
  const PostItem({
    required this.userHandle,
    required this.userImageUrl,
    required this.postId,
    // required this.userEmail,
    // required this.postImageUrl,
    required this.postObj,
    super.key,
  });
  final Post postObj;
  final String userHandle;
  final String userImageUrl;
  final String postId;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  Map<String, dynamic>? userData;
  Future<void> fetchUserData() async {
    // final currUserId = FirebaseAuth.instance.currentUser!.uid;
    final tempData = await AppMethods.fetchUserDataFromServer(
        widget.postObj.userId, context);
    setState(() {
      userData = tempData;
    });
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   fetchUserData();
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    // fetchUserDataAndComments(context);
    // print(userData);
    final likesCount =
        widget.postObj.likes == null ? 0 : widget.postObj.likes!.length;
    // print(widget.postObj.likes);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: userData == null
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 2),
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userData![AppConstants.imageUrl]),
                          radius: 20,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData![AppConstants.userHandle],
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            widget.postObj.location,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints:
                      const BoxConstraints(maxHeight: 400, minHeight: 350),
                  // height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.postObj.imageUrl),
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        MdiIcons.heart,
                        size: 30,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CommentsDialogBox(
                              postId: widget.postId,
                            );
                          },
                        );
                      },
                      icon: Icon(
                        MdiIcons.commentOutline,
                        size: 28,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 160),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          MdiIcons.share,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                likesCount > 0 ? Text("$likesCount Likes  ") : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "${userData![AppConstants.userHandle]} ",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ExpandableCaption(
                        caption: widget.postObj.caption,
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
