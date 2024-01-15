import 'package:bloctest_project/strings.dart';
import 'package:flutter/material.dart';

import '../dialogs/generic_dialog.dart';

typedef OnLoginTapped = void Function(String email, String password);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;

  const LoginButton(
      {required this.emailController,
      required this.passwordController,
        required this.onLoginTapped,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          final email = emailController.text;
          final password = passwordController.text;
          if (email.isNotEmpty && password.isNotEmpty) {
            onLoginTapped(email,password);
          } else {
            showGenericDialog<bool>(
                title: emailOrPasswordEmptyDialogTitle,
                content: emailOrPasswordEmptyDescription,
                optionBuilder: () => {ok: true});
          }
        },
        child: const Text(login));
  }
}
