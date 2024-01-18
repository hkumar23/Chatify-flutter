import 'package:chatify2/providers/auth.dart';
import 'package:chatify2/screens/home_screen.dart';
import 'package:chatify2/widgets/side_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/profile-screen';
  // File? userImage;
  SettingsScreen(
    this.toggleAppTheme,
    this.themeBrightness, 
    {super.key}
    );
  Brightness themeBrightness;
  void Function() toggleAppTheme;

  final _updateNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currUser=FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      drawer: const SideDrawer(),
      // appBar: AppBar(title: const Text("Profile")),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.45,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const NetworkImage("https://cdn.wallpapersafari.com/56/84/YCLrBl.jpg"),
                fit: BoxFit.cover,
                opacity: 0.5,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.primary,
                  BlendMode.multiply,)
                )
            ),
          ),
          Column(            
            children: [
              Flexible(
                flex: 1,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").doc(currUser!.uid).snapshots(),
                  builder: (context, userSnapshot) {                    
                    final userData=userSnapshot.data;
                    if(userSnapshot.connectionState == ConnectionState.waiting ||
                    userData==null){
                      return const Center(child: CircularProgressIndicator(),);
                    }                    
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
                            ]
                          ),
                          child: CircleAvatar(                      
                            radius: 70,
                            backgroundImage: NetworkImage(userData["image_url"]),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Text(
                          userData["username"],
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onInverseSurface,
                            fontWeight: FontWeight.bold),
                          ),
                        Text(
                          userData["email"],
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onInverseSurface,
                            fontWeight: FontWeight.bold),),
                      ]);
                  }
                ),                
              ),
              Flexible(              
                flex: 2,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 300),                  
                  margin: const EdgeInsets.all(20),
                  child: Card(                    
                          color: Theme.of(context).colorScheme.secondaryContainer,
                          child: SingleChildScrollView(
                            child: Column( 
                                mainAxisSize: MainAxisSize.min,                                       
                                children: [
                                  const SizedBox(height: 20,),
                                  ListTile(
                                    leading: const Icon(Icons.account_circle),
                                    title: const Text("My Profile",style: TextStyle(fontWeight: FontWeight.bold),),
                                    onTap: (){},
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.edit),
                                    title: const Text("Edit Name",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context){
                                          return AlertDialog(                                           
                                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                            title: Text(
                                              "Choose a New Name",
                                              style: Theme.of(context).textTheme.headlineSmall,
                                              ),
                                            content: TextField(
                                                        controller: _updateNameController,
                                                        decoration: const InputDecoration(border: OutlineInputBorder()),                                              
                                                      ),
                                            actions: [
                                              OutlinedButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: const Text("Close"),
                                                ),
                                              FilledButton(
                                                  onPressed: () async {
                                                    await FirebaseFirestore.instance.collection("users").doc(currUser.uid).update({"username":_updateNameController.text.trim()});                                                    
                                                    Navigator.of(context).pop();
                                                    ScaffoldMessenger.of(context).showSnackBar(                                                      
                                                      SnackBar(
                                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                                        content: const Text("Information Updated")),
                                                    );
                                                  }, 
                                                  child: const Text("Update"),
                                                ),                                              
                                            ],                                         
                                          );
                                        },
                                      );                                      
                                    },
                                  ),       
                                  ListTile(
                                    leading: const Icon(Icons.image),
                                    title: const Text("Change Profile Image",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    onTap: (){},
                                  ),                   
                                  ListTile(
                                    leading: const Icon(Icons.lock),
                                    title: const Text("Change Password",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    onTap: (){
                                      showDialog(
                                        context: context, 
                                        builder: (BuildContext context){
                                          return AlertDialog(
                                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                            title: const Text("Confirm Password Change"),
                                            actions: [
                                              FilledButton(
                                                onPressed: (){
                                                  Provider.of<Auth>(context,listen: false).resetPassword(currUser.email!, context);
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context).showSnackBar(                                                      
                                                      SnackBar(
                                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                                        content: const Text(
                                                          "Password reset email sent successfully",
                                                          // style: TextStyle(fontWeight: FontWeight.bold),
                                                          )),
                                                    );
                                                }, 
                                                child: const Text("Yes"),
                                              ),
                                              OutlinedButton(
                                                onPressed: (){
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("No"),
                                                )
                                            ],
                                          );
                                        },
                                        );
                                    },
                                  ),                                  
                                  ListTile(
                                    leading: const Icon(Icons.home),
                                    title: const Text("Home",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    onTap: () {
                                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
                                      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
                                      // Navigator.of(context).pushNamed('/');    
                                    },
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      themeBrightness==Brightness.light ?
                                      Icons.dark_mode:
                                      Icons.light_mode),
                                    title: const Text("Switch Theme",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    onTap: toggleAppTheme,
                                  ),
                                  ListTile(
                                    leading: Icon(MdiIcons.tools),
                                    title: const Text("Tools",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    onTap: (){},
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.feedback),
                                    title: const Text("Feedback",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    onTap: (){
                                      // Navigator.of(context).pushNamed(FeedbackScreen.routeName);
                                     },
                                  ),                                             
                                  ListTile(
                                    leading: const Icon(Icons.logout),
                                    title: const Text("Logout",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // trailing: const Icon(Icons.arrow_forward_ios_rounded),
                                    iconColor: Colors.redAccent,
                                    textColor: Colors.redAccent,
                                    onTap: (){
                                      Provider.of<Auth>(context,listen: false).logoutWithDialog(context);
                                    },
                                  ),    
                                  const SizedBox(height: 20,),                  
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