import 'dart:io';

import 'package:chatify2/providers/auth.dart';
import 'package:chatify2/screens/home_screen.dart';
import 'package:chatify2/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
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
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
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
                              key: const Key("fName"),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 4) {
                                  return "Please enter atleast 4 characters.";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                label: Text("First Name*"),
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) {
                                _formData["fName"] = value!.trim();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              key: const Key("lName"),
                              validator: (value) {
                                if (value!.isEmpty || value.length < 4) {
                                  return "Please enter atleast 4 characters.";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                label: Text("Last Name*"),
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) {
                                _formData["lName"] = value!.trim();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        key: const Key("email"),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains("@")) {
                            return "Please enter a valid email address.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Email Address*"),
                        ),
                        onSaved: (value) {
                          _formData["email"] = value!.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        key: const Key("about"),
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          label: Text("About Me"),
                          hintText: "Share a bit about yourself...",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _formData["about"] = value!.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        key: const Key("profession"),
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          label: Text("Profession"),
                          hintText: "Software Engineer / Student etc.",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _formData["profession"] = value!.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        key: const Key("techSkills"),
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          label: Text("Technical Skills"),
                          hintText: "Enter by separated commas",
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) {
                          _formData["techSkills"] = value!.trim();
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
                                  key: const Key("street"),
                                  // validator: (value){
                                  //   if(value!.isEmpty || value.length<4){
                                  //     return "Please enter atleast 4 characters.";
                                  //   }
                                  //   return null;
                                  // },
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    label: Text("Street"),
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _formData["address"]["street"] =
                                        value!.trim();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  key: const Key("city"),
                                  // validator: (value){
                                  //   if(value!.isEmpty || value.length<4){
                                  //     return "Please enter atleast 4 characters.";
                                  //   }
                                  //   return null;
                                  // },
                                  keyboardType: TextInputType.name,
                                  decoration: const InputDecoration(
                                    label: Text("City"),
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _formData["address"]["city"] =
                                        value!.trim();
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
                                  key: const Key("state"),
                                  // validator: (value){
                                  //   if(value!.isEmpty || value.length<3){
                                  //     return "Please enter a valid State";
                                  //   }
                                  //   return null;
                                  // },
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    label: Text("State"),
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _formData["address"]["state"] =
                                        value!.trim();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  key: const Key("pincode"),
                                  // validator: (value){
                                  //   if(value!.isEmpty || value.length<3){
                                  //     return "Please enter a valid State";
                                  //   }
                                  //   return null;
                                  // },
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    label: Text("Pincode"),
                                    border: OutlineInputBorder(),
                                  ),
                                  onSaved: (value) {
                                    _formData["address"]["pincode"] =
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
                        key: const Key("password"),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 7) {
                            return "Password must be atleast 7 characters long.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                          label: Text("Password*"),
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
                        key: const Key("Confirm Password"),
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
                          label: Text("Confirm Password*"),
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
                          "  Signup  ",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    if (!isLoading)
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "I already have an Account",
                        ),
                      ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
