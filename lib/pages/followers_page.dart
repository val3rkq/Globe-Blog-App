import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/when_user_was_online.dart';
import 'package:globe/pages/main_pages/profile_page.dart';
import 'package:globe/widgets/no_users.dart';
import 'package:globe/widgets/search_tile.dart';
import 'package:globe/widgets/user_tile.dart';

class FollowersPage extends StatefulWidget {
  const FollowersPage({super.key, required this.id});

  final String id;

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).followers),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: StreamBuilder(
            stream:
                _firestore.collection('followers').doc(widget.id).snapshots(),
            builder: (context, snapshotFollowers) {
              if (snapshotFollowers.hasError) {
                return Center(
                  child: Text(S.of(context).error),
                );
              }

              if (snapshotFollowers.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              }

              var document =
                  snapshotFollowers.data!.data() as Map<String, dynamic>;
              var listFollowers = document['followers'] as List<dynamic>;

              if (listFollowers.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 250),
                  child: NoUsers(context: context, users: S.of(context).followers),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listFollowers.length,
                itemBuilder: (context, index) {
                  return StreamBuilder(
                    stream: _firestore
                        .collection('users')
                        .doc(listFollowers[index])
                        .snapshots(),
                    builder: (context, snapshotUser) {
                      if (snapshotUser.hasError) {
                        return Center(
                          child: Text(S.of(context).error),
                        );
                      }

                      if (snapshotUser.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      }

                      var userDocument =
                          snapshotUser.data!.data() as Map<String, dynamic>;

                      return UserTile(
                        title: userDocument['username'],
                        subtitle: userDocument['status'] == 'online'
                            ? 'online'
                            : whenUserWasOnline(userDocument['lastOnline']),
                        onTap: () {
                          // go to chat page with this person
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                userId: listFollowers[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
