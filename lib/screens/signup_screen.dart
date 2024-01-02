import 'dart:io';

import 'package:chatify2/providers/auth.dart';
import 'package:chatify2/screens/home_screen.dart';
import 'package:chatify2/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const routeName='/signup-screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey=GlobalKey<FormState>();
  // final _passwordController=TextEditingController();

  File? userImageFile;
  String? userEmail;
  String? userName;
  String? userPassword;
  bool isLoading=false;

  void imagePicker(File? image){
    userImageFile=image;
  }

  void _trySubmit() async {
    FocusScope.of(context).unfocus();
    if(userImageFile==null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please upload an image!"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),        
      );
      return;
    }
    if(!_formKey.currentState!.validate()){
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      isLoading=true;
    });
    try{
      await Provider.of<Auth>(context,listen: false).authenticate(
        context: context, 
        username: userName,
        email: userEmail, 
        password: userPassword,
        image: userImageFile,
        isLogin: false,
      );
      setState(() {
        isLoading=false;
      });
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } catch(err) {
      debugPrint("Error Occured: $err");
      setState(() {
        isLoading=false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserImagePicker(imagePicker),
                  TextFormField(
                    key: const Key("email"),
                    validator: (value){
                      if(value!.isEmpty || !value.contains("@")){
                      return "Please enter a valid email address.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(label: Text("Email Address")),
                    onSaved: (value){
                      userEmail=value;
                    },
                  ),
                  TextFormField(
                    key: const Key("username"),
                    validator: (value){
                      if(value!.isEmpty || value.length<4){
                        return "Please enter atleast 4 characters.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(label: Text("Username")),
                    onSaved: (value){
                      userName=value;
                    },
                  ),
                  TextFormField(
                    key: const Key("password"),
                    validator: (value){
                      if(value!.isEmpty || value.length<7){
                      return "Password must be atleast 7 characters long.";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(label: Text("Password")),
                    onSaved: (value){
                      userPassword=value;
                    },
                  ),
                  const SizedBox(height: 10,),
                  if(isLoading)
                  const CircularProgressIndicator(),
                  if(!isLoading)
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primaryContainer),
                    ),
                    onPressed:_trySubmit,          
                    child: Text(
                        "  Signup  ",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        )
                        ),
                    ),
                  if(!isLoading) 
                  TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: const Text("I already have an Account",),
                    ),
              ],)
              ),
          ),
        ),
      ),
    ),
    );
  }
}