import 'package:flutter/material.dart';

class ContactItem extends StatelessWidget {
  const ContactItem({super.key, 
    required this.imageUrl,
    required this.userName,
    required this.userEmail,
    required this.navigateToChat,
  });
  final String imageUrl;
  final String userName;
  final String userEmail;
  final void Function() navigateToChat;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
                // height: 70,
                width: double.infinity,
                // margin: const EdgeInsets.only(top: 5),
                // decoration: BoxDecoration(
                //   border: Border.all(color: Theme.of(context).colorScheme.onBackground),
                //   borderRadius: BorderRadius.circular(12)),
                  child: GestureDetector(                    
                    onTap: navigateToChat,
                    child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                          imageUrl,
                          ),
                        ),
                        title: Text(
                          userName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          userEmail,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      // horizontalTitleGap: 30,
                      ),
                  ),
              );
  }
}