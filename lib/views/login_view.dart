import 'package:bloctest_project/views/email_text_field.dart';
import 'package:bloctest_project/views/login_button.dart';
import 'package:bloctest_project/views/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginView extends HookWidget {
  final OnLoginTapped onLoginTapped;

  const LoginView({required this.onLoginTapped, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        EmailTextField(controller: emailController),
        PasswordTextField(controller: passwordController),
        LoginButton(
          emailController: emailController,
          passwordController: passwordController,
          onLoginTapped: onLoginTapped,
        )
      ]),
    );
  }
}
