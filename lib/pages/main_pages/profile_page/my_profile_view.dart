import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:globe/auth/auth.dart';
import 'package:globe/constants.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/display_message.dart';
import 'package:globe/helpers/format_count_of_sth.dart';
import 'package:globe/helpers/when_user_was_online.dart';
import 'package:globe/pages/edit_profile_page.dart';
import 'package:globe/pages/followers_page.dart';
import 'package:globe/pages/followings_page.dart';
import 'package:globe/pages/likes_page.dart';
import 'package:globe/pages/saves_page.dart';
import 'package:globe/pages/settings_page.dart';
import 'package:globe/widgets/home_header_item.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  // get AUTH and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // photo of profile
  String photo = '';
  File? imageFile;

  // upload image
  void uploadProfileImage() async {
    await pickImage();

    if (imageFile != null) {
      // get the AUTH service
      final authService = Provider.of<Auth>(context, listen: false);

      authService.setPhoto(imageFile!);
    }

  }

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(imageFile: img);
      setState(() {
        imageFile = img;
      });
      // Navigator.pop(context);
    } on PlatformException catch (e) {
      displayMessage(context, e.toString());
      // Navigator.pop(context);
    }
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

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

  // sign out
  void signOut() async {
    // get the AUTH service
    final authService = Provider.of<Auth>(context, listen: false);

    try {
      await authService.signOut();
    } catch (error) {
      displayMessage(context, error.toString()); 
    }
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

        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            // extendBody: true,
            appBar: AppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              centerTitle: true,
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
                icon: const Icon(Icons.settings_rounded),
                onPressed: () {
                  // move to settings page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () {
                    // go to edit profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SafeArea(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // header container with userphoto
                      GestureDetector(
                        onTap: uploadProfileImage,
                        child: Container(
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
                          width: 150,
                          height: 150,
                          child: user['photo'].isEmpty
                              ? const Center(
                                  child: Icon(
                                    CupertinoIcons.camera_fill,
                                    color: Colors.white54,
                                    size: 80,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      Image.network(user['photo']).image,
                                ),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      // username
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
                        height: 8,
                      ),

                      // bio
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          user['bio'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          height: 1,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // count of posts, followers, following
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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

                      const SizedBox(
                        height: 10,
                      ),

                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              onTap: () {
                                // go to saves page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SavesPage(),
                                  ),
                                );
                              },
                              title: Text(S.of(context).saved_posts),
                              leading: const Icon(Icons.bookmarks_rounded),
                            ),

                            ListTile(
                              onTap: () {
                                // go to likes page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LikesPage(),
                                  ),
                                );
                              },
                              title: Text(S.of(context).liked_posts),
                              leading: const Icon(CupertinoIcons.heart_solid),
                            ),

                            // sign out button
                            GestureDetector(
                              onTap: signOut,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 20),
                                child: Row(
                                  children: [
                                    Text(
                                      S.of(context).log_out,
                                      style: TextStyle(
                                        color: mainColor,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      CupertinoIcons.square_arrow_right,
                                      size: 25,
                                      color: mainColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
