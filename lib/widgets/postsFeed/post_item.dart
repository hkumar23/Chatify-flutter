import 'package:chatify2/widgets/postsFeed/expandable_caption.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PostItem extends StatelessWidget {
  const PostItem({
    required this.userName,
    required this.userImageUrl,
    required this.userEmail,
    required this.postImageUrl,
    super.key,
  });
  final String userName;
  final String userImageUrl;
  final String userEmail;
  final String postImageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
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
                    backgroundImage: NetworkImage(userImageUrl),
                    radius: 15,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    // Text(
                    //   userEmail,
                    //   style: Theme.of(context).textTheme.labelLarge,
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage(postImageUrl),
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
                onPressed: () {},
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
          const Row(
            children: [
              Text("123 Likes  "),
              Text("12 comments"),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Wrap(
              children: [
                Text(
                  "$userName: ",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const ExpandableCaption(
                  caption:
                      "This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption This is Some random Caption",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
