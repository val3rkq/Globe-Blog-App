import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globe/models/post_model.dart';

class PostService extends ChangeNotifier {
  // get instances of AUTH and Firestore
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // add new post
  Future<void> addPost(String text) async {
    // create new post
    Post newPost = Post(
      text: text,
      timestamp: Timestamp.now(),
      likes: [],
      replies: [],
      saves: [],
    );

    // get user posts
    List<dynamic> userPosts = await getPosts(_auth.currentUser!.uid);

    // add new post in array
    userPosts.add(newPost.toMap());

    // update DB
    await _firestore.collection('posts').doc(_auth.currentUser!.uid).update(
      {
        'userPosts': userPosts,
      },
    );
  }

  // get user posts
  Future<List<dynamic>> getPosts(String id) async {
    // get document
    var document = await _firestore.collection('posts').doc(id).get();
    Map<String, dynamic> documentData = document.data() as Map<String, dynamic>;

    List<dynamic> userPosts = documentData['userPosts'];
    return userPosts;
  }

  // get post by index
  Future<Map<String, dynamic>> getPostByIndex(int index, String id) async {
    var document = await _firestore.collection('posts').doc(id).get();
    Map<String, dynamic> documentData = document.data() as Map<String, dynamic>;

    List<dynamic> userPosts = documentData['userPosts'];
    return userPosts[index];
  }

  // edit post
  Future<void> editPost(int index, String text) async {
    // get user posts
    List<dynamic> userPosts = await getPosts(_auth.currentUser!.uid);

    // update post with current index
    userPosts[index] = text;

    // update DB
    await _firestore.collection('posts').doc(_auth.currentUser!.uid).update(
      {
        'userPosts': userPosts,
      },
    );
  }

  // delete post
  Future<void> deletePost(int index) async {
    // get user posts
    List<dynamic> userPosts = await getPosts(_auth.currentUser!.uid);

    // remove post from array by index
    userPosts.removeAt(index);

    // update DB
    await _firestore.collection('posts').doc(_auth.currentUser!.uid).update(
      {
        'userPosts': userPosts,
      },
    );
  }

  // like post
  Future<void> likePost(int index, String id) async {
    // get posts
    var posts = await getPosts(id);

    // get likes list
    List<dynamic> likes = posts[index]['likes'];

    // check is post already liked
    // if post isn't liked, we should add it to collection likes
    if (!likes.contains(_auth.currentUser!.uid)) {
      posts[index]['likes'].add(_auth.currentUser!.uid);
    } else {
      posts[index]['likes'].remove(_auth.currentUser!.uid);
    }

    // update DB
    await _firestore.collection('posts').doc(id).update(
      {
        'userPosts': posts,
      },
    );
  }

  // save post
  Future<void> savePost(int index, String id) async {
    // get posts
    var posts = await getPosts(id);

    // get likes list
    List<dynamic> saves = posts[index]['saves'];

    // check is post already liked
    // if post isn't liked, we should add it to collection likes
    if (!saves.contains(_auth.currentUser!.uid)) {
      posts[index]['saves'].add(_auth.currentUser!.uid);
    } else {
      posts[index]['saves'].remove(_auth.currentUser!.uid);
    }

    // update DB
    await _firestore.collection('posts').doc(id).update(
      {
        'userPosts': posts,
      },
    );
  }

}
