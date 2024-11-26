import 'package:flutter/material.dart';

import 'package:supertokens_flutter/supertokens.dart';
import 'package:no_screenshot/no_screenshot.dart';
import '../mih_home/mih_profile_getter.dart';
import 'signin_or_register.dart';

class AuthCheck extends StatefulWidget {
  final bool personalSelected;
  const AuthCheck({
    super.key,
    required this.personalSelected,
  });

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  final _noScreenshot = NoScreenshot.instance;

  Future<bool> doesSessionExist() async {
    //wait
    //await Future.delayed(const Duration(seconds: 1));
    bool signedIn = await SuperTokens.doesSessionExist();
    return signedIn;
  }

  void disableScreenshot() async {
    try {
      bool result = await _noScreenshot.screenshotOff();
      print('Screenshot Off: $result');
    } on Exception {
      print("Web");
    }
  }

  @override
  void initState() {
    //signedIn = doesSessionExist();
    disableScreenshot();
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
                  return MIHProfileGetter(
                    personalSelected: widget.personalSelected,
                  );
                } else if (snapshot.data == false) {
                  return const SignInOrRegister();
                } else {
                  return const SizedBox(width: 5, height: 5);
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
