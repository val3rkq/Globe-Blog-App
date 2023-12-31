import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:globe/auth/auth.dart';
import 'package:globe/helpers/display_message.dart';
import 'package:globe/constants.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/scroll_to_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globe/widgets/page_names/for_username_page.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';

class UsernamePage extends StatefulWidget {
  const UsernamePage({
    Key? key,
  }) : super(key: key);

  @override
  State<UsernamePage> createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  // get instances of AUTH and FIRESTORE
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  // form key for validation
  final _formKey = GlobalKey<FormState>();

  // photo of profile
  String photo = '';
  File? imageFile;

  // set username data
  void setUsernameData() async {
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
          await authService.setUsernameAndBio(usernameController.text,
              displayNameController.text, bioController.text);
        }
      }
    } catch (error) {
      displayMessage(context, error.toString());
    }
  }

  // get user data for textfields
  void getUserData() async {
    // get data from firebase
    var doc =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    if (data['displayName'] != '') {
      setState(() {
        displayNameController.text = data['displayName'];
      });
    }
    if (data['username'] != '') {
      setState(() {
        usernameController.text = data['username'];
      });
    }
    if (data['photo'] != null) {
      setState(() {
        photo = data['photo'];
      });
    }
  }

  // upload image
  void uploadProfileImage() async {
    // get img
    await pickImage();

    if (imageFile != null) {
      // get the AUTH service
      final authService = Provider.of<Auth>(context, listen: false);

      // update DB
      await authService.setPhoto(imageFile!);
    }
  }

  // pick the img
  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(imageFile: img);
      setState(() {
        imageFile = img;
      });
    } on PlatformException catch (e) {
      displayMessage(context, e.toString());
    }
  }

  // crop the img
  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  void initState() {
    super.initState();
    getUserData();
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
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // some text
                      Container(
                        width: 210,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          S.of(context).username_text,
                          style: TextStyle(
                            color: grey6,
                            fontSize: 15,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // userphoto
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
                          width: 120,
                          height: 120,
                          child: imageFile == null
                              ? photo.isEmpty
                                  ? Center(
                                      child: Icon(
                                        CupertinoIcons.camera_fill,
                                        color: white5,
                                        size: 65,
                                      ),
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          Image.network(photo).image,
                                    )
                              : CircleAvatar(
                                  backgroundImage: Image.file(imageFile!).image,
                                ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // textfield for username
                  MyTextField(
                    controller: usernameController,
                    hintText: S.of(context).username,
                    onTap: null,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // textfield for displayName
                  MyTextField(
                    controller: displayNameController,
                    hintText: S.of(context).displayname,
                    onTap: null,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // textfield for bio
                  MyBioTextField(
                    controller: bioController,
                    hintText: S.of(context).bio,
                    onTap: () => scrollToBottom(_scrollController),
                    length: bioController.text.length,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 'SET DATA' button
                        // Username, DisplayName, Bio and Photo
                        MyButton(
                          onTap: setUsernameData,
                          title: S.of(context).continue_registration,
                        ),

                        const SizedBox(
                          height: 15,
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
  }
}
