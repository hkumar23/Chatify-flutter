import 'package:chatify2/misc/app_constants.dart';

class Project {
  String title;
  String description;
  String projectLink;

  Project({
    required this.title,
    required this.description,
    required this.projectLink,
  });

  Map<String, dynamic> toMap() {
    return {
      AppConstants.title: title,
      AppConstants.description: description,
      AppConstants.projectLink: projectLink,
    };
  }

  factory Project.fromMap(Map json) {
    return Project(
        title: json[AppConstants.title],
        description: json[AppConstants.description],
        projectLink: json[AppConstants.projectLink]);
  }
}
