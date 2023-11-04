import 'dart:io';

import 'package:chatify2/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this._submitfn,
    this.isLoading,
  );
  final bool isLoading;
  final void Function(
    String? email,
    String? username,
    String? password,
    File? userImage,
    bool isLogin,
    BuildContext ctx,
  ) _submitfn;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  bool isLogin=true;  
  String? _userEmail="";
  String? _userPassword="";
  String? _userName="";
  File? _userImageFile;
  void imagePicker(File? image){
    _userImageFile=image;
  }

  void _trySubmit(){
   final isValid=_formKey.currentState!.validate();
   FocusScope.of(context).unfocus();
    if(_userImageFile==null && !isLogin){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please upload an image!"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),        
      );
      return;
    }
   if(isValid){
    _formKey.currentState!.save();
    widget._submitfn(
      _userEmail!.trim(),
      _userName!.trim(),
      _userPassword!.trim(),
      _userImageFile,
      isLogin,
      context,
    );
   }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
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
                  if(!isLogin)UserImagePicker(imagePicker),
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
                      _userEmail=value;
                    },
                  ),
                  if(!isLogin)
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
                      _userName=value;
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
                      _userPassword=value;
                    },
                  ),
                  const SizedBox(height: 10,),
                  if(widget.isLoading)
                  const CircularProgressIndicator(),
                  if(!widget.isLoading)
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.primaryContainer),
                    ),
                    onPressed: _trySubmit,            
                    child: Text(
                        isLogin ? "  Login  " : "  Signup  ",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        )
                        ),
                    ),
                  if(!widget.isLoading) 
                  TextButton(
                    onPressed: (){
                      setState(() {                     
                      isLogin=!isLogin;
                      });
                    },
                    child: Text(isLogin ? "Create new Account" : "I already have an Account",),
                    ),
              ],)
              ),
          ),
        ),
      ),
    );
  }
}