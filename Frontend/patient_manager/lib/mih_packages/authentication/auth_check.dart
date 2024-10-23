import 'package:flutter/material.dart';
import 'package:patient_manager/mih_packages/authentication/signin_or_register.dart';
import 'package:patient_manager/mih_packages/mih_home/mih_profile_getter.dart';

import 'package:supertokens_flutter/supertokens.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  late Future<bool> signedIn;

  Future<bool> doesSessionExist() async {
    //wait
    await Future.delayed(const Duration(seconds: 1));
    return await SuperTokens.doesSessionExist();
  }

  @override
  void initState() {
    signedIn = doesSessionExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          // Return a widget tree based on the orientation
          return FutureBuilder(
              future: signedIn,
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return const MIHProfileGetter();
                } else {
                  return const SignInOrRegister();
                }
              });
        },
        // child: FutureBuilder(
        //     future: signedIn,
        //     builder: (context, snapshot) {
        //       if (snapshot.data == true) {
        //         return const MIHProfileGetter();
        //       } else {
        //         return const SignInOrRegister();
        //       }
        //     }),
      ),
    );
  }
}
