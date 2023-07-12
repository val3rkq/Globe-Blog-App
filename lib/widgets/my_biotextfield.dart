import 'package:globe/constants.dart';
import 'package:globe/helpers/scroll_to_bottom.dart';
import 'package:flutter/material.dart';

class MyBioTextField extends StatefulWidget {
  const MyBioTextField(
      {required this.controller,
      required this.hintText,
      required this.onTap,
      required this.length,
      super.key});

  final TextEditingController controller;
  final String hintText;
  final void Function()? onTap;
  final int length;

  @override
  State<MyBioTextField> createState() => _MyBioTextFieldState();
}

class _MyBioTextFieldState extends State<MyBioTextField> {
  // length of bio textfield
  int? _bioLength;

  @override
  void initState() {
    super.initState();
    // set _bioLength
    setState(() {
      _bioLength = widget.length;
    });

  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onTap: widget.onTap,
      onChanged: (value) {
        setState(() {
          _bioLength = value.length;
        });
      },
      maxLines: 10,
      maxLength: 300,
      decoration: InputDecoration(
        counterText: '$_bioLength / 300',
        counterStyle: TextStyle(
          color: grey,
        ),
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
      ),
    );
  }
}
