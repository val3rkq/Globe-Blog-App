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
        counterStyle: const TextStyle(
          color: Colors.grey,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey[500],
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white12),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white12),
          borderRadius: BorderRadius.circular(14),
        ),
        fillColor: Colors.white10,
        filled: true,
      ),
    );
  }
}
