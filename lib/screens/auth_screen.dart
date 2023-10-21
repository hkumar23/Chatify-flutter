import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chatify2/widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth=FirebaseAuth.instance;
  UserCredential? authResult;
  bool _isLoading=false;

  void _submitAuthForm(
    String? email,
    String? username,
    String? password,
    File? image,
    bool isLogin,
    BuildContext ctx,
  )async{
    try{
      setState(() {
        _isLoading=true;
      });
      if(isLogin){
        authResult= await _auth.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
      }
      else{
        authResult= await _auth.createUserWithEmailAndPassword(
          email: email!, 
          password: password!,
        );

        final ref=FirebaseStorage.instance.ref().child("user_image").child(authResult!.user!.uid + '.png');
        await ref.putFile(image!);
        
        final url=await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection("users").doc(authResult!.user!.uid).set({
          'email':email,
          'username':username,
          'image_url':url,
        });
      }
    }on FirebaseException catch(err){
      // print("PlatformException");
      setState(() {
        _isLoading=false;
      });
      String? message="An error occured please check your credentials!";
      if(err.message!=null){
        message=err.message;
      }
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message!),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
    } catch(err){
      // print("Others");
      print(err);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: AuthForm(_submitAuthForm,_isLoading),
    );
  }
}