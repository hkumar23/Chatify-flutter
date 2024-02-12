import 'dart:io';

import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/providers/auth.dart';
import 'package:chatify2/screens/home_screen.dart';
import 'package:chatify2/screens/messages_screen.dart';
import 'package:chatify2/screens/profile_screen.dart';
import 'package:chatify2/screens/tools_screen.dart';
import 'package:chatify2/screens/user_projects_screen.dart';
import 'package:chatify2/utils/app_methods.dart';
import 'package:chatify2/widgets/side_drawer.dart';
import 'package:chatify2/widgets/upload_image_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings-screen';
  // File? userImage;
  SettingsScreen(this.toggleAppTheme, this.themeBrightness, {super.key});
  Brightness themeBrightness;
  void Function() toggleAppTheme;

  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();

  void changeImageFn(var auth, String userId, BuildContext context) async {
    String contentVal;
    bool isUpdated = false;
    File? pickedImage;
    try {
      pickedImage = await AppMethods.pickImage();
      auth.updateImage(pickedImage, userId);
      contentVal = "Image Updated Successfully";
      isUpdated = true;
    } catch (err) {
      if (pickedImage == null) {
        contentVal = "Image not selected";
      } else {
        contentVal = err.toString();
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      // action: SnackBarAction(label: "label",backgroundColor: Colors.amber,onPressed: (){},),
      content: Text(contentVal),
      backgroundColor: isUpdated
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.error,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      drawer: SideDrawer(),
      // appBar: AppBar(
      //   title: const Text("Settings"),
      //   backgroundColor: Colors.transparent,
      //   ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: const AssetImage(
                        "assets/images/settings_background.jpg"),
                    fit: BoxFit.cover,
                    opacity: 0.5,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.multiply,
                    ))),
          ),
          Column(
            children: [
              Flexible(
                flex: 4,
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
                      final fullName = userData[AppConstants.fName] +
                          " " +
                          userData[AppConstants.lName];
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    )
                                  ]),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: NetworkImage(
                                    userData[AppConstants.imageUrl]),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              fullName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineLarge!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userData[AppConstants.email],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          ]);
                    }),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  // alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: double.infinity,
                  // color: Colors.amber,
                  padding: const EdgeInsets.only(left: 5, top: 10),
                  child: Text(
                    AppLanguage.settings,
                    style: GoogleFonts.oswald(
                      color: Colors.lightBlueAccent,
                      letterSpacing: 5,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 7,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 300),
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            leading: const Icon(Icons.account_circle),
                            title: const Text(
                              AppLanguage.myProfile,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        currUser.uid,
                                      )));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text(
                              AppLanguage.editName,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    title: Text(
                                      "Choose a New Name",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _fNameController,
                                          decoration: const InputDecoration(
                                            label: Text(AppLanguage.firstName),
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          controller: _lNameController,
                                          decoration: const InputDecoration(
                                            label: Text(AppLanguage.lastName),
                                            border: OutlineInputBorder(),
                                          ),
                                        )
                                      ],
                                    ),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text(AppLanguage.close),
                                      ),
                                      FilledButton(
                                        onPressed: () {
                                          return AppMethods.updateName(
                                              fName: _fNameController.text,
                                              lName: _lNameController.text,
                                              userId: currUser.uid,
                                              context: context);
                                        },
                                        child: const Text(AppLanguage.update),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.image),
                            title: const Text(
                              "Change Profile Image",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: GestureDetector(
                                        onTap: () => changeImageFn(
                                            Provider.of<Auth>(context,
                                                listen: false),
                                            currUser.uid,
                                            context),
                                        child: const UploadImageBox(),
                                      ),
                                    );
                                  });
                            },
                          ),
                          ListTile(
                            leading: Icon(MdiIcons.fileEdit),
                            title: const Text(
                              "Edit/Add Projects",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const UserProjectsScreen()),
                              );
                            },
                          ),
                          ListTile(
                            leading: Icon(MdiIcons.phoneMessage),
                            title: const Text(
                              "Social Media Links",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {},
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.5),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: const Text(
                              "Change Password",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                    title:
                                        const Text("Confirm Password Change"),
                                    actions: [
                                      FilledButton(
                                        onPressed: () {
                                          Provider.of<Auth>(context,
                                                  listen: false)
                                              .resetPassword(
                                                  currUser.email!, context);
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                content: const Text(
                                                  "Password reset email sent successfully",
                                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                                )),
                                          );
                                        },
                                        child: const Text(AppLanguage.yes),
                                      ),
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(AppLanguage.no),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.home),
                            title: const Text(
                              AppLanguage.home,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              // Navigator.of(context).popUntil(ModalRoute.withName('/'));
                              // Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                              // Navigator.of(context).pushNamed('/');
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  HomeScreen.routeName, (route) => false);
                            },
                          ),
                          ListTile(
                            leading: Icon(themeBrightness == Brightness.light
                                ? Icons.dark_mode
                                : Icons.light_mode),
                            title: const Text(
                              AppLanguage.switchTheme,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: toggleAppTheme,
                          ),
                          ListTile(
                            leading: Icon(MdiIcons.tools),
                            title: const Text(
                              "Tools",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ToolsScreen()));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.feedback),
                            title: const Text(
                              "Feedback",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              // Navigator.of(context).pushNamed(FeedbackScreen.routeName);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text(
                              AppLanguage.logout,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            iconColor: Colors.redAccent,
                            textColor: Colors.redAccent,
                            onTap: () {
                              Provider.of<Auth>(context, listen: false)
                                  .logoutWithDialog(context);
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
