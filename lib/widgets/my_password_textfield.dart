import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          color: Colors.grey[500],
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white12),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white12),
          borderRadius: BorderRadius.circular(14),
        ),
        fillColor: Colors.white10,
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
                  color: Colors.grey[600],
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
                  color: Colors.grey[600],
                ),
              ),
      ),
      obscureText: hidePassword,
    );
  }
}
