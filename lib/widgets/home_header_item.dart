import 'package:flutter/material.dart';

class HomeHeaderItem extends StatelessWidget {
  const HomeHeaderItem(
      {super.key, required this.count, required this.something});

  final String count;
  final String something;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white10,
      ),
      child: Column(
        children: [
          // count
          Text(
            count,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          // something
          Text(
            something,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
