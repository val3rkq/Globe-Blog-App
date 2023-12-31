import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globe/constants.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/display_message.dart';
import 'package:globe/helpers/when_user_was_online.dart';
import 'package:globe/pages/main_pages/profile_page.dart';
import 'package:globe/services/user_service.dart';
import 'package:globe/widgets/page_names/for_find_users_page.dart';

class FindUsersPage extends StatefulWidget {
  const FindUsersPage({Key? key}) : super(key: key);

  @override
  State<FindUsersPage> createState() => _FindUsersPageState();
}

class _FindUsersPageState extends State<FindUsersPage> {
  // controllers
  TextEditingController searchController = TextEditingController();

  // get instances of Firestore and AUTH
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? currentUserId;

  // get result from firebase
  List searchResults = [];

  // get history from firebase
  List historySearch = [];

  // search users
  void searchFromFirebase(String? query) async {
    // print(query);
    if (query != null && query.isNotEmpty && query != ' ') {
      final result = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + 'z')
          .get();

      setState(() {
        searchResults = result.docs.map((e) => e.data()).toList();
      });
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  Future<List<bool>?> getDataAboutUserFollows(String id) async {
    try {
      // get userService
      final UserService userService = UserService();

      bool isFollower = await userService.isFollower(id);
      bool isFollowing = await userService.isFollowing(id);
      return [isFollower, isFollowing];
    } catch (e) {
      displayMessage(context, e.toString());
    }
    return null;
  }

  // add user to historySearch in firebase
  // in parameters we put data of tapped user
  void addUserToHistory(id, username, photo) async {
    Map<String, dynamic> newData = {
      'id': id,
      'username': username,
      'photo': photo,
    };

    int? indexToDelete;

    for (int i = 0; i < historySearch.length; i++) {
      if (historySearch[i]['id'] == newData['id']) {
        indexToDelete = i;
        break;
      }
    }

    // check is there newData already in DB
    if (indexToDelete != null) {
      setState(() {
        historySearch.removeAt(indexToDelete!);
      });
    }
    setState(() {
      historySearch.insert(0, newData);
    });

    // put changes in firebase
    await _firestore.collection('history').doc(currentUserId).set({
      'historySearch': historySearch,
    }, SetOptions(merge: true));
  }

  void deleteUserFromHistory(index, id) async {
    // update historySearch
    setState(() {
      historySearch.removeAt(index);
    });

    // put changes in firebase
    await _firestore.collection('history').doc(currentUserId).set({
      'historySearch': historySearch,
    }, SetOptions(merge: true));
  }

  Future<void> updateHistorySearch() async {
    // get current document
    var snapshot =
        await _firestore.collection('history').doc(currentUserId).get();
    var document = snapshot.data() as Map<String, dynamic>;

    try {
      setState(() {
        historySearch = document['historySearch'];
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        historySearch = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    currentUserId = _auth.currentUser!.uid;
    updateHistorySearch();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          toolbarHeight: 20,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // label
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    S.of(context).find_users_text,
                    style: const TextStyle(fontSize: 25),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // search field
                TextField(
                  controller: searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: (query) {
                    if (query.isNotEmpty) {
                      searchFromFirebase(query);
                    }
                    if (query == '') {
                      setState(() {
                        searchController.clear();
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: S.of(context).search,
                    hintStyle: TextStyle(
                      color: grey,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        setState(() {
                          searchController.clear();
                          searchResults = [];
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: whiteX),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: whiteX),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    fillColor: white1,
                    filled: true,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // print history list or suggested users
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: searchController.text.isEmpty
                      ? ListView.builder(
                          itemCount: historySearch.length,
                          itemBuilder: (context, index) {
                            final id = historySearch[index]['id'];

                            return FutureBuilder(
                              future: getDataAboutUserFollows(id),
                              builder: (context, followerFollowing) {
                                if (followerFollowing.hasError) {
                                  return Center(
                                      child: Text(S.of(context).error));
                                }

                                if (followerFollowing.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                return HistoryTile(
                                  photo: historySearch[index]['photo'] ?? '',
                                  title: historySearch[index]['username'],
                                  isFollower: followerFollowing.data![0],
                                  // this condition is necessary in order not to write both the
                                  // follower and the following at the same time
                                  isFollowing: followerFollowing.data![0]
                                      ? false
                                      : followerFollowing.data![1],
                                  onTap: () {
                                    // go to profile page of this person
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilePage(
                                          userId: historySearch[index]['id'],
                                        ),
                                      ),
                                    );
                                  },
                                  onDelete: () => deleteUserFromHistory(
                                    index,
                                    historySearch[index]['id'],
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : _showSuggestedUsers(),
                ),
                // child: _showSuggestedUsers(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showSuggestedUsers() {
    // print all suggested users without current
    for (int i = 0; i < searchResults.length; i++) {
      if (searchResults[i]['uid'] == _auth.currentUser!.uid) {
        searchResults.removeAt(i);
      }
    }

    return searchResults.isEmpty
        ? UserNotFound(
            context: context,
          )
        : ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final username = searchResults[index]['username'];
              final id = searchResults[index]['uid'];
              final photo = searchResults[index]['photo'];
              final status = searchResults[index]['status'];
              final timestamp = searchResults[index]['lastOnline'];

              return FutureBuilder(
                future: getDataAboutUserFollows(id),
                builder: (context, followerFollowing) {
                  if (followerFollowing.hasError) {
                    return Center(child: Text(S.of(context).error));
                  }

                  if (followerFollowing.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return SearchTile(
                    title: username,
                    photo: photo,
                    subtitle: (status == 'online')
                        ? status
                        : whenUserWasOnline(timestamp),
                    isFollower: followerFollowing.data![0],
                    // this condition is necessary in order not to write both the
                    // follower and the following at the same time
                    isFollowing: followerFollowing.data![0]
                        ? false
                        : followerFollowing.data![1],
                    onTap: () {
                      // save user in history
                      addUserToHistory(id, username, photo);

                      // go to profile page of this person
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            userId: id,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
  }
}
