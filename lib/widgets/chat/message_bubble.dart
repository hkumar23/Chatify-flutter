import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
    MessageBubble(
    this._message,
    this.isMe,
    this.userImage,
    this.userName,
    {this.key}
    );
  final String userImage;
  final String userName;
  final String _message;
  final bool isMe;
  final Key? key;
  @override
  Widget build(BuildContext context) {
    // print(userName);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(!isMe) const SizedBox(width: 5),
            if(!isMe) CircleAvatar(backgroundImage: NetworkImage(userImage)),
            Container(
              constraints: const BoxConstraints(maxWidth: 240,minWidth: 40),
              margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              // width: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: !isMe ? const Radius.circular(0) : const Radius.circular(12),
                  topRight: isMe ? const Radius.circular(0) : const Radius.circular(12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                  ),
                color: isMe ?
                Theme.of(context).colorScheme.primary :
                Theme.of(context).colorScheme.secondary,
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onInverseSurface
                    ),
                  ),
                  Text(
                    _message,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onInverseSurface
                    ),                    
                    // textAlign: isMe ? TextAlign.right : TextAlign.left,
                    ),
                ],
              ),
            ),
            if(isMe)CircleAvatar(backgroundImage: NetworkImage(userImage)),
            if(isMe) const SizedBox(width: 5),
          ],
        ),
      ],
    );
  }
}