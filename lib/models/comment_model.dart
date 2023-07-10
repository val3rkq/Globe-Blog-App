import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userID;
  final String displayName;
  final String text;
  final Timestamp timestamp;

  Comment({
    required this.userID,
    required this.displayName,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'displayName': displayName,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
