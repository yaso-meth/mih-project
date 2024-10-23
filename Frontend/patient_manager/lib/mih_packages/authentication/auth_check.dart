import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:patient_manager/mih_packages/authentication/signin_or_register.dart';
import 'package:patient_manager/mih_packages/mih_home/mih_profile_getter.dart';

import 'package:supertokens_flutter/supertokens.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  Future<bool> doesSessionExist() async {
    //wait
    //await Future.delayed(const Duration(seconds: 1));
    bool signedIn = await SuperTokens.doesSessionExist();
    return signedIn;
  }

  @override
  void initState() {
    //signedIn = doesSessionExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          // Return a widget tree based on the orientation
          return FutureBuilder(
              future: doesSessionExist(),
              builder: (context, snapshot) {
                //print(snapshot.data);
                if (snapshot.data == true) {
                  return const MIHProfileGetter();
                } else if (snapshot.data == false) {
                  return const SignInOrRegister();
                } else {
                  return const Mihloadingcircle();
                  //const SizedBox(width: 5,height: 5);
                  //const Mihloadingcircle();
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
