import 'package:chatify2/misc/app_constants.dart';
import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/models/project.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProjectScreen extends StatefulWidget {
  const EditProjectScreen({
    required this.projectId,
    required this.projectObj,
    required this.screenTitle,
    super.key,
  });
  final String? projectId;
  final Project projectObj;
  final String screenTitle;
  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  bool isLoading = false;
  final currUserId = FirebaseAuth.instance.currentUser!.uid;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  _trySubmit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      isLoading = true;
    });

    String snackVal = "Project Saved Successfully";
    try {
      final projData = widget.projectObj.toMap();
      final collectionRef = FirebaseFirestore.instance
          .collection(AppConstants.users)
          .doc(currUserId)
          .collection(AppConstants.projects);
      widget.projectId == null
          ? await collectionRef.add(projData)
          : await collectionRef.doc(widget.projectId).update(projData);
      setState(() {
        isLoading = false;
      });
    } catch (err) {
      snackVal = err.toString();
      setState(() {
        isLoading = false;
      });
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(snackVal)));
  }

  @override
  Widget build(BuildContext context) {
    _titleController.text = widget.projectObj.title;
    _descController.text = widget.projectObj.description;
    _linkController.text = widget.projectObj.projectLink;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.screenTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    AppLanguage.projectTitle,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                TextFormField(
                  controller: _titleController,
                  key: const Key(AppLanguage.projectTitle),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length <= 7) {
                      return "Please Enter a Valid Title";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  onSaved: (value) {
                    widget.projectObj.title = value!;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 15),
                  child: Text(
                    AppLanguage.description,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                TextFormField(
                  controller: _descController,
                  key: const Key(AppLanguage.description),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length <= 70) {
                      return "Project Description must be more 70 characters";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: 7,
                  onSaved: (value) {
                    widget.projectObj.description = value!;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 15),
                  child: Text(
                    AppLanguage.projectLink,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                TextFormField(
                  controller: _linkController,
                  key: const Key(AppLanguage.projectLink),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Enter a Valid url";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.url,
                  onSaved: (value) {
                    widget.projectObj.projectLink = value!;
                  },
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: _trySubmit,
                    style: ButtonStyle(
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      ),
                      foregroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                      backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    child: isLoading == false
                        ? const Text(
                            AppLanguage.save,
                            style: TextStyle(fontSize: 20),
                          )
                        : CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
