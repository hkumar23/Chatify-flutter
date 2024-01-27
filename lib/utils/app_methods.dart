import 'dart:io';

import 'package:chatify2/providers/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppMethods{
  static Future<void> getUserDataFromLocalStorage(BuildContext context) async {
    // print("fetching user data");
    final auth=Provider.of<Auth>(context,listen: false);
    final sharedPreferences=await SharedPreferences.getInstance();

    auth.userId=sharedPreferences.getString("userId");
    auth.userName=sharedPreferences.getString("username");
    auth.userEmail=sharedPreferences.getString("email");
    auth.userImageUrl=sharedPreferences.getString("image_url");

    // print(sharedPreferences.getString("userId"));
  }

  static Future<Map<String,dynamic>?> fetchUserDataFromServer(String userId,BuildContext context) async {
    try{
      final userSnap=await FirebaseFirestore.instance.collection("users").doc(userId).get();
      final userData=userSnap.data();
      // print(userData);
      return userData;
    }
    catch(err){
      // print(err);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text("Error in fetching user data!"),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      rethrow;
    }
  }

  static Future<File> pickImage() async {
    // print("Picking image");
    final ImagePicker picker=ImagePicker();
    final XFile? image=await picker.pickImage(
      source: ImageSource.gallery,
      // imageQuality: 100,
      maxWidth: 1080,
      maxHeight: 1080,
      );
    return File(image!.path);
  }

  static void updateName({
    required String newName,
    required String userId, 
    required BuildContext context}) async {

    String labelVal;
    bool isUpdated=false;
    try{
      if(newName==""){
        throw "Enter a valid name, please.";
      }
      await FirebaseFirestore.instance.collection("users").doc(userId).update({"username":newName.trim()});                                                    
      labelVal="Name successfully updated.";    
      isUpdated=true;                                                  
    }
    catch(err){
      labelVal=err.toString();
    }

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(                                                      
      SnackBar(
        backgroundColor: isUpdated ?
        Theme.of(context).colorScheme.primary :
        Theme.of(context).colorScheme.error,
        content: Text(labelVal),
      ),
    );
  }

  static Future<void> urlLauncher(String url,BuildContext context) async {
    final uri=Uri.parse(url);
    if(await canLaunchUrl(uri)){
      await launchUrl(
        uri,
        mode: LaunchMode.externalNonBrowserApplication,
        );
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: const Text("Error in launching url"),
          )
      );
    }
  }

}
