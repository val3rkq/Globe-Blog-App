import 'package:flutter/material.dart';
import 'package:globe/auth/auth.dart';
import 'package:globe/constants.dart';
import 'package:globe/generated/l10n.dart';
import 'package:globe/helpers/display_message.dart';
import 'package:globe/helpers/scroll_to_bottom.dart';
import 'package:globe/widgets/page_names/for_auth_pages.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({
    Key? key,
    this.onTap,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  // form key for validation
  final _formKey = GlobalKey<FormState>();

  // sign up
  void signUp() async {
    // get the AUTH service
    final authService = Provider.of<Auth>(context, listen: false);

    try {

      // compare passwords
      if (passwordController.text != confirmPasswordController.text) {
        displayMessage(context, S.of(context).different_passwords);
      } else {
        // validation
        if (_formKey.currentState!.validate()) {
          await authService.signUpWithEmailAndPassword(
            emailController.text,
            passwordController.text,
          );
        }
      }

    } catch (error) {
      displayMessage(context, error.toString());
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  //icon
                  Lottie.asset(
                    'assets/register.json',
                    width: 300,
                    height: 300,
                    fit: BoxFit.fill,
                  ),

                  // some text
                  Center(
                    child: Text(
                      S.of(context).register_text,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 17,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
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
                    height: 15,
                  ),

                  // textfield for confirm password
                  MyPasswordTextField(
                    controller: confirmPasswordController,
                    hintText: S.of(context).confirm_password,
                    onTap: () => scrollToBottom(_scrollController),
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // SIGN UP REGISTRATION button
                        MyButton(
                          onTap: () {
                            // move on next page to set username, bio, image
                            signUp();
                          },
                          title: S.of(context).sign_up,
                        ),

                        const SizedBox(
                          height: 15,
                        ),

                        // other text, go to login_page
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).already_member,
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            GestureDetector(
                              onTap: widget.onTap,
                              child: Text(
                                S.of(context).login_now,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
