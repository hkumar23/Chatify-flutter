import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier{
  String? userEmail;
  String? userName;
  String? userId;
  String? userImageUrl;
  Auth({
    this.userEmail,
    this.userName,
    this.userId,
    this.userImageUrl,
  });

  void logout(BuildContext context){
    FirebaseAuth.instance.signOut();
    userEmail=null;
    userName=null;
    userId=null;
    userImageUrl=null;
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    Navigator.of(context).pushNamed('/');
  }
  
  void logoutWithDialog(BuildContext ctx){
    showDialog(
            context: ctx, 
            builder: (BuildContext context){
              return AlertDialog(
                    shadowColor: Theme.of(context).colorScheme.shadow,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    title: const Text("Are you sure you want to logout?"),
                    actions: [
                      OutlinedButton(
                        onPressed: (){
                          logout(context);    
                        }, 
                        child: const Text("Yes"),
                      ),  
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(), 
                        child: const Text("No"),
                      )
                    ],
              );
            },
      );
  }

  Future<void> authenticate({
    required BuildContext context,
    required String? email,
    required String? password,
    String? username,
    File? image,
    bool isLogin=true,
  }) async {

    final auth=FirebaseAuth.instance;
    final sharedPreferences=await SharedPreferences.getInstance();
    // print("Auth Started");
    try{
      if(isLogin){
        final authResult=await auth.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        userId=authResult.user!.uid;
        // print(userId);

        final fethedUserdata=await FirebaseFirestore.instance.collection("users").doc(userId).get();
        final userData=fethedUserdata.data();

        // userEmail=userData!["email"];
        // userImageUrl=userData["image_url"];
        // userName=userData["username"];
        sharedPreferences.setString("userId", userId!);
        sharedPreferences.setString("email", userData!["email"]);
        sharedPreferences.setString("image_url", userData["image_url"]);
        sharedPreferences.setString("username", userData["username"]);
        // print("$userEmail+$userImageUrl+$username");
      }
      else{
        final authResult= await auth.createUserWithEmailAndPassword(
          email: email!, 
          password: password!,
        );
        userId=authResult.user!.uid;

        final ref=FirebaseStorage.instance.ref().child("user_image").child('${userId!}.png');
        await ref.putFile(image!);
        
        userImageUrl=await ref.getDownloadURL();
        
        await FirebaseFirestore.instance.collection("users").doc(authResult.user!.uid).set(
              {
              'email':email,
              'username':username,
              'image_url':userImageUrl,
            });
        
        await FirebaseFirestore.instance.collection("userEmails").doc(email).set({
          'userid':userId,
        });
        
        sharedPreferences.setString("userId", userId!);
        sharedPreferences.setString("email", email);
        sharedPreferences.setString("image_url", userImageUrl!);
        sharedPreferences.setString("username", username!);
      }
    }on FirebaseException catch(err){
      // print("PlatformException");
      String? message="An error occured please check your credentials!";
      if(err.message!=null){
        message=err.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch(err){
      print(err);
    }
  }

  void resetPassword(String email,BuildContext context) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch(err){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).colorScheme.error,
            content: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(err.toString()),
          ))
        );
        rethrow;
    }
  }

}