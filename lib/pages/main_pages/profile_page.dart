import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'profile_page/profile_views.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    this.userId,
  }) : super(key: key);

  final String? userId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // get AUTH and FIRESTORE instances
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userId == null) {
      return const MyProfileView();
    } else if (widget.userId == _auth.currentUser!.uid) {
      return const MyProfileSecondView();
    }
    else {
      return OtherProfileView(id: widget.userId!);
    }
  }
}
