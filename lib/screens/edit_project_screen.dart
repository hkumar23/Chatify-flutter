import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/models/project.dart';
import 'package:flutter/material.dart';

class EditProjectScreen extends StatelessWidget {
  EditProjectScreen(
      {required this.projectId, required this.projectObj, super.key});
  final String projectId;
  final Project projectObj;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _titleController.text = projectObj.title;
    _descController.text = projectObj.description;
    _linkController.text = projectObj.projectLink;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Project",
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
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 15),
                  child: ElevatedButton(
                    onPressed: () {},
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
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 20),
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
