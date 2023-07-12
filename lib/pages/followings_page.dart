import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/when_user_was_online.dart';
import 'package:globe/pages/main_pages/profile_page.dart';
import 'package:globe/widgets/page_names/for_follow_pages.dart';

class FollowingsPage extends StatefulWidget {
  const FollowingsPage({super.key, required this.id});

  final String id;

  @override
  State<FollowingsPage> createState() => _FollowingsPageState();
}

class _FollowingsPageState extends State<FollowingsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).followings),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: StreamBuilder(
              stream: _firestore
                  .collection('followings')
                  .doc(widget.id)
                  .snapshots(),
              builder: (context, snapshotFollowings) {
                if (snapshotFollowings.hasError) {
                  return Center(
                    child: Text(S.of(context).error),
                  );
                }

                if (snapshotFollowings.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                }

                var document =
                    snapshotFollowings.data!.data() as Map<String, dynamic>;
                var listFollowings = document['followings'] as List<dynamic>;


                if (listFollowings.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 250),
                    child: NoUsers(context: context, users: S.of(context).followings),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: listFollowings.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                      stream: _firestore
                          .collection('users')
                          .doc(listFollowings[index])
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
                          photo: userDocument['photo'],
                          subtitle: userDocument['status'] == 'online'
                              ? 'online'
                              : whenUserWasOnline(
                              userDocument['lastOnline']),
                          onTap: () {
                            // go to profile page of this person
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  userId: listFollowings[index],
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
