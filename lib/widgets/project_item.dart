import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectItem extends StatelessWidget {
  ProjectItem({super.key, 
    required this.title,
    required this.description,
    });
  String? title;
  String? description;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         const SizedBox(height: 5,),
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
      ],
    );
  }
}