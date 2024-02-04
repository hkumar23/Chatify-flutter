import 'package:chatify2/misc/app_language.dart';
import 'package:chatify2/utils/app_methods.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectItem extends StatelessWidget {
  ProjectItem({
    super.key,
    required this.title,
    required this.description,
    required this.projectLink,
  });
  String? title;
  String? description;
  String? projectLink;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          title!,
          style: GoogleFonts.roboto(
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          description!,
          style: GoogleFonts.roboto(
            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: OutlinedButton(
            onPressed: () {
              AppMethods.urlLauncher(projectLink!, context);
            },
            child: Text(
              AppLanguage.openProject,
              style: GoogleFonts.roboto(
                fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
