import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globe/constants.dart';
import 'package:globe/helpers/get_time_from_timestamp.dart';
import 'package:globe/pages/main_pages/profile_page.dart';

class CommentItem extends StatelessWidget {
  const CommentItem(
      {super.key,
      required this.id,
      required this.text,
      required this.photo,
      required this.timestamp,
      required this.displayName});

  final String id;
  final String text;
  final String photo;
  final String displayName;
  final Timestamp timestamp;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white12)),
        ),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // user
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          userId: id,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // profile image
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: mainColor,
                        ),
                        width: 30,
                        height: 30,
                        child: photo.isEmpty ?
                        Center(
                          child: Text(
                            displayName
                                .toString()
                                .toUpperCase()[0],
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white54),
                          ),
                        ) : CircleAvatar(
                          backgroundImage:
                          Image.network(photo).image,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),

                      Text(
                        displayName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                Text(
                  getTimeFromTimeStamp(timestamp),
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            // text
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
              ),
            )
          ],
        ));
  }
}
