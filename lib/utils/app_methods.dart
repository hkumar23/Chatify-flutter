import 'package:chatify2/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

}
