import 'package:flutter/material.dart';
import 'package:globe/constants.dart';

class HomeHeaderItem extends StatelessWidget {
  const HomeHeaderItem(
      {super.key, required this.count, required this.something});

  final String count;
  final String something;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: white1,
      ),
      child: Column(
        children: [
          // count
          Text(
            count,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // something
          Text(
            something,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
