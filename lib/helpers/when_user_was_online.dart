import 'package:cloud_firestore/cloud_firestore.dart';

String whenUserWasOnline(Timestamp timestamp) {
  DateTime lastOnline = DateTime.parse(timestamp.toDate().toString());

  DateTime now = DateTime.now();
  Duration difference = now.difference(lastOnline);

  if (difference.inDays > 0) {
    return '${difference.inDays} day(s) ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour(s) ago';
  } else {
    return '${difference.inMinutes} minute(s) ago';
  }
}
