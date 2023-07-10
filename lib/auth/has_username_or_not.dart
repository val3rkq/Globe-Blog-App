// import 'package:globe/navigation_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/navigation_view.dart';

import '../pages/auth_pages/username_page.dart';

class HasUsernameOrNot extends StatefulWidget {
  const HasUsernameOrNot({super.key});

  @override
  State<HasUsernameOrNot> createState() => _HasUsernameOrNotState();
}

class _HasUsernameOrNotState extends State<HasUsernameOrNot> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {

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

        if (snapshot.data!.data()!['username'] == '') {
          // user doesn't have any username
          return const UsernamePage();
        }
        // user has some username
        return const NavigationView();
      },
    );
  }
}