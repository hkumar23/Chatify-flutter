import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/models/post.dart';
import 'package:chatify2/screens/messages_screen.dart';
import 'package:chatify2/widgets/chatifyFeed/post_item.dart';
import 'package:chatify2/widgets/side_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Map<String,dynamic>? userData;
    return Scaffold(
        drawer: const SideDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Text(
              AppLanguage.chatify,
              style: GoogleFonts.pacifico(
                  textStyle:
                      Theme.of(context).textTheme.headlineMedium!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          )),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(MessagesScreen.routeName);
                },
                icon: Icon(
                  Icons.message,
                  color: Theme.of(context).colorScheme.onSurface,
                ))
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(AppConstants.posts)
              .snapshots(),
          builder: (context, postsSnap) {
            if (postsSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final postsData = postsSnap.data!.docs;
            postsData.shuffle();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListView.builder(
                  cacheExtent: (postsData.length) * 510,
                  itemCount: postsData.length,
                  itemBuilder: (context, index) {
                    Post postObj = Post.fromMap(postsData[index].data());
                    return PostItem(
                      key: UniqueKey(),
                      postObj: postObj,
                      postId: postsData[index].id,
                    );
                  }),
            );
          },
        ));
  }
}
