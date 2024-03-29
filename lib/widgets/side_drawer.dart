import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/providers/auth.dart';
import 'package:chatify2/screens/addcontact_screen.dart';
import 'package:chatify2/screens/create_post_screen.dart';
import 'package:chatify2/screens/profile_screen.dart';
import 'package:chatify2/screens/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Brightness themeBrightness = Theme.of(context).brightness;
    final currUser = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(0),
        bottomRight: Radius.circular(0),
      )),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Opacity(
                    opacity: 0.4,
                    child: Image.asset(
                      color: Theme.of(context).colorScheme.primary,
                      colorBlendMode: themeBrightness == Brightness.light
                          ? BlendMode.screen
                          : BlendMode.multiply,
                      "assets/images/sidebar_background.jpg",
                      fit: BoxFit.cover,
                    )),
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 10,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(AppConstants.users)
                          .doc(currUser!.uid)
                          .snapshots(),
                      builder: (context, userSnapshot) {
                        final userData = userSnapshot.data;
                        if (userSnapshot.connectionState ==
                                ConnectionState.waiting ||
                            userData == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        String fullName = userData[AppConstants.fName] +
                            " " +
                            userData[AppConstants.lName];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(
                                  userData[AppConstants.imageUrl],
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 7,
                            // ),
                            Text(
                              fullName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                    // color: Theme.of(context).colorScheme.onSecondaryContainer,
                                    fontWeight: FontWeight.bold,
                                    // shadows: [
                                    //   Shadow(
                                    //     blurRadius: 5,
                                    //     color: Colors.black.withOpacity(0.3),
                                    //     offset: const Offset(0,2),
                                    //   ),
                                    // ],
                                  ),
                            ),
                            Expanded(
                              child: Text(
                                userData[AppConstants.email],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      // shadows: [
                                      //   Shadow(
                                      //     blurRadius: 1.5,
                                      //     color: Colors.black.withOpacity(0.3),
                                      //     offset: const Offset(0,1.5),
                                      //   ),
                                      // ],
                                    ),
                              ),
                            ),
                          ],
                        );
                      }),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(top: 25),
              height: double.infinity,
              width: double.infinity,
              child: Column(
                children: [
                  // _listTileBuilder(
                  //     context,
                  //     Icons.home,
                  //     "Home",
                  //     (){ },
                  //     null,
                  //   ),
                  _listTileBuilder(
                      context, Icons.account_circle, AppLanguage.myProfile, () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(currUser.uid)));
                  }, null),
                  _listTileBuilder(
                    context,
                    Icons.person_add,
                    AppLanguage.addNewContact,
                    () {
                      Navigator.of(context)
                          .pushNamed(AddContactScreen.routeName);
                    },
                    null,
                  ),
                  _listTileBuilder(
                    context,
                    MdiIcons.upload,
                    AppLanguage.createNewPost,
                    () {
                      Navigator.of(context)
                          .pushNamed(CreatePostScreen.routeName);
                    },
                    null,
                  ),
                  _listTileBuilder(
                    context,
                    MdiIcons.tools,
                    AppLanguage.tools,
                    () {},
                    null,
                  ),
                  _listTileBuilder(
                      context, Icons.settings, AppLanguage.settings, () {
                    Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  }, null),
                  _listTileBuilder(
                    context,
                    Icons.feedback,
                    AppLanguage.feedback,
                    () {},
                    null,
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                  _listTileBuilder(
                    context,
                    Icons.logout,
                    AppLanguage.logout,
                    () {
                      Provider.of<Auth>(context, listen: false)
                          .logoutWithDialog(context);
                    },
                    Colors.redAccent,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Material _listTileBuilder(
    BuildContext context,
    IconData iconData,
    String titleText,
    Function() ontap,
    Color? tileColor,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: ontap,
        splashColor: Colors.white.withOpacity(0.2),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 40),
          leading: Icon(
            iconData,
            color:
                tileColor ?? Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          title: Text(
            titleText,
            style: TextStyle(
              fontSize: 16,
              color: tileColor ??
                  Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
