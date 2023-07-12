import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globe/constants.dart';

class MyPasswordTextField extends StatefulWidget {
  MyPasswordTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onTap,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final void Function()? onTap;

  @override
  State<MyPasswordTextField> createState() => _MyPasswordTextFieldState();
}

class _MyPasswordTextFieldState extends State<MyPasswordTextField> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onTap: widget.onTap,
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
        suffixIcon: hidePassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                icon: Icon(
                  Icons.remove_red_eye,
                  color: grey6,
                ),
              )
            : IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                icon: Icon(
                  CupertinoIcons.eye_slash_fill,
                  color: grey6,
                ),
              ),
      ),
      obscureText: hidePassword,
    );
  }
}
