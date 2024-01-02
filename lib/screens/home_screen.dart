import 'package:chatify2/screens/add_contacts.dart';
import 'package:chatify2/screens/chat_screen.dart';
import 'package:chatify2/widgets/side_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chatify2/widgets/contact_item.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  
  HomeScreen(
    this.themeBrightness,
    this.toggleTheme,
    );
  final Brightness themeBrightness;
  final void Function() toggleTheme;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String,dynamic>? contactList;
  var currentUser=FirebaseAuth.instance.currentUser;

  Future<void> fetchFirbaseData() async{
    try{
      var userData = await FirebaseFirestore.instance.collection("contacts").doc(currentUser!.uid).get();
      setState(() {
        contactList=userData.data();
      });
      // print(contactList);
    }catch(err){
      // print("user id: ${currentUser!.uid}");
      print("error for contacts: $err");
    }
  }

  @override
  void initState() {
    fetchFirbaseData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Chatify",
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
          ),
        actions: [
          IconButton(
            onPressed: widget.toggleTheme, 
            icon: Icon(
              widget.themeBrightness==Brightness.dark ?
               Icons.dark_mode :
               Icons.light_mode,
               ),
          ),
        ],  
        ),
      body: Stack(
        children: [
          Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [      
              Expanded(
                child: 
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').snapshots(),
                  builder: (ctx,usersSnap) {
                    if(usersSnap.connectionState == ConnectionState.waiting ||
                    usersSnap.data==null){
                      return const Center(child: CircularProgressIndicator(),);
                    }
                    // print(usersSnap.data!.docs.length);  
                    var userData=usersSnap.data!.docs;
                    if(contactList==null){
                      return Center(                              
                        child:
                         Container(
                          height: 200,
                          width: 200,                          
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            image: DecorationImage(
                              invertColors: widget.themeBrightness == Brightness.dark ? true : false,
                              opacity: 0.5,                              
                              image: const NetworkImage("https://th.bing.com/th/id/OIG.KCTa5Lx9WmuAHAhivp4g?w=1024&h=1024&rs=1&pid=ImgDetMain")
                              ),                            
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: userData.length,
                        itemBuilder: (ctx,index){
                          // print(currenUser!.uid);                          
                          return contactList!.containsKey(userData[index].id) ?
                          ContactItem(
                            userData[index]["image_url"],
                            userData[index]["username"],
                            userData[index]["email"],
                            (){
                              Navigator.of(context).pushNamed(ChatScreen.routeName,arguments: userData[index].id);
                            },
                          ) 
                          : SizedBox(height: 0,width: 0);                        
                        },
                      );
                  },
                  )
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).pushNamed(AddContactScreen.routeName);
            },
            child: Container(
              constraints: const BoxConstraints(maxHeight: 70,maxWidth: 70,minHeight: 60,minWidth: 60),
              child: Card(
                elevation: 5,
                color: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.person_add,
                  size: 30,
                  color: Theme.of(context).colorScheme.onPrimary,
                  ),
              ),
            ),
          ),
        ),
        ]
      ),
    );
  }
}