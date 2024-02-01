import 'package:chatify2/models/project.dart';
import 'package:chatify2/screens/edit_project_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UserProjectsScreen extends StatelessWidget {
  const UserProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currUserId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Projects"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currUserId)
            .collection("projects")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final userProjects = snapshot.data!.docs;
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.add_circle_outline_rounded),
                  title: Text(
                    "Add New Project",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: userProjects.length,
                  itemBuilder: (context, index) {
                    Project projectObj =
                        Project.fromMap(userProjects[index].data());
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      // padding: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondaryContainer
                              .withOpacity(1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProjectScreen(
                                projectId: userProjects[index].id,
                                projectObj: projectObj,
                              ),
                            ),
                          );
                        },
                        leading: Icon(MdiIcons.textBoxEdit),
                        title: Text(projectObj.title),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
