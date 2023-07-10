import 'package:globe/generated/l10n.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onTap,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTap: onTap,
      validator: (value) {
        if (hintText == 'Email') {
          // validation of email
          if (value == null || value.isEmpty) {
            return S.of(context).validation_email_empty;
          }
          if (value.endsWith('@gmail.com') || value.endsWith('@mail.ru')) {
          } else {
            return S.of(context).validation_email;
          }
        } else if (hintText == 'Username') {
          // validation of username
          if (value == null || value.isEmpty) {
            return S.of(context).validation_username_empty;
          }

          if (value.length > 15) {
            return S.of(context).validation_username_too_big;
          }
        } else if (hintText == 'DisplayName') {
          // validation of displayName
          if (value == null || value.isEmpty) {
            return S.of(context).validation_displayname_empty;
          }

          if (value.length > 26) {
            return S.of(context).validation_displayname_too_big;
          }
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
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
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white12),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white12),
          borderRadius: BorderRadius.circular(14),
        ),
        fillColor: Colors.white10,
        filled: true,
      ),
    );
  }
}
