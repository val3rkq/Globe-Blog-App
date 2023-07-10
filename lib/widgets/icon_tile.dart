import 'package:globe/constants.dart';
import 'package:flutter/material.dart';

class IconTile extends StatelessWidget {
  const IconTile({super.key, required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white12)
      ),
      child: Image.asset(asset, height: 35),
    );
  }
}
