import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globe/constants.dart';

class LikeBtn extends StatefulWidget {
  const LikeBtn({
    super.key,
    required this.isLiked,
  });

  final bool isLiked;

  @override
  State<LikeBtn> createState() => _LikeBtnState();
}

class _LikeBtnState extends State<LikeBtn> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.isLiked ? CupertinoIcons.heart_solid : CupertinoIcons.heart,
      color: widget.isLiked ? mainColor : grey,
      size: 23,
    );
  }
}
