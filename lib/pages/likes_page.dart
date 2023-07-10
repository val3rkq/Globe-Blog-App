import 'package:flutter/material.dart';
import 'package:globe/generated/l10n.dart';
import 'package:lottie/lottie.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({
    super.key,
    // required this.likes,
  });

  // final List<dynamic> likes;

  @override
  State<LikesPage> createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(S.of(context).liked_posts),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 150,),

          Lottie.asset(
            'assets/main.json',
            width: 300,
          ),
          Center(
            child: Text(
              S.of(context).developing,
              style: const TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
