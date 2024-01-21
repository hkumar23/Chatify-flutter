import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class UploadImageBox extends StatelessWidget {
  const UploadImageBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.only(top: 5),
              child: DottedBorder(        
                color: Theme.of(context).colorScheme.primary.withOpacity(0.7),                                     
                dashPattern: const [8,6],
                strokeWidth: 2,
                borderType: BorderType.RRect,       
                radius: const Radius.circular(20),                                   
                child: Container(
                  height: 150,
                  alignment: Alignment.center,                                                  
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [                     
                      SizedBox(
                        height: 120,
                        width: 120,
                        // padding: const EdgeInsets.all(15),
                        child: Image.asset("assets/images/Upload-PNG-Image-File.png"),
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: const Text(
                          "Upload New Image",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
              ),
            );
  }
}