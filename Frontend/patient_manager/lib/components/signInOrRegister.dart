import 'package:flutter/material.dart';
import 'package:patient_manager/pages/register.dart';
import 'package:patient_manager/pages/signin.dart';

class SignInOrRegister extends StatefulWidget {
  const SignInOrRegister({super.key});

  @override
  State<SignInOrRegister> createState() => _SignInOrRegisterState();
}

class _SignInOrRegisterState extends State<SignInOrRegister> {
  bool showSignInPage = true;

  void togglePages() {
    setState(() {
      showSignInPage = !showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignInPage) {
      return SignIn(onTap: togglePages);
    } else {
      return Register(onTap: togglePages);
    }
  }
}
