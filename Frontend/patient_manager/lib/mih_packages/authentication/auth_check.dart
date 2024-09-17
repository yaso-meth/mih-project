import 'package:flutter/material.dart';
import 'package:patient_manager/mih_packages/authentication/signin_or_register.dart';
import 'package:patient_manager/mih_packages/mih_home/home.dart';
import 'package:supertokens_flutter/supertokens.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  Future<bool> doesSessionExist() async {
    return await SuperTokens.doesSessionExist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: doesSessionExist(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return const Home();
            } else {
              return const SignInOrRegister();
            }
          }),
    );
  }
}
