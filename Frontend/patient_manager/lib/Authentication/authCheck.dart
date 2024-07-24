import 'package:flutter/material.dart';
import 'package:patient_manager/components/signInOrRegister.dart';
import 'package:patient_manager/pages/home.dart';
import 'package:supertokens_flutter/supertokens.dart';

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  Future<bool> doesSessionExist() async {
    return await SuperTokens.doesSessionExist();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: doesSessionExist(),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return const Home();
          } else {
            return const SignInOrRegister();
          }
        });
  }
}
