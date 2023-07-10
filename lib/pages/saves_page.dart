import 'package:flutter/material.dart';
import 'package:globe/generated/l10n.dart';
import 'package:lottie/lottie.dart';

class SavesPage extends StatefulWidget {
  const SavesPage({
    super.key,
  });

  @override
  State<SavesPage> createState() => _SavesPageState();
}

class _SavesPageState extends State<SavesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(S.of(context).saved_posts),
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
