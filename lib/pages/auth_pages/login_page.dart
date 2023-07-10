import 'package:globe/auth/auth.dart';
import 'package:globe/helpers/display_message.dart';
import 'package:globe/pages/auth_pages/forgot_password_page.dart';
import 'package:globe/widgets/icon_tile.dart';
import 'package:globe/constants.dart';
import 'package:globe/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:globe/widgets/my_button.dart';
import 'package:globe/widgets/my_password_textfield.dart';
import 'package:globe/widgets/my_textfield.dart';
import 'package:globe/helpers/scroll_to_bottom.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({Key? key, this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  // form key for validation
  final _formKey = GlobalKey<FormState>();

  // sign in
  void signIn() async {
    // get the AUTH service
    final authService = Provider.of<Auth>(context, listen: false);

    try {
      // validation
      if (_formKey.currentState!.validate()) {
        await authService.signInWithEmailAndPassword(
          emailController.text,
          passwordController.text,
        );
      }
    } catch (error) {
      displayMessage(context, error.toString());
    }
  }

  // sign in with google
  void signInWithGoogle() async {
    // get the AUTH service
    final authService = Provider.of<Auth>(context, listen: false);

    try {
      await authService.signInWithGoogle();
    } catch (error) {
      displayMessage(context, error.toString());
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      // icon

                      Lottie.asset(
                        'assets/login.json',
                        width: 250,
                        height: 250,
                        fit: BoxFit.fill,
                      ),

                      // some text
                      Center(
                        child: Text(
                          S.of(context).login_text,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 17,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      // textfield for login
                      MyTextField(
                        controller: emailController,
                        hintText: S.of(context).email,
                        onTap: () => scrollToBottom(_scrollController),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      // textfield for password
                      MyPasswordTextField(
                        controller: passwordController,
                        hintText: S.of(context).password,
                        onTap: () => scrollToBottom(_scrollController),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // forgot password
                      Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordPage(),
                              ),
                            );
                          },
                          child: Text(
                            S.of(context).forgot_password,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        // SIGN IN button
                        MyButton(
                          onTap: signIn,
                          title: S.of(context).sign_in,
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        // other ways to login (continue with)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Text(
                                  S.of(context).continue_with,
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 0.5,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 25,
                        ),
                        // icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // google
                            GestureDetector(
                              onTap: signInWithGoogle,
                              child: const IconTile(
                                  asset: 'assets/images/google.png'),
                            ),

                            const SizedBox(
                              width: 15,
                            ),

                            // apple
                            const IconTile(asset: 'assets/images/apple.png'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Not a member?, go to register_page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        S.of(context).not_a_member,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        // toggle pages
                        onTap: widget.onTap,
                        child: Text(
                          S.of(context).register_now,
                          style: TextStyle(
                            color: mainColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
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
