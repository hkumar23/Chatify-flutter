import 'dart:io';

import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/screens/home_screen.dart';
import 'package:chatify2/utils/app_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  static const routeName = "/create-post-screen";
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  Future<File> _cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      // aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio4x3,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: Theme.of(context).colorScheme.primaryContainer,
          // toolbarWidgetColor: Theme.of(context).colorScheme.primary,
          // cropGridColor: Theme.of(context).colorScheme.onPrimaryContainer,
          activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
        ),
      ],
    );
    return File(croppedFile!.path);
  }

  final currUserId = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic> postForm = {
    AppConstants.caption: "",
    AppConstants.imageUrl: "",
    AppConstants.likes: [],
    AppConstants.location: "",
    AppConstants.timestamp: "",
    AppConstants.userId: "",
  };

  File? pickedImage;
  File? croppedImage;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    postForm[AppConstants.userId] = currUserId;
    final deviceSize = MediaQuery.of(context).size;
    // void uploadPostImage(File? image,String userId) {
    //   final storageRef =
    //       FirebaseStorage.instance.ref().child(AppConstants.usersPostImages).child(userId);
    // }

    void onLeftTap() async {
      File tempPickedImage = await AppMethods.pickImage(ImageSource.gallery);
      File tempCroppedImage = await _cropImage(tempPickedImage.path);
      setState(() {
        croppedImage = tempCroppedImage;
        pickedImage = croppedImage;
      });
      // print(pickedImage);
    }

    void onRightTap() async {
      File tempPickedImage = await AppMethods.pickImage(ImageSource.camera);
      File tempCroppedImage = await _cropImage(tempPickedImage.path);
      setState(() {
        croppedImage = tempCroppedImage;
        pickedImage = croppedImage;
      });
      // print(pickedImage);
    }

    void trySubmit() async {
      FocusScope.of(context).unfocus();
      if (pickedImage == null) {
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

      String contentVal;
      Color snackBarColor;
      try {
        postForm[AppConstants.timestamp] = Timestamp.now();
        final firebaseRef =
            FirebaseFirestore.instance.collection(AppConstants.posts);
        final postResponse = await firebaseRef.add(postForm);
        final postId = postResponse.id;
        final storageRef = FirebaseStorage.instance
            .ref()
            .child(AppConstants.usersPostImages)
            .child(currUserId)
            .child("$postId.png");
        await storageRef.putFile(pickedImage!);
        postForm[AppConstants.imageUrl] = await storageRef.getDownloadURL();
        await firebaseRef.doc(postId).update(postForm);
        setState(() {
          isLoading = false;
        });
        contentVal = "Posted Successfully!";
        snackBarColor = Theme.of(context).colorScheme.primary;
      } catch (err) {
        contentVal = err.toString();
        snackBarColor = Theme.of(context).colorScheme.error;
        setState(() {
          isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(contentVal),
          backgroundColor: snackBarColor,
        ),
      );
      Navigator.of(context)
          .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
    }

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppLanguage.createNewPost),
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  // height: deviceSize.height * 0.58,
                  width: deviceSize.width,
                  child: pickedImage == null
                      ? Image.network(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSmTQ_4y3lVTEMR9L3V76FtG79sAi-gg6ZrXdHdnwcRB8X8QYf5uKJxo8J37r6B9XuI9ZU&usqp=CAU",
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          pickedImage!,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  right: 20,
                  child: GestureDetector(
                    onTapDown: (details) {
                      double contWidth = deviceSize.width;
                      double tapPosition = details.globalPosition.dx;
                      if (tapPosition < contWidth / 2) {
                        onLeftTap();
                      } else {
                        onRightTap();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      alignment: Alignment.bottomCenter,
                      height: 60,
                      // width: deviceSize.width * 0.9,
                      decoration: BoxDecoration(
                        // border: Border.all(),
                        borderRadius: BorderRadius.circular(50),
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.7),
                      ),
                      child: DottedBorder(
                        strokeWidth: 1.25,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        radius: const Radius.circular(50),
                        dashPattern: const [6, 4],
                        borderType: BorderType.RRect,
                        padding: const EdgeInsets.all(5),
                        child: Row(children: [
                          const Expanded(
                            child: SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(Icons.image),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Upload from gallery",
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          VerticalDivider(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          const Expanded(
                            child: SizedBox(
                              height: 60,
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(Icons.camera_alt),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Capture with camera",
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      key: const Key(AppLanguage.caption),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter some caption";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: Icon(Icons.description),
                        ),
                        border: OutlineInputBorder(),
                        label: Text(AppLanguage.caption),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (value) {
                        postForm[AppConstants.caption] = value!;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      key: const Key(AppLanguage.location),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.place),
                        border: OutlineInputBorder(),
                        label: Text(AppLanguage.location),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        postForm[AppConstants.location] = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: trySubmit,
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.primary),
                foregroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.surface),
                elevation: const MaterialStatePropertyAll(4),
                textStyle: MaterialStatePropertyAll(
                    Theme.of(context).textTheme.headlineSmall),
                padding: const MaterialStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 70, vertical: 10)),
              ),
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.surface,
                    )
                  : const Text(AppLanguage.publish),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
