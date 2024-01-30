import 'package:chatify2/utils/app_methods.dart';
import 'package:chatify2/widgets/project_item.dart';
import 'package:chatify2/widgets/social_media_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProfileScreen extends StatelessWidget {
  // static const routeName='/profile-screen';

  String userId;
  ProfileScreen(this.userId,{super.key});

  @override
  Widget build(BuildContext context) {
    Size deviceSize=MediaQuery.of(context).size;
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
        
      //   backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
      //   title: Text(
      //     "Profile",
      //     style: GoogleFonts.montserrat(
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      // ),
      body: FutureBuilder(
        future: AppMethods.fetchUserDataFromServer(userId, context), 
        builder: (context,userSnap){
          Map<String,dynamic>? userData=userSnap.data;
          if(userSnap.connectionState == ConnectionState.waiting || userSnap.hasError){
            return const Center(child: CircularProgressIndicator(),);
          }
          else{
            final fullName=userData!["fName"]+" "+userData["lName"];
            return Stack(
              children: [
                Container(
                  height: deviceSize.height*0.55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(userData["imageUrl"]),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      )
                  ),             
                ),
                SingleChildScrollView(                  
                  child: Column(                    
                    children: [
                      SizedBox(height:deviceSize.height*0.5,),
                      Container(    
                        width: double.infinity,     
                        constraints: const BoxConstraints(minHeight: 500),                                       
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,  
                            // tileMode: TileMode.mirror,                          
                            colors: [
                                Theme.of(context).colorScheme.tertiaryContainer,
                                Theme.of(context).colorScheme.primaryContainer,
                              ]
                            )
                          ),                                              
                        child: Column(                        
                              crossAxisAlignment: CrossAxisAlignment.start,                                            
                              children: [
                                const SizedBox(height: 10,),
                                Align(
                                  alignment: Alignment.center,
                                  child: Transform.rotate(
                                    angle: -90 * (3.141592653589793 / 180),
                                    child: const Icon(Icons.arrow_forward_ios_rounded),
                                    ),
                                ),       
                                // const SizedBox(height: 10,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 30,top: 10),
                                  child: Text(
                                        fullName,
                                        style: GoogleFonts.raleway(
                                          fontSize: Theme.of(context).textTheme.displayLarge!.fontSize,
                                          fontWeight: FontWeight.w700,
                                          height: 1,
                                        ),
                                    ),
                                ),
                                // const SizedBox(height: 15,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,right: 20,top: 10,),
                                  child: Wrap(
                                    spacing: 15,
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    // direction: Axis.horizontal,
                                    children: [                                  
                                      Text(
                                          userData["profession"],
                                          style: GoogleFonts.notoSans(
                                              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                                              // fontWeight: FontWeight.w500,
                                            ),
                                          ),                               
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 2),
                                        child: Row(
                                          // crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              userData["address"]["state"],
                                              style: GoogleFonts.notoSans(
                                                  fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,                                            
                                                ),
                                            ),
                                            Icon(
                                                Icons.place,
                                                size: Theme.of(context).textTheme.titleLarge!.fontSize,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),                                
                                Padding(
                                  padding: const EdgeInsets.only(top: 20,left: 30,right: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                            "892",
                                            style: GoogleFonts.notoSans(
                                                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,    
                                                fontWeight: FontWeight.bold,  
                                                height: 1.1,                                      
                                              ),                               
                                          ),
                                      Text(
                                            "Connections",
                                            style: GoogleFonts.notoSans(
                                                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,                                                                                            
                                                height: 1.1,
                                              ),                                            
                                          ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(top:20,left: 30,right: 20),
                                  child: FilledButton(
                                    style: ButtonStyle(  
                                      foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.surface),                                    
                                      backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.primary),
                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                                    ),                                  
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                     child: const Text("Message"),
                                    ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
                                  child: Row(
                                    children: [
                                      SocialMediaButton(link: userData["socialMediaLinks"]["instagram"],icon: MdiIcons.instagram,),
                                      SocialMediaButton(link: userData["socialMediaLinks"]["linkedin"],icon: MdiIcons.linkedin,),
                                      SocialMediaButton(link: userData["socialMediaLinks"]["twitter"],icon: MdiIcons.twitter,),
                                      SocialMediaButton(link: userData["socialMediaLinks"]["github"],icon: MdiIcons.github,),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30,top: 30,bottom: 20,right: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      Text(
                                        "About Me",
                                        style: GoogleFonts.notoSans(
                                          fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
                                          fontWeight: FontWeight.bold,                                        
                                        ),
                                      ),
                                      Text(
                                        userData["about"],
                                        style: GoogleFonts.roboto(
                                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                        ),
                                      ),
                                      const SizedBox(height: 15,),
                                      Text(
                                        "Technical Skills",
                                        style: GoogleFonts.notoSans(
                                          fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
                                          fontWeight: FontWeight.bold,                                        
                                        ),
                                      ),
                                      Text(
                                        userData["techSkills"],
                                        style: GoogleFonts.roboto(
                                          fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                                        ),
                                      ),
                                      const SizedBox(height: 15,),                                      
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance.collection("users").doc(userId).collection("projects").snapshots(),
                                        builder: (context, projectsSnap) {
                                          if(projectsSnap.connectionState==ConnectionState.waiting){
                                            return const Center(child: CircularProgressIndicator());
                                          }
                                          if(projectsSnap.hasError){
                                            return const Text("Some error occured in loading projects");
                                          }
                                          final projectDocs=projectsSnap.data!.docs;
                                          if(projectDocs.isNotEmpty){
                                              List<ProjectItem> list=[];
                                              for(int i=0; i<projectDocs.length; ++i){
                                                list.add(
                                                  ProjectItem(
                                                    title: projectDocs[i]["projectName"],
                                                    description: projectDocs[i]["description"],
                                                    )
                                                );
                                              }
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Projects",
                                                    style: GoogleFonts.notoSans(
                                                      fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
                                                      fontWeight: FontWeight.bold,                                        
                                                    ),
                                                  ),
                                                  Column(
                                                    children: list,
                                                  ),
                                                ],
                                              );
                                          }                                          
                                          return const SizedBox();
                                        }
                                      ),                                      
                                    ]
                                  ),
                                ),
                                
                              ],
                            ),
                        ),                   
                    ],
                  ),
                ),
                ],
            );
          }
        },
      )
    );
  }
}