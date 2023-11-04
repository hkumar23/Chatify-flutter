import 'package:flutter/material.dart';

import 'package:chatify2/widgets/chat/new_message.dart';
import 'package:chatify2/widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  static const routeName='/chat-screen';
  ChatScreen(
    this.themeBrightness,
    this.toggleTheme,
    );
  final Brightness themeBrightness;
  final Function() toggleTheme;

  @override
  Widget build(BuildContext context) {
    String userId=ModalRoute.of(context)!.settings.arguments as String;
    // print(userId);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){Navigator.of(context).pop();},
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).colorScheme.onPrimary,
          ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "User Name",
          style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          )
          ),
        actions: [
          IconButton(
            onPressed: toggleTheme, 
            icon: Icon(
              themeBrightness==Brightness.dark ?
               Icons.dark_mode :
               Icons.light_mode,
               ),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ],  
        ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            Expanded(child: Messages(userId)),
            NewMessage(userId),
          ],
        ),
      ),
    );
  }
}
