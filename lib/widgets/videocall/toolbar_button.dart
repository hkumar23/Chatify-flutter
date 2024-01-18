import 'package:flutter/material.dart';

class ToolbarButton extends StatefulWidget {
  ToolbarButton({
    required this.iconOn,
    required this.iconOff,
    required this.isButtonOn,
    required this.onTapFunc,
  });
  IconData iconOn;
  IconData? iconOff;
  var isButtonOn;
  void Function()? onTapFunc;

  @override
  State<ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<ToolbarButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTapFunc,
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: widget.isButtonOn ? Colors.white : Colors.grey,
        ),
        child: Icon(
          widget.isButtonOn?
          widget.iconOn : widget.iconOff,
          size: 22,
          color: Colors.black,
        ),
      ),
    );
  }
}
