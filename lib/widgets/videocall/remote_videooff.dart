import 'dart:ui';

import 'package:chatify2/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemoteVideoOff extends StatelessWidget {
  const RemoteVideoOff({super.key});
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);
    print(Provider.of<Auth>(context).imageUrl);
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(height: 50,),
          CircleAvatar(
            backgroundImage: NetworkImage(auth.imageUrl!),
            radius: 100,          
          ),
          const SizedBox(height: 10,),
          Text(
            "On Call With",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onTertiaryContainer
            ),            
            ),
          // const SizedBox(height: 5,),
          Text(
            auth.fName!,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontWeight: FontWeight.w500
            ),            
            ),
          const SizedBox(height: 120,),
        ],
      )
    );
  }
}