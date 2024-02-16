import 'package:flutter/material.dart';

class ExpandableCaption extends StatefulWidget {
  const ExpandableCaption({
    required this.caption,
    super.key,
  });
  final String caption;
  @override
  State<ExpandableCaption> createState() => _ExpandableCaptionState();
}

class _ExpandableCaptionState extends State<ExpandableCaption> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Text(
        widget.caption,
        maxLines: isExpanded ? 150 : 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
