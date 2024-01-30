import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final DateTime chatDateTime;
  final String _message;
  final bool isMe;
  @override
  // final Key? key;
    const MessageBubble(
    this._message,
    this.isMe,
    this.chatDateTime,
    {super.key}
    );

  @override
  Widget build(BuildContext context) {
  String messageSentTime= DateFormat('HH:mm, dd MMM').format(chatDateTime);
    // print(userName);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(!isMe) const SizedBox(width: 5),
            // if(!isMe) CircleAvatar(backgroundImage: NetworkImage(userImage)),
            Container(
              constraints: const BoxConstraints(maxWidth: 270,minWidth: 100),
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
                Theme.of(context).colorScheme.primaryContainer :
                Theme.of(context).colorScheme.outlineVariant,
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   userName,
                  //   style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  //     fontWeight: FontWeight.bold,
                  //   color: Theme.of(context).colorScheme.onSecondary
                  //   ),
                  // ),
                  Text(
                      _message,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface
                      ),                    
                    // textAlign: isMe ? TextAlign.right : TextAlign.left,
                    ),
                  Text(
                    messageSentTime,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            // if(isMe)CircleAvatar(backgroundImage: NetworkImage(userImage)),
            if(isMe) const SizedBox(width: 5),
          ],
        ),
      ],
    );
  }
}