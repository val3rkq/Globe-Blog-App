import 'package:flutter/material.dart';
import 'package:globe/auth/auth.dart';
import 'package:globe/constants.dart';
import 'package:globe/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:globe/widgets/page_names/for_forgot_password_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  void resetPassword() async {
    // get auth service
    final authService = Provider.of<Auth>(context, listen: false);
    await authService.resetPassword(context, emailController.text);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              S.of(context).send_us_your_email_to_reset_password,
              style: TextStyle(color: grey3, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextField(
              controller: emailController,
              hintText: S.of(context).email,
              onTap: null,
            ),
            MyButton(
              onTap: resetPassword,
              title: S.of(context).reset_password_text,
            )
          ],
        ),
      ),
    );
  }
}
