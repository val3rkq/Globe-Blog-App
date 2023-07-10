// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;
 
      return instance;
    });
  } 

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null, 'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome back! You've been missed!`
  String get login_text {
    return Intl.message(
      'Welcome back! You\'ve been missed!',
      name: 'login_text',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgot_password {
    return Intl.message(
      'Forgot Password',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get sign_in {
    return Intl.message(
      'Sign In',
      name: 'sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Not a member?`
  String get not_a_member {
    return Intl.message(
      'Not a member?',
      name: 'not_a_member',
      desc: '',
      args: [],
    );
  }

  /// `Register now`
  String get register_now {
    return Intl.message(
      'Register now',
      name: 'register_now',
      desc: '',
      args: [],
    );
  }

  /// `Or continue with`
  String get continue_with {
    return Intl.message(
      'Or continue with',
      name: 'continue_with',
      desc: '',
      args: [],
    );
  }

  /// `Let's create an account for you`
  String get register_text {
    return Intl.message(
      'Let\'s create an account for you',
      name: 'register_text',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_registration {
    return Intl.message(
      'Continue',
      name: 'continue_registration',
      desc: '',
      args: [],
    );
  }

  /// `Some fields are empty..`
  String get validation_error_empty_fields {
    return Intl.message(
      'Some fields are empty..',
      name: 'validation_error_empty_fields',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get already_member {
    return Intl.message(
      'Already have an account?',
      name: 'already_member',
      desc: '',
      args: [],
    );
  }

  /// `Login now`
  String get login_now {
    return Intl.message(
      'Login now',
      name: 'login_now',
      desc: '',
      args: [],
    );
  }

  /// `Send us your email to reset password`
  String get send_us_your_email_to_reset_password {
    return Intl.message(
      'Send us your email to reset password',
      name: 'send_us_your_email_to_reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password_text {
    return Intl.message(
      'Reset Password',
      name: 'reset_password_text',
      desc: '',
      args: [],
    );
  }

  /// `Password reset link sent! Check your email`
  String get password_sent {
    return Intl.message(
      'Password reset link sent! Check your email',
      name: 'password_sent',
      desc: '',
      args: [],
    );
  }

  /// `Now let's think about the username and displayName for your account. You can also write a bio about yourself..`
  String get username_text {
    return Intl.message(
      'Now let\'s think about the username and displayName for your account. You can also write a bio about yourself..',
      name: 'username_text',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
  }

  /// `DisplayName`
  String get displayname {
    return Intl.message(
      'DisplayName',
      name: 'displayname',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get bio {
    return Intl.message(
      'Bio',
      name: 'bio',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get sign_up {
    return Intl.message(
      'Sign Up',
      name: 'sign_up',
      desc: '',
      args: [],
    );
  }

  /// `Welcome!`
  String get welcome {
    return Intl.message(
      'Welcome!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Error..`
  String get error {
    return Intl.message(
      'Error..',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Loading..`
  String get loading {
    return Intl.message(
      'Loading..',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Start the dialog ...`
  String get start_the_dialog {
    return Intl.message(
      'Start the dialog ...',
      name: 'start_the_dialog',
      desc: '',
      args: [],
    );
  }

  /// `Hello!`
  String get hello {
    return Intl.message(
      'Hello!',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Message..`
  String get message {
    return Intl.message(
      'Message..',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `Find interesting people..`
  String get find_users_text {
    return Intl.message(
      'Find interesting people..',
      name: 'find_users_text',
      desc: '',
      args: [],
    );
  }

  /// `Search by username..`
  String get search {
    return Intl.message(
      'Search by username..',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Search notes..`
  String get search_notes {
    return Intl.message(
      'Search notes..',
      name: 'search_notes',
      desc: '',
      args: [],
    );
  }

  /// `User is not found..`
  String get user_is_not_found {
    return Intl.message(
      'User is not found..',
      name: 'user_is_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Note is not found..`
  String get note_is_not_found {
    return Intl.message(
      'Note is not found..',
      name: 'note_is_not_found',
      desc: '',
      args: [],
    );
  }

  /// `online`
  String get online {
    return Intl.message(
      'online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Posts`
  String get posts {
    return Intl.message(
      'Posts',
      name: 'posts',
      desc: '',
      args: [],
    );
  }

  /// `Followers`
  String get followers {
    return Intl.message(
      'Followers',
      name: 'followers',
      desc: '',
      args: [],
    );
  }

  /// `Followings`
  String get followings {
    return Intl.message(
      'Followings',
      name: 'followings',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get log_out {
    return Intl.message(
      'Log out',
      name: 'log_out',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `Upload new image`
  String get upload_img {
    return Intl.message(
      'Upload new image',
      name: 'upload_img',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect email`
  String get validation_email {
    return Intl.message(
      'Incorrect email',
      name: 'validation_email',
      desc: '',
      args: [],
    );
  }

  /// `Email is empty..`
  String get validation_email_empty {
    return Intl.message(
      'Email is empty..',
      name: 'validation_email_empty',
      desc: '',
      args: [],
    );
  }

  /// `Username is empty`
  String get validation_username_empty {
    return Intl.message(
      'Username is empty',
      name: 'validation_username_empty',
      desc: '',
      args: [],
    );
  }

  /// `Username is too big`
  String get validation_username_too_big {
    return Intl.message(
      'Username is too big',
      name: 'validation_username_too_big',
      desc: '',
      args: [],
    );
  }

  /// `Username is already taken`
  String get validation_username_is_taken {
    return Intl.message(
      'Username is already taken',
      name: 'validation_username_is_taken',
      desc: '',
      args: [],
    );
  }

  /// `DisplayName is empty`
  String get validation_displayname_empty {
    return Intl.message(
      'DisplayName is empty',
      name: 'validation_displayname_empty',
      desc: '',
      args: [],
    );
  }

  /// `DisplayName is too big`
  String get validation_displayname_too_big {
    return Intl.message(
      'DisplayName is too big',
      name: 'validation_displayname_too_big',
      desc: '',
      args: [],
    );
  }

  /// `Passwords are different`
  String get different_passwords {
    return Intl.message(
      'Passwords are different',
      name: 'different_passwords',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message(
      'Options',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `replies`
  String get replies {
    return Intl.message(
      'replies',
      name: 'replies',
      desc: '',
      args: [],
    );
  }

  /// `Your comment..`
  String get your_comment {
    return Intl.message(
      'Your comment..',
      name: 'your_comment',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `All Replies`
  String get all_replies {
    return Intl.message(
      'All Replies',
      name: 'all_replies',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Follower`
  String get follower {
    return Intl.message(
      'Follower',
      name: 'follower',
      desc: '',
      args: [],
    );
  }

  /// `Following`
  String get following {
    return Intl.message(
      'Following',
      name: 'following',
      desc: '',
      args: [],
    );
  }

  /// `No comments`
  String get no_comments {
    return Intl.message(
      'No comments',
      name: 'no_comments',
      desc: '',
      args: [],
    );
  }

  /// `No `
  String get no_users {
    return Intl.message(
      'No ',
      name: 'no_users',
      desc: '',
      args: [],
    );
  }

  /// `Saved Posts`
  String get saved_posts {
    return Intl.message(
      'Saved Posts',
      name: 'saved_posts',
      desc: '',
      args: [],
    );
  }

  /// `Liked Posts`
  String get liked_posts {
    return Intl.message(
      'Liked Posts',
      name: 'liked_posts',
      desc: '',
      args: [],
    );
  }

  /// `This page is under development now...`
  String get developing {
    return Intl.message(
      'This page is under development now...',
      name: 'developing',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}