import 'package:chatify2/utils/app_methods.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  // static const routeName='/profile-screen';

  String userId;
  ProfileScreen(this.userId,{super.key});
  @override
  Widget build(BuildContext context) {
    // _fetchUserData(otherUserId);
    // print(otherUserData);
    // print(userId);
    Size deviceSize=MediaQuery.of(context).size;
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
                  height: deviceSize.height*0.55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(userData!["image_url"]),
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                      )
                  ),             
                ),
                Container(
                  margin: EdgeInsets.only(top: deviceSize.height*0.45),
                  // height: deviceSize.height*0.5,   
                  alignment: Alignment.bottomCenter,                           
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 25,
                        offset: const Offset(0,10),                        
                      )
                    ],
                    // color: Colors.amber.withOpacity(0.5),                    
                    // gradient: LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,                            
                    //   colors: [
                    //       Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.5),
                    //       Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                    //       // Theme.of(context).colorScheme.secondaryContainer,
                    //       ]
                      )
                    ), 
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   right: 0,
                //   child: AppBar(                    
                //     // leading: const Icon(Icons.arrow_back_ios_new_rounded),                    
                //     title: Text(
                //       "Profile",
                //       style: GoogleFonts.montserrat(
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
                //     shadowColor: Colors.black,                    
                //     // foregroundColor: Colors.white,
                //     )
                //   ),
                SingleChildScrollView(                  
                  child: Column(                    
                    children: [
                      SizedBox(height:deviceSize.height*0.5,),
                      Container(                                                 
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,                            
                            colors: [
                                Theme.of(context).colorScheme.tertiaryContainer,
                                Theme.of(context).colorScheme.primaryContainer,
                                // Theme.of(context).colorScheme.secondaryContainer,
                              ]
                            )
                          ),                                              
                        child: Column(                                              
                            children: [
                              const SizedBox(height: 10,),
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