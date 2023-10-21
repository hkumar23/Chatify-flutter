import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.pickImagefn);
  final void Function(File? pickedImage) pickImagefn;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImage;
  void _pickImage() async {
    final ImagePicker _picker=ImagePicker();
    final XFile? image=await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
      );
    setState(() {
      pickedImage=File(image!.path);
    });
    widget.pickImagefn(pickedImage);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Column(
        children: [
          Container(          
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [BoxShadow(
                offset: Offset(0, 2),
                color: Colors.blueGrey,
                blurRadius: 7,
                )]
            ),
            child:CircleAvatar(
                      radius: 50,
                      // backgroundColor: Colors.grey,
                      backgroundImage: 
                      pickedImage!=null ? 
                      FileImage(pickedImage!) : 
                      NetworkImage("https://images.nightcafe.studio//assets/profile.png?tr=w-640,c-at_max") as ImageProvider,
                    ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Icon(
              Icons.image,
              color: Theme.of(context).colorScheme.primary,
              ),
            const SizedBox(width: 2),
            Text(
              "Add Image",
              style:
              TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          )
        ],
      ),
    );
  }
}