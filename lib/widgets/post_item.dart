import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/display_message.dart';
import 'package:globe/helpers/format_count_of_sth.dart';
import 'package:globe/helpers/get_time_from_timestamp.dart';
import 'package:globe/pages/replies_page.dart';
import 'package:globe/services/post_service.dart';
import 'package:globe/widgets/like_button.dart';
import 'package:globe/widgets/save_button.dart';

class PostItem extends StatefulWidget {
  const PostItem({
    Key? key,
    required this.canDelete,
    required this.post,
    required this.index,
    required this.userID,
    this.onMoreBtnTap,
  }) : super(key: key);

  final bool canDelete;
  final String userID;
  final Map<String, dynamic> post;
  final int index;
  final Function()? onMoreBtnTap;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {

  // get AUTH and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get PostService
  final PostService _postService = PostService();

  // get info about is this post liked or saved by user with widget.userID
  late bool isLiked;
  late bool isSaved;

  bool isPostLikedByCurrentUser() {
    return widget.post['likes'].contains(_auth.currentUser!.uid);
  }

  bool isPostSavedByCurrentUser() {
    return widget.post['saves'].contains(_auth.currentUser!.uid);
  }

  // like or delete from liked posts
  void onLikeTap() {
    setState(() {
      isLiked = !isLiked;
    });
    _postService.likePost(widget.index, widget.userID);
  }

  // save or delete from saved posts
  void onSaveTap() {
    setState(() {
      isSaved = !isSaved;
    });
    _postService.savePost(widget.index, widget.userID);
  }

  // go to replies of current post
  void goToReplies() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepliesPage(
          id: widget.userID,
          index: widget.index,
        ),
      ),
    );
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
  }

  @override
  void initState() {
    super.initState();
    isLiked = isPostLikedByCurrentUser();
    isSaved = isPostSavedByCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      color: Colors.transparent,
          // editNoteIndex == widget.index ? Colors.white38 : Colors.transparent,
      padding: const EdgeInsets.only(right: 5, left: 3.5),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: widget.canDelete ? 0.4 : 0.3,
          motion: const ScrollMotion(),
          children: [
            const SizedBox(
              width: 5,
            ),
            SlidableAction(
              onPressed: (context) {
                // go to replies page
                goToReplies();
              },
              backgroundColor: Colors.red.withOpacity(0.9),
              foregroundColor: Colors.white,
              icon: CupertinoIcons.reply,
              borderRadius: BorderRadius.circular(15),
            ),
            const SizedBox(
              width: 10,
            ),
            widget.canDelete
                ? SlidableAction(
                    onPressed: (context) {
                      deletePost(widget.index);
                    },
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    icon: Icons.delete_rounded,
                    borderRadius: BorderRadius.circular(15),
                  )
                : const SizedBox(),
          ],
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white12)),
          ),
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          padding: const EdgeInsets.fromLTRB(17, 15, 13, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // top
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: widget.canDelete ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                children: [
                  // post text
                  SizedBox(
                    width: 260,
                    child: Text(
                      widget.post['text'],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      softWrap: true,
                    ),
                  ),

                  // other options
                  widget.canDelete ? GestureDetector(
                    // show dropdown menu with these options:
                    // edit, delete, replies
                    onTap: widget.onMoreBtnTap,
                    child: Icon(
                      Icons.more_horiz_rounded,
                      color: Colors.grey[400],
                    ),
                  ) : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // bottom
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // icons
                  SizedBox(
                    width: 85,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // likes
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: onLikeTap,
                              child: LikeBtn(
                                isLiked: isLiked,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              formatCountOfSth(widget.post['likes'].length),
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // saves
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: onSaveTap,
                              child: SaveBtn(isSaved: isSaved),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              formatCountOfSth(widget.post['saves'].length),
                              style: const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),

                  // time
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      getTimeFromTimeStamp(widget.post['timestamp']),
                      style: TextStyle(fontSize: 13, color: Colors.grey[300]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
