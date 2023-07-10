import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  // final String id;
  final String text;
  final Timestamp timestamp;
  final List<String> likes;
  final List<String> replies;
  final List<String> saves;

  Post({
    // required this.id,
    required this.likes,
    required this.replies,
    required this.saves,
    required this.text,
    required this.timestamp,
  });

  // convert to a map for firebase
  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'text': text,
      'timestamp': timestamp,
      'likes': likes,
      'replies': replies,
      'saves': saves,
    };
  }
}
