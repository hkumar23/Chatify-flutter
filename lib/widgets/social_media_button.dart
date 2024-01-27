import 'package:chatify2/utils/app_methods.dart';
import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  const SocialMediaButton({
    required this.link,
    required this.icon,
    super.key});
  final String? link;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return link!="" ? 
    IconButton(
        color: Theme.of(context).colorScheme.onSurface,
        iconSize: 35,        
        onPressed:(){
         AppMethods.urlLauncher(link!, context);
        }, 
        icon: Icon(icon),
      ):
    const SizedBox();
  }
}