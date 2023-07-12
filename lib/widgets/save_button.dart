import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globe/constants.dart';

class SaveBtn extends StatefulWidget {
  const SaveBtn({super.key, required this.isSaved});

  final bool isSaved;

  @override
  State<SaveBtn> createState() => _SaveBtnState();
}

class _SaveBtnState extends State<SaveBtn> {

  @override
  Widget build(BuildContext context) {
    return Icon(
        widget.isSaved ? CupertinoIcons.bookmark_solid : CupertinoIcons.bookmark,
        color: widget.isSaved ? white : grey,
        size: 23,
      );
  }
}
