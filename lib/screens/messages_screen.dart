import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/screens/addcontact_screen.dart';
import 'package:chatify2/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatify2/widgets/contact_item.dart';

class MessagesScreen extends StatefulWidget {
  static const routeName = '/messages-screen';

  const MessagesScreen({super.key});
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  Map<String, dynamic>? contactList;
  var currentUser = FirebaseAuth.instance.currentUser;

  Future<void> fetchContactsList() async {
    try {
      var contacts = await FirebaseFirestore.instance
          .collection(AppConstants.contacts)
          .doc(currentUser!.uid)
          .get();
      setState(() {
        contactList = contacts.data();
      });
      // print(contactList);
    } catch (err) {
      // print("user id: ${currentUser!.uid}");
      print("error for contacts: $err");
    }
  }

  // void fetchData(BuildContext context) async {
  //   await AppMethods.getUserDataFromLocalStorage(context);
  // }

  @override
  void initState() {
    super.initState();
    fetchContactsList();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   fetchData(context);
  // }

  @override
  Widget build(BuildContext context) {
    final themeBrightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.outlineVariant,
        title: Container(
          margin: const EdgeInsets.only(bottom: 5),
          child: Text(
            AppLanguage.messages,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: widget.toggleTheme,
        //     icon: Icon(
        //       widget.themeBrightness == Brightness.dark
        //           ? Icons.dark_mode
        //           : Icons.light_mode,
        //       color: Theme.of(context).colorScheme.onSurface,
        //     ),
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchContactsList(),
        child: Stack(children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(AppConstants.users)
                      .snapshots(),
                  builder: (ctx, usersSnap) {
                    if (usersSnap.connectionState == ConnectionState.waiting ||
                        usersSnap.data == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // print(usersSnap.data!.docs);
                    var usersData = usersSnap.data!.docs;
                    if (contactList == null) {
                      return Center(
                        child: ListView(shrinkWrap: true, children: [
                          Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              image: DecorationImage(
                                  invertColors:
                                      themeBrightness == Brightness.dark
                                          ? true
                                          : false,
                                  opacity: 0.5,
                                  image: const NetworkImage(
                                      "https://th.bing.com/th/id/OIG.KCTa5Lx9WmuAHAhivp4g?w=1024&h=1024&rs=1&pid=ImgDetMain")),
                            ),
                          ),
                        ]),
                      );
                    }
                    return ListView.builder(
                      itemCount: usersData.length,
                      itemBuilder: (ctx, index) {
                        // print(currentUser!.uid);
                        if (contactList!.containsKey(usersData[index].id)) {
                          String contactName = usersData[index]
                                  [AppConstants.fName] +
                              " " +
                              usersData[index][AppConstants.lName];
                          if (currentUser!.uid == usersData[index].id) {
                            contactName += " (Myself)";
                          }
                          return ContactItem(
                            imageUrl: usersData[index][AppConstants.imageUrl],
                            userName: contactName,
                            userEmail: usersData[index][AppConstants.email],
                            navigateToChat: () {
                              Navigator.of(context)
                                  .pushNamed(ChatScreen.routeName, arguments: {
                                'username': contactName,
                                'userId': usersData[index].id,
                                'userImage': usersData[index]
                                    [AppConstants.imageUrl],
                              });
                            },
                          );
                        }
                        return const SizedBox(height: 0, width: 0);
                      },
                    );
                  },
                )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(AddContactScreen.routeName);
              },
              child: Container(
                constraints: const BoxConstraints(
                    maxHeight: 70, maxWidth: 70, minHeight: 60, minWidth: 60),
                child: Card(
                  elevation: 5,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.person_add,
                    size: 30,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
