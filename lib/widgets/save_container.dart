import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MySavesContainer extends StatelessWidget {
  const MySavesContainer({super.key, required this.count, required this.isReplies});

  final int count;
  final bool isReplies;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 20, left: 20),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        decoration: BoxDecoration(
          // color: Colors.white10,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 30,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Icon(
                isReplies
                    ? CupertinoIcons.reply_thick_solid
                    : Icons.bookmarks_rounded,
                color: Colors.grey,
                size: 30,
              ),
            ],
          ),
        ),
    );
  }
}
