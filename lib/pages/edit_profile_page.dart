import 'package:globe/auth/auth.dart';
import 'package:globe/helpers/display_message.dart';
import 'package:globe/generated/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:globe/widgets/page_names/for_edit_profile_page.dart';
import 'package:globe/helpers/scroll_to_bottom.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // get AUTH and FIRESTORE instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  // form key for validation
  final _formKey = GlobalKey<FormState>();

  void initControllers() async {
    // get snapshot
    var snapshot =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    var user = snapshot.data() as Map<String, dynamic>;

    usernameController.text = user['username'] ?? '';
    displayNameController.text = user['displayName'] ?? '';
    bioController.text = user['bio'] ?? '';
    emailController.text = user['email'] ?? '';
  }

  // change user-data
  void changeData() async {
    // get snapshot
    var snapshot =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    var user = snapshot.data() as Map<String, dynamic>;

    // get the AUTH service
    final authService = Provider.of<Auth>(context, listen: false);

    // validation
    try {
      if (_formKey.currentState!.validate()) {
        // get info is this username already registered
        bool checkUserName =
            await authService.checkUsername(usernameController.text);

        if (!checkUserName) {
          displayMessage(context, S.of(context).validation_username_is_taken);
        } else {
          user['username'] = usernameController.text;
          user['displayName'] = displayNameController.text;
          user['bio'] = bioController.text;
          user['email'] = emailController.text;

          await _firestore
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .set(user);

          // change email in AUTH-DATA
          await _auth.currentUser!.updateEmail(user['email']);
          Navigator.pop(context);
        }
      }
    } catch (error) {
      displayMessage(context, error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    initControllers();
  }

  @override
  void dispose() {
    usernameController.dispose();
    displayNameController.dispose();
    bioController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(S.of(context).edit_profile),
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.check_rounded,
              ),
              onPressed: changeData,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // username
                MyTextField(
                  controller: usernameController,
                  hintText: S.of(context).username,
                  onTap: null,
                ),

                const SizedBox(
                  height: 15,
                ),

                // displayName
                MyTextField(
                  controller: displayNameController,
                  hintText: S.of(context).displayname,
                  onTap: null,
                ),

                const SizedBox(
                  height: 15,
                ),

                // email
                MyTextField(
                  controller: emailController,
                  hintText: S.of(context).email,
                  onTap: null,
                ),

                const SizedBox(
                  height: 15,
                ),

                // bio
                MyBioTextField(
                  controller: bioController,
                  hintText: S.of(context).bio,
                  onTap: () => scrollToBottom(_scrollController),
                  length: bioController.text.length,
                ),

                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
