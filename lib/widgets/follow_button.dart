import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globe/constants.dart';
import 'package:globe/services/user_service.dart';

class FollowBtn extends StatefulWidget {
  const FollowBtn({super.key, required this.id});

  final String id;

  @override
  State<FollowBtn> createState() => _FollowBtnState();
}

class _FollowBtnState extends State<FollowBtn> {
  // instances of firestore and AUTH
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  // get user service
  final UserService _userService = UserService();

  bool isFollowed = false;

  void isUserFollowed() async {
    var doc = await _firestore
        .collection('followings')
        .doc(_auth.currentUser!.uid)
        .get();
    List<dynamic> followings = doc.data()!['followings'];
    setState(() {
      // if this user @ contains in followersList our current user,
      // it means that current user already followed
      isFollowed = followings.contains(widget.id);
    });
  }

  @override
  void initState() {
    super.initState();
    // get info is current user already followed on user with this @
    isUserFollowed();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (isFollowed) {
          _userService.unfollow(widget.id);
          setState(() {
            isFollowed = false;
          });
        } else {
          _userService.follow(widget.id);
          setState(() {
            isFollowed = true;
          });
        }
      },
      icon: isFollowed
          ? Icon(
              CupertinoIcons.minus_circle,
              size: 27,
              color: red,
            )
          : Icon(
              CupertinoIcons.add_circled,
              size: 27,
              color: green,
            ),
    );
  }
}
