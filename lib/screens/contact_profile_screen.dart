import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ContactProfileScreen extends StatelessWidget {
  static const routeName='/contact-profile-screen';
  // var otherUserData;
  // Future<void> _fetchUserData(String userId) async {
  //   try{
  //     final userSnap=await FirebaseFirestore.instance.collection("users").doc(userId).get();
  //     otherUserData=userSnap.data();
  //     print(otherUserData);
  //   }
  //   catch(err){
  //     print(err);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    var otherUserId=ModalRoute.of(context)!.settings.arguments.toString();
    // _fetchUserData(otherUserId);
    // print(otherUserData);
    // print(arguments);
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Profile"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").doc(otherUserId).snapshots(), 
        builder: (context,userSnap){
          if(userSnap.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          return Center(
            child:Text(userSnap.data!["username"]),
          );
        },
      )
    );
  }
}