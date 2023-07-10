import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserService extends ChangeNotifier {
  // get instances of AUTH and Firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // follow the user
  void follow(String id) async {
    // for this @ - add to followers
    // get document
    var doc = await _firestore.collection('followers').doc(id).get();
    List<dynamic> followers = doc.data()!['followers'];
    // add user
    followers.add(_auth.currentUser!.uid);

    // update DB
    await _firestore.collection('followers').doc(id).update({
      'followers': followers,
    });

    // for current user @ - add to followings
    // get document
    var doc2 = await _firestore
        .collection('followings')
        .doc(_auth.currentUser!.uid)
        .get();
    List<dynamic> followings = doc2.data()!['followings'];
    // add user
    followings.add(id);

    // update DB
    await _firestore
        .collection('followings')
        .doc(_auth.currentUser!.uid)
        .update({
      'followings': followings,
    });
  }

  // unfollow the user
  void unfollow(String id) async {
    // for this @ - remove from followers
    // get document
    var doc = await _firestore.collection('followers').doc(id).get();
    List<dynamic> followers = doc.data()!['followers'];
    // add user
    followers.remove(_auth.currentUser!.uid);

    // update DB
    await _firestore.collection('followers').doc(id).update({
      'followers': followers,
    });

    // for current user @ - remove from followings
    // get document
    var doc2 = await _firestore
        .collection('followings')
        .doc(_auth.currentUser!.uid)
        .get();
    List<dynamic> followings = doc2.data()!['followings'];
    // add user
    followings.remove(id);

    // update DB
    await _firestore
        .collection('followings')
        .doc(_auth.currentUser!.uid)
        .update({
      'followings': followings,
    });
  }

  // isFollower
  Future<bool> isFollower(String otherUserId) async {

    String currentUserId = _auth.currentUser!.uid;

    var docFollowers = await _firestore
        .collection('followers')
        .doc(currentUserId)
        .get();

    return docFollowers.data()!['followers'].contains(otherUserId);
  }

  // isFollowing
  Future<bool> isFollowing(String otherUserId) async {

    String currentUserId = _auth.currentUser!.uid;

    var docFollowings = await _firestore
        .collection('followings')
        .doc(currentUserId)
        .get();
    return docFollowings.data()!['followings'].contains(otherUserId);
  }
}
