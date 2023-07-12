import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globe/constants.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/format_count_of_sth.dart';
import 'package:globe/helpers/when_user_was_online.dart';
import 'package:globe/pages/followers_page.dart';
import 'package:globe/pages/followings_page.dart';
import 'package:globe/widgets/page_names/for_my_profile_second_view.dart';


class MyProfileSecondView extends StatefulWidget {
  const MyProfileSecondView({super.key});

  @override
  State<MyProfileSecondView> createState() => _MyProfileSecondViewState();
}

class _MyProfileSecondViewState extends State<MyProfileSecondView> {
  // instances of firestore and AUTH
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isFollowed = false;

  // upload img to profile
  void uploadProfileImage() {}

  // go to page with followers
  void goToFollowersPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowersPage(id: _auth.currentUser!.uid),
      ),
    );
  }

  // go to page with followings
  void goToFollowingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowingsPage(id: _auth.currentUser!.uid),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
              child: Text(
            S.of(context).error,
          ));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var user = snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            toolbarHeight: 45,
            title: SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 1.5),
                    decoration: BoxDecoration(
                      color: user['status'] == 'online'
                          ? Colors.lightGreenAccent
                          : Colors.grey[500],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    user['status'] == 'online'
                        ? user['status']
                        : whenUserWasOnline(user['lastOnline']),
                  ),
                ],
              ),
            ),
            titleTextStyle: TextStyle(
              fontSize: 18,
              color: user['status'] == 'online'
                  ? Colors.lightGreenAccent
                  : Colors.grey[500],
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.arrow_left),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            // header container with userphoto
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    mainColor,
                                    mainColorAccent,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                shape: BoxShape.circle,
                              ),
                              width: 70,
                              height: 70,
                              child: user['photo'].isEmpty ?
                                  Center(
                                    child: Text(
                                      user['displayName']
                                          .toString()
                                          .toUpperCase()[0],
                                      style: const TextStyle(
                                          fontSize: 35, color: Colors.white54),
                                    ),
                                  ) : CircleAvatar(
                                backgroundImage:
                                Image.network(user['photo']).image,
                              ),
                            ),

                            const SizedBox(
                              width: 30,
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // displayName
                                Text(
                                  user['displayName'],
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.grey.shade200,
                                  ),
                                ),

                                // username
                                Text(
                                  user['username'],
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey.shade500,
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                // bio
                                Text(
                                  user['bio'],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          height: 1,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // count of posts, followers, following
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // posts
                            StreamBuilder(
                                stream: _firestore
                                    .collection('posts')
                                    .doc(_auth.currentUser!.uid)
                                    .snapshots(),
                                builder: (context, snapshotPosts) {
                                  if (snapshotPosts.hasError) {
                                    return Center(
                                      child: Text(S.of(context).error),
                                    );
                                  }

                                  if (snapshotPosts.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    );
                                  }

                                  // get posts count
                                  Map<String, dynamic> documentData =
                                      snapshotPosts.data!.data()
                                          as Map<String, dynamic>;
                                  int count = documentData['userPosts'].length;

                                  return HomeHeaderItem(
                                    count: formatCountOfSth(count),
                                    something: S.of(context).posts,
                                  );
                                }),

                            // followers
                            StreamBuilder(
                                stream: _firestore
                                    .collection('followers')
                                    .doc(_auth.currentUser!.uid)
                                    .snapshots(),
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

                                  var document = snapshotFollowers.data!.data()
                                      as Map<String, dynamic>;
                                  int count = document['followers'].length;

                                  return GestureDetector(
                                    onTap: goToFollowersPage,
                                    child: HomeHeaderItem(
                                      count: formatCountOfSth(count),
                                      something: S.of(context).followers,
                                    ),
                                  );
                                }),

                            // followings
                            StreamBuilder(
                                stream: _firestore
                                    .collection('followings')
                                    .doc(_auth.currentUser!.uid)
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

                                  var document = snapshotFollowings.data!.data()
                                      as Map<String, dynamic>;
                                  int count = document['followings'].length;

                                  return GestureDetector(
                                    onTap: goToFollowingsPage,
                                    child: HomeHeaderItem(
                                      count: formatCountOfSth(count),
                                      something: S.of(context).followings,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: StreamBuilder(
                      stream: _firestore
                          .collection('posts')
                          .doc(_auth.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasError) {
                          return Text(
                              '${S.of(context).error} ${snapshot2.error}');
                        }

                        if (snapshot2.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            S.of(context).loading,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }

                        Map<String, dynamic> doc =
                            snapshot2.data!.data() as Map<String, dynamic>;
                        List<dynamic> posts = doc['userPosts'] as List<dynamic>;

                        return ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: PostItem(
                                // there is no more button on this page
                                canDelete: false,
                                post: posts[index],
                                index: index,
                                userID: _auth.currentUser!.uid,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
