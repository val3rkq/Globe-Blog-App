import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globe/models/comment_model.dart';

class CommentService extends ChangeNotifier {
  // get instances of AUTH and Firestore
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // add new comment
  Future<void> addComment(String text, String userPostID, int postIndex) async {

    // get current user ID
    String currentUserID = _auth.currentUser!.uid;

    // get user displayName
    var doc = await _firestore.collection('users').doc(currentUserID).get();
    Map<String, dynamic> user = doc.data()!;
    String displayName = user['displayName'];

    // create new comment
    Comment newComment = Comment(
      userID: currentUserID,
      displayName: displayName,
      text: text.trim(),
      timestamp: Timestamp.now(),
    );

    // get current post and add in it new comment
    var docPost = await _firestore.collection('posts').doc(userPostID).get();
    List<dynamic> posts = docPost.data()!['userPosts'];
    posts[postIndex]['replies'].add(newComment.toMap());


    // update DB
    await _firestore.collection('posts').doc(userPostID).update(
      {
        'userPosts': posts,
      },
    );
  }

}
