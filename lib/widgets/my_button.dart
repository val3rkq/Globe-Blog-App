import 'package:flutter/material.dart';
import 'package:globe/constants.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 25, 0, 0),
        padding: EdgeInsets.all(25),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        decoration: BoxDecoration(
          color: black,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
