import 'dart:io';

import 'package:chatify2/misc/appconstants.dart';
import 'package:chatify2/utils/app_methods.dart';
import 'package:flutter/material.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.pickImagefn, {super.key});
  final void Function(File? pickedImage) pickImagefn;
  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? pickedImage;
  void  _selectImage() async {
      pickedImage=await AppMethods.pickImage();
      setState(() {
        widget.pickImagefn(pickedImage);
      });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectImage,
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
                      const NetworkImage(AppConstants.blankProfileImage) as ImageProvider,
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