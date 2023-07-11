import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/display_message.dart';
import 'package:globe/helpers/format_count_of_sth.dart';
import 'package:globe/helpers/get_time_from_timestamp.dart';
import 'package:globe/services/comment_service.dart';
import 'package:globe/widgets/comment_item.dart';
import 'package:globe/widgets/my_posttextfield.dart';

class RepliesPage extends StatefulWidget {
  const RepliesPage({
    super.key,
    required this.id,
    required this.index,
  });

  final String id;
  final int index;

  @override
  State<RepliesPage> createState() => _RepliesPageState();
}

class _RepliesPageState extends State<RepliesPage> {
  // get firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get CommentService
  final CommentService _commentService = CommentService();

  // controllers
  TextEditingController replyController = TextEditingController();

  void addNewReply() async {
    try {
      if (replyController.text.isNotEmpty) {
        await _commentService.addComment(
            replyController.text, widget.id, widget.index);
        replyController.clear();
      }
    } catch (e) {
      displayMessage(context, e.toString());
    }
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: // header
            SingleChildScrollView(
              child: StreamBuilder(
                // get current post
                stream: _firestore.collection('posts').doc(widget.id).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(S.of(context).error),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  var posts = snapshot.data!.data() as Map<String, dynamic>;
                  var post = posts['userPosts'][widget.index];

                  List<dynamic> comments = post['replies'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // post time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // time
                          Text(
                            getTimeFromTimeStamp(post['timestamp']),
                            style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                          ),

                          // count of comments
                          Text(
                            '${formatCountOfSth(comments.length)} ${S.of(context).replies}',
                            style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      // post text
                      Text(
                        post['text'],
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                        softWrap: true,
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        height: 2,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      // all replies
                      comments.isEmpty
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 150),
                          child: Text(
                            S.of(context).no_comments,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      )
                          : Container(
                          padding: const EdgeInsets.only(bottom: 80),
                          child: ListView.builder(
                            reverse: true,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: comments.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, ind) {
                              var comment =
                              comments[ind] as Map<String, dynamic>;
                              return Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: CommentItem(
                                  id: widget.id,
                                  displayName: comment['displayName'],
                                  text: comment['text'],
                                  timestamp: comment['timestamp'],
                                ),
                              );
                            },
                          ),
                      ),
                    ],
                  );
                },
              ),
            ),
      ),
      // create new reply
      // add reply textfield and button
      bottomSheet: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: PostTextField(
                controller: replyController,
                hintText: S.of(context).your_comment,
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
                onTap: addNewReply,
                child: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ),
          ],

        ),
      ),
    );
  }
}
