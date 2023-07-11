import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:globe/constants.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/display_message.dart';
import 'package:globe/helpers/scroll_to_bottom.dart';
import 'package:globe/pages/replies_page.dart';
import 'package:globe/services/post_service.dart';
import 'package:globe/widgets/my_posttextfield.dart';
import 'package:globe/widgets/post_item.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // get the AUTH and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get the PostService
  final PostService _postService = PostService();

  // it will prevent to scroll the scaffold in setState time
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrollKey = GlobalKey();

  // controllers
  TextEditingController postController = TextEditingController();

  bool editMode = false;
  int indexToEdit = -1;

  // set status and update timestamp when user is online
  // this will be used for showing when some user was online last time
  void setStatus(String status) async {
    if (status == 'offline') {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'status': status,
        'lastOnline': Timestamp.now(),
      });
    } else {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'status': status,
      });
    }
  }

  // add new post
  void addNewPost() async {
    try {
      if (postController.text.isNotEmpty) {
        await _postService.addPost(postController.text);
        postController.clear();
      }
    } catch (e) {
      displayMessage(context, e.toString());
    }

    setState(() {
      editMode = false;
      indexToEdit = -1;
    });
  }

  // edit post with current index
  void editPost(int index) async {
    try {
      if (postController.text.isNotEmpty) {
        await _postService.editPost(index, postController.text);
        postController.clear();

        // hide keyboard
        FocusManager.instance.primaryFocus?.unfocus();

        displayMessage(context, S.of(context).successfully_edited);
      }
    } catch (e) {
      displayMessage(context, e.toString());
    }

    setState(() {
      editMode = false;
      indexToEdit = -1;
    });
  }

  // delete post
  void deletePost(int index) async {
    try {
      await _postService.deletePost(index);
      // vibration
      HapticFeedback.vibrate();
    } catch (error) {
      displayMessage(context, error.toString());
    }

    setState(() {
      editMode = false;
      indexToEdit = -1;
    });
  }

  @override
  void initState() {
    super.initState();
    // this is necessary for getting status of user (online or offline)
    WidgetsBinding.instance.addObserver(this);
    setStatus("online");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus('online');
    } else {
      // offline
      setStatus('offline');
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // header (user-info: userName, userPhoto)
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(S.of(context).error));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var user = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Column(
                children: [
                  // header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).welcome,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.grey,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                user['displayName'],
                                style: const TextStyle(
                                  color: CupertinoColors.systemPink,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 23,
                                ),
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // userphoto
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
                        width: 50,
                        height: 50,
                        child: user['photo'].isEmpty
                            ? Center(
                                // show initial of username
                                child: Text(
                                  user['displayName'][0]
                                      .toString()
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 25,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundImage:
                                    Image.network(user['photo']).image,
                              ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // divider
                  const Divider(
                    height: 2,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      // all posts
      body: SingleChildScrollView(
        key: _scrollKey,
        child:
            // print all user's posts
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _firestore
              .collection('posts')
              .doc(_auth.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${S.of(context).error} ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 200),
                child: Text(
                  S.of(context).loading,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }

            // get all posts
            Map<String, dynamic> documentData =
                snapshot.data!.data() as Map<String, dynamic>;
            var posts = documentData['userPosts'];

            if (posts.isEmpty) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 50),
                child: Lottie.asset(
                  'assets/home.json',
                  width: 200,
                  fit: BoxFit.fitWidth,
                ),
              );
            }

            return Container(
              padding: const EdgeInsets.only(bottom: 70),
              child: SlidableAutoCloseBehavior(
                child: ListView.builder(
                  reverse: true,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: posts.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> post = posts[index];
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: PostItem(
                        canDelete: true,
                        post: post,
                        index: index,
                        userID: _auth.currentUser!.uid,
                        onMoreBtnTap: () {
                          onMoreBtnTap(index, post);
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      // create new post
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PostTextField(
                controller: postController,
                hintText: "New post",
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // send post
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white12, shape: BoxShape.circle),
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  if (editMode) {
                    editPost(indexToEdit);
                  } else {
                    addNewPost();
                  }
                },
                child: editMode
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onMoreBtnTap(int index, Map<String, dynamic> post) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 250,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            color: Color(0xFF1C1B1F),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              title: Text(S.of(context).options),
              toolbarHeight: 25,
              leading: const SizedBox(),
              backgroundColor: Colors.transparent,
            ),
            body: Column(
              children: [
                // edit post
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      editMode = true;
                      indexToEdit = index;
                      postController.text = post['text'];
                    });
                  },
                  title: Text(
                    S.of(context).edit,
                    style: const TextStyle(fontSize: 18),
                  ),
                  leading: const Icon(Icons.edit_rounded),
                ),

                // replies of post
                ListTile(
                  onTap: () {
                    Navigator.pop(context);

                    // go to replies page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RepliesPage(
                          id: _auth.currentUser!.uid,
                          index: index,
                        ),
                      ),
                    );
                  },
                  title: Text(
                    S.of(context).all_replies,
                    style: const TextStyle(fontSize: 18),
                  ),
                  leading: const Icon(CupertinoIcons.reply_thick_solid),
                ),

                // delete post
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    deletePost(index);
                  },
                  title: Text(
                    S.of(context).delete,
                    style: const TextStyle(fontSize: 18),
                  ),
                  leading: const Icon(Icons.delete_rounded),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
