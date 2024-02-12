import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/screens/messages_screen.dart';
import 'package:chatify2/widgets/postsFeed/post_item.dart';
import 'package:chatify2/widgets/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
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
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => const PostItem(
            userName: "User Name",
            userImageUrl: AppConstants.blankProfileImage,
            userEmail: "tempemail@test.com",
            postImageUrl:
                "https://i.pinimg.com/564x/c8/77/d3/c877d303866d6cbc9d0e58be1bfcec1a.jpg",
          ),
        ),
      ),
    );
  }
}
