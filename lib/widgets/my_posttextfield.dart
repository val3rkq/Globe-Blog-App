import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globe/constants.dart';

class PostTextField extends StatefulWidget {
  const PostTextField({
    Key? key,
    required this.controller,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;

  @override
  State<PostTextField> createState() => _PostTextFieldState();
}

class _PostTextFieldState extends State<PostTextField> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.newline,
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: whiteX),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: whiteX),
          borderRadius: BorderRadius.circular(14),
        ),
        fillColor: white1,
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.all(15)
      ),
    );
  }
}
