import 'package:globe/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Lottie.asset(
          'assets/settings.json',
          height: 350,
          width: 350,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
