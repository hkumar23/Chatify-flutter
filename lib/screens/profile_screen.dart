import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatify2/utils/app_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileScreen extends StatelessWidget {
  // static const routeName='/profile-screen';

  String userId;
  ProfileScreen(this.userId,{super.key});
  @override
  Widget build(BuildContext context) {
    // _fetchUserData(otherUserId);
    // print(otherUserData);
    // print(userId);
    
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Profile"),
      // ),
      body: FutureBuilder(
        future: AppMethods.fetchUserDataFromServer(userId, context), 
        builder: (context,userSnap){
          Map<String,dynamic>? userData=userSnap.data;
          if(userSnap.connectionState == ConnectionState.waiting || userSnap.hasError){
            return const Center(child: CircularProgressIndicator(),);
          }
          else{
            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(userData!["image_url"]),
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                      )
                  ),             
                ),
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   right: 0,
                //   child: AppBar(
                //     title: const Text(
                //       "Profile",
                //       // style: TextStyle(color: Colors.white,),
                //       ),
                //     backgroundColor: Colors.transparent,
                //     shadowColor: Colors.black,                    
                //     foregroundColor: Colors.white,
                //     )
                //   )
                SingleChildScrollView(                  
                  child: Column(                    
                    children: [
                      SizedBox(height:MediaQuery.of(context).size.height*0.5,),
                      Container(                                                 
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,                            
                            colors: [
                                Theme.of(context).colorScheme.tertiaryContainer,
                                Theme.of(context).colorScheme.primaryContainer,
                              ]
                            )
                          ),                                              
                        child: Column(                                              
                            children: [
                              Transform.rotate(
                                angle: -90 * (3.141592653589793 / 180),
                                child: const Icon(Icons.arrow_forward_ios_rounded),
                                ),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                              const ListTile(title: Text("Profile Tile"),),
                            ],
                          ),
                        ),                      
                    ],
                  ),
                )
                ],
            );
          }
        },
      )
    );
  }
}