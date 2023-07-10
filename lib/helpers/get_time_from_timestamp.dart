import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String getTimeFromTimeStamp(Timestamp timestamp) {
  List<String> fullTime = DateTime.parse(timestamp.toDate().toString())
      .toString().split(' ');
  String data = fullTime[0];
  String time = fullTime[1].substring(0, 5);

  DateTime now = DateTime.now();
  DateTime currentDate = DateTime(now.year, now.month, now.day);

  if (data == currentDate.toString().split(' ')[0]) {
    // if last message was send today, show only time
    return time;
  } else {
    // else show month, day and time
    String result = '${DateFormat.MMMd().format(DateTime.parse(data)).toString()}, $time';
    return result;
  }
}