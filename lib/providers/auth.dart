import 'dart:io';

import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/misc/app_language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Auth with ChangeNotifier {
  String? userEmail;
  String? fName;
  String? lName;
  String? userId;
  String? imageUrl;
  String? about;
  Map<String, String>? address = {
    AppConstants.state: "",
    AppConstants.city: "",
    AppConstants.pincode: "",
    AppConstants.street: "",
  };
  String? profession;
  Map<String, String>? socialMediaLinks = {
    AppConstants.github: "",
    AppConstants.instagram: "",
    AppConstants.linkedin: "",
    AppConstants.twitter: "",
  };
  String? techSkills;

  Auth({
    this.userEmail,
    this.fName,
    this.lName,
    this.userId,
    this.imageUrl,
    this.about,
    this.address,
    this.profession,
    this.socialMediaLinks,
    this.techSkills,
  });

  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    userEmail = null;
    fName = null;
    lName = null;
    imageUrl = null;
    about = null;
    address = null;
    profession = null;
    socialMediaLinks = null;
    techSkills = null;

    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    Navigator.of(context).pushNamed('/');
  }

  void logoutWithDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: Theme.of(context).colorScheme.shadow,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text("Are you sure you want to logout?"),
          actions: [
            OutlinedButton(
              onPressed: () {
                logout(context);
              },
              child: const Text(AppLanguage.yes),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppLanguage.no),
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
    File? userImageFile,
    userData,
    bool isLogin = true,
  }) async {
    final auth = FirebaseAuth.instance;
    // print("Auth Started");
    try {
      if (isLogin) {
        final authResult = await auth.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        userId = authResult.user!.uid;
        // print(userId);

        final fethedUserdata = await FirebaseFirestore.instance
            .collection(AppConstants.users)
            .doc(userId)
            .get();
        final userData = fethedUserdata.data();

        userEmail = userData![AppConstants.email];
        fName = userData[AppConstants.fName];
        lName = userData[AppConstants.lName];
        imageUrl = userData[AppConstants.imageUrl];
        about = userData[AppConstants.about];
        address = userData[AppConstants.address];
        profession = userData[AppConstants.profession];
        socialMediaLinks = userData[AppConstants.socialMediaLinks];
        techSkills = userData[AppConstants.techSkills];
        // print("$userEmail+$userImageUrl+$username");
      } else {
        final authResult = await auth.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        userId = authResult.user!.uid;

        final ref = FirebaseStorage.instance
            .ref()
            .child(AppConstants.userImage)
            .child('${userId!}.png');
        await ref.putFile(userImageFile!);

        imageUrl = await ref.getDownloadURL();
        userData[AppConstants.imageUrl] = imageUrl;

        await FirebaseFirestore.instance
            .collection(AppConstants.users)
            .doc(authResult.user!.uid)
            .set(userData);

        await FirebaseFirestore.instance
            .collection(AppConstants.userEmails)
            .doc(email)
            .set({
          AppConstants.userId: userId,
        });

        userEmail = userData![AppConstants.email];
        fName = userData[AppConstants.fName];
        lName = userData[AppConstants.lName];
        about = userData[AppConstants.about];
        address = userData[AppConstants.address];
        profession = userData[AppConstants.profession];
        socialMediaLinks = userData[AppConstants.socialMediaLinks];
        techSkills = userData[AppConstants.techSkills];
        // sharedPreferences.setString("userId", userId!);
        // sharedPreferences.setString("email", email);
        // sharedPreferences.setString("image_url", userImageUrl!);
        // sharedPreferences.setString("fName", fName!);
        // sharedPreferences.setString("lName", lName!);
      }
    } on FirebaseException catch (err) {
      // print("PlatformException");
      String? message = "An error occured please check your credentials!";
      if (err.message != null) {
        message = err.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (err) {
      print(err);
    }
  }

  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).colorScheme.error,
          content: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(err.toString()),
          )));
      rethrow;
    }
  }

  Future<void> updateImage(File imageFile, String userId) async {
    // print("updating image");
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child(AppConstants.userImage)
          .child("$userId.png");
      await storageRef.delete();

      await storageRef.putFile(imageFile);

      imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection(AppConstants.users)
          .doc(userId)
          .update({
        AppConstants.imageUrl: imageUrl,
      });
    } catch (err) {
      rethrow;
    }
  }
}
