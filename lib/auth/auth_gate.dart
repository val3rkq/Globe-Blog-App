import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globe/auth/login_or_register.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/pages/main_pages/home_page.dart';

import 'has_username_or_not.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (builder, snapshot) {

          // error
          if (snapshot.hasError) {
            return Center(
              child: Text(S.of(context).error),
            );
          }

          // waiting
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return const HasUsernameOrNot();
          } else {
            // user is not logged in
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
