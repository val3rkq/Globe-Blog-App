import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/display_message.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends ChangeNotifier {
  // instances of AUTH and FIRESTORE
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (error) {
      throw (error.code);
    }
  }

  // sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create new doc for new user in firebase
      await _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'email': email,
        'username': '',
        'displayName': '',
        'password': password,
        'friends': [],
        'bio': '',
        'photo': '',
        // getting data when user was online last time
        'status': 'offline',
      });

      // create new collection for history of search in firebase
      await _firebaseFirestore
          .collection('history')
          .doc(userCredential.user!.uid)
          .set({'historySearch': []});

      // create new collection for followers of current user
      await _firebaseFirestore
          .collection('followers')
          .doc(_firebaseAuth.currentUser!.uid)
          .set({'followers': []});

      // create new collection for followings of current user
      await _firebaseFirestore
          .collection('followings')
          .doc(_firebaseAuth.currentUser!.uid)
          .set({'followings': []});

      // create new collection for posts of current user
      await _firebaseFirestore
          .collection('posts')
          .doc(_firebaseAuth.currentUser!.uid)
          .set({
        'userPosts': [],
      });

      return userCredential;
    } on FirebaseAuthException catch (error) {
      throw (error.code);
    }
  }

  // is this user new, or not?
  Future<bool> isNewUser() async {
    QuerySnapshot result = await _firebaseFirestore
        .collection('users')
        .where("email", isEqualTo: _firebaseAuth.currentUser!.email)
        .get();
    final List<DocumentSnapshot> docs = result.docs;
    return docs.isEmpty;
  }

  // check username (it should be individual)
  Future<bool> checkUsername(String username) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;

    QuerySnapshot result = await _firebaseFirestore
        .collection('users')
        .where('username', isEqualTo: username)
        .where('uid', isNotEqualTo: currentUserID)
        .get();

    final List<DocumentSnapshot> docs = result.docs;
    return docs.isEmpty;
  }

  // sign in with google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? gAccount = await googleSignIn.signIn();

      if (gAccount != null) {
        final GoogleSignInAuthentication gAuth = await gAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        // we should check is this user new,
        // this is necessary so that there are no repetitions in FIRESTORE
        final isUserNew = await isNewUser();
        if (isUserNew) {
          // create new doc for new user in firebase
          await _firebaseFirestore
              .collection('users')
              .doc(_firebaseAuth.currentUser!.uid)
              .set(
            {
              'uid': _firebaseAuth.currentUser!.uid,
              'email': gAccount.email,
              'username': '',
              'displayName': gAccount.displayName,
              'password': null,
              'friends': [],
              'bio': '',
              'photo': gAccount.photoUrl,
              // getting data when user was online last time
              'status': 'online',
            },
          );

          // create new collection for history of search in firebase
          await _firebaseFirestore
              .collection('history')
              .doc(_firebaseAuth.currentUser!.uid)
              .set({'historySearch': []});

          // create new collection for followers of current user
          await _firebaseFirestore
              .collection('followers')
              .doc(_firebaseAuth.currentUser!.uid)
              .set({'followers': []});

          // create new collection for followings of current user
          await _firebaseFirestore
              .collection('followings')
              .doc(_firebaseAuth.currentUser!.uid)
              .set({'followings': []});

          // create new collection for posts of current user
          await _firebaseFirestore
              .collection('posts')
              .doc(_firebaseAuth.currentUser!.uid)
              .set({'userPosts': []});
        }

        return userCredential;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw (e);
    }
  }

  // set / update user data
  Future<void> setUsernameAndBio(
      String username, String displayName, String bio) async {
    try {
      // create new doc for new user in firebase
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({
        'username': username.toLowerCase().trim().replaceAll(' ', '_'),
        'displayName': displayName,
        'bio': bio,
        'status': 'online'
      });
    } on FirebaseAuthException catch (error) {
      throw (error.code);
    }
  }

  // upload image to firebase storage
  Future<String> uploadImageToStorage(File image) async {
    //Create a reference to the location you want to upload to in firebase
    Reference reference =
        _storage.ref().child("profileImage/${_firebaseAuth.currentUser!.uid}");

    // Upload the image file to Firebase Storage
    await reference.putFile(image);

    // Get the download url
    String photoURL = await reference.getDownloadURL();
    return photoURL;
  }

  // set / update user photo
  Future<void> setPhoto(File photo) async {
    try {
      String imageURL = await uploadImageToStorage(photo);

      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({
        'photo': imageURL,
      });
    } on FirebaseAuthException catch (error) {
      throw (error.code);
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _firebaseFirestore
          .collection('users')
          .doc(_firebaseAuth.currentUser!.uid)
          .update({
        'status': 'offline',
        'lastOnline': Timestamp.now(),
      });

      // sign out with firebase
      await _firebaseAuth.signOut();
      // sign out with google
      await GoogleSignIn().signOut();
    } catch (e) {
      print(e);
    }
  }

  // reset password
  Future<void> resetPassword(BuildContext context, String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      displayMessage(context, S.of(context).password_sent);
      Navigator.pop(context);
    } catch (e) {
      displayMessage(context, e.toString());
    }
  }
}
