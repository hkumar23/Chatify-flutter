import 'dart:io';

import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/providers/auth.dart';
import 'package:chatify2/screens/home_screen.dart';
import 'package:chatify2/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  // String? userEmail;
  // String? userName;
  // String? userPassword;
  File? userImageFile;
  bool isLoading = false;
  final Map<String, dynamic> _formData = {
    "email": "",
    "fName": "",
    "lName": "",
    "imageUrl": "",
    "about": "",
    "address": {
      "state": "",
      "city": "",
      "pincode": "",
      "street": "",
    },
    "profession": "",
    "socialMediaLinks": {
      "github": "",
      "instagram": "",
      "linkedin": "",
      "twitter": "",
    },
    "techSkills": "",
  };

  // void imagePicker(File? image){
  //   print("userImageFile");
  //   userImageFile=image;
  // }

  void _trySubmit() async {
    FocusScope.of(context).unfocus();
    if (userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please upload an image!"),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).authenticate(
        context: context,
        email: _formData["email"] as String,
        password: _passwordController.text,
        userImageFile: userImageFile,
        userData: _formData,
        isLogin: false,
      );
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } catch (err) {
      debugPrint("Error Occured: $err");
      setState(() {
        isLoading = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Text(
              AppLanguage.signUp,
              style: GoogleFonts.montserrat(
                  fontSize: 120,
                  height: 1,
                  color: Colors.black.withOpacity(0.08)),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        UserImagePicker((imageFile) {
                          userImageFile = imageFile;
                          // print("USERIMAGEFILE INITIALISED");
                        }),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  key: const Key(AppConstants.fName),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 4) {
                                      return "Please enter atleast 4 characters.";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    label: Text("${AppLanguage.firstName}*"),
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _formData[AppConstants.fName] =
                                        value!.trim();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  key: const Key(AppConstants.fName),
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 4) {
                                      return "Please enter atleast 4 characters.";
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    label: Text("${AppLanguage.lastName}*"),
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _formData[AppConstants.lName] =
                                        value!.trim();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            key: const Key(AppConstants.email),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return "Please enter a valid email address.";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("${AppLanguage.emailAddress}*"),
                            ),
                            onSaved: (value) {
                              _formData[AppConstants.email] = value!.trim();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            key: const Key(AppConstants.about),
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              label: Text(AppLanguage.aboutMe),
                              hintText: "Share a bit about yourself...",
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              _formData[AppConstants.about] = value!.trim();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            key: const Key(AppConstants.profession),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              label: Text(AppLanguage.profession),
                              hintText: "Software Engineer / Student etc.",
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              _formData[AppConstants.profession] =
                                  value!.trim();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            key: const Key(AppConstants.techSkills),
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              alignLabelWithHint: true,
                              label: Text(AppLanguage.technicalSkills),
                              hintText: "Enter by separated commas",
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              _formData[AppConstants.techSkills] =
                                  value!.trim();
                            },
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Enter Your Address",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      key: const Key(AppConstants.street),
                                      // validator: (value){
                                      //   if(value!.isEmpty || value.length<4){
                                      //     return "Please enter atleast 4 characters.";
                                      //   }
                                      //   return null;
                                      // },
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                        label: Text(AppLanguage.street),
                                        border: OutlineInputBorder(),
                                      ),
                                      onSaved: (value) {
                                        _formData[AppConstants.address]
                                                [AppConstants.street] =
                                            value!.trim();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      key: const Key(AppConstants.city),
                                      // validator: (value){
                                      //   if(value!.isEmpty || value.length<4){
                                      //     return "Please enter atleast 4 characters.";
                                      //   }
                                      //   return null;
                                      // },
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                        label: Text(AppLanguage.city),
                                        border: OutlineInputBorder(),
                                      ),
                                      onSaved: (value) {
                                        _formData[AppConstants.address]
                                            [AppConstants.city] = value!.trim();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      key: const Key(AppConstants.state),
                                      // validator: (value){
                                      //   if(value!.isEmpty || value.length<3){
                                      //     return "Please enter a valid State";
                                      //   }
                                      //   return null;
                                      // },
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        label: Text(AppLanguage.state),
                                        border: OutlineInputBorder(),
                                      ),
                                      onSaved: (value) {
                                        _formData[AppConstants.address]
                                                [AppConstants.state] =
                                            value!.trim();
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      key: const Key(AppConstants.pincode),
                                      // validator: (value){
                                      //   if(value!.isEmpty || value.length<3){
                                      //     return "Please enter a valid State";
                                      //   }
                                      //   return null;
                                      // },
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                        label: Text(AppLanguage.pincode),
                                        border: OutlineInputBorder(),
                                      ),
                                      onSaved: (value) {
                                        _formData[AppConstants.address]
                                                [AppConstants.pincode] =
                                            value!.trim();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            controller: _passwordController,
                            key: const Key(AppLanguage.password),
                            validator: (value) {
                              if (value!.isEmpty || value.length < 7) {
                                return "Password must be atleast 7 characters long.";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: const InputDecoration(
                              label: Text("${AppLanguage.password}*"),
                              border: OutlineInputBorder(),
                            ),
                            // onSaved: (value){
                            //   _passwordController.text=value!;
                            // },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextFormField(
                            key: const Key(AppLanguage.confirmPassword),
                            validator: (value) {
                              if (value!.trim() !=
                                  _passwordController.text.trim()) {
                                // print("value: $value");
                                // print("password: ${_passwordController.text}");
                                return "Password don't match";
                              }
                              // if(value.isEmpty || value.length<7){
                              //   return "Password must be atleast 7 characters long.";
                              // }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: const InputDecoration(
                              label: Text("${AppLanguage.confirmPassword}*"),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (isLoading) const CircularProgressIndicator(),
                        if (!isLoading)
                          ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: const MaterialStatePropertyAll(
                                  Size(double.infinity, 60)),
                              // padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20,horizontal: 50)),
                              foregroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).colorScheme.surface),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
                            ),
                            onPressed: _trySubmit,
                            child: const Text(
                              AppLanguage.signUp,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        // if (!isLoading)
                        //   TextButton(
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //     child: const Text(
                        //       "I already have an Account",
                        //     ),
                        //   ),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
