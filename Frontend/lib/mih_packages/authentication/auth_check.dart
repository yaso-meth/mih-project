import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_packages/authentication/biometric_check.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/mih_authentication.dart';

import 'package:supertokens_flutter/supertokens.dart';
// import 'package:no_screenshot/no_screenshot.dart';

class AuthCheck extends StatefulWidget {
  final bool personalSelected;
  final bool firstBoot;
  const AuthCheck({
    super.key,
    required this.personalSelected,
    required this.firstBoot,
  });

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  // final _noScreenshot = NoScreenshot.instance;

  Future<bool> doesSessionExist() async {
    //wait
    //await Future.delayed(const Duration(seconds: 1));
    bool signedIn = await SuperTokens.doesSessionExist();
    return signedIn;
  }

  // void disableScreenshot() async {
  //   try {
  //     bool result = await _noScreenshot.screenshotOff();
  //     print('Screenshot Off: $result');
  //   } on Exception {
  //     print("Web");
  //   }
  // }

  @override
  void initState() {
    //signedIn = doesSessionExist();
    // disableScreenshot(); Screenshot
    // var brightness =
    //     SchedulerBinding.instance.platformDispatcher.platformBrightness;
    // bool isDarkMode = brightness == Brightness.dark;
    // if (isDarkMode) {
    //   MzanziInnovationHub.of(context)!.theme.mode = "Dark";
    // } else {
    //   MzanziInnovationHub.of(context)!.theme.mode = "Light";
    // }
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
                  return BiometricCheck(
                    personalSelected: widget.personalSelected,
                    firstBoot: widget.firstBoot,
                  );
                } else if (snapshot.data == false) {
                  return MihAuthentication();
                } else {
                  return
                      // const SizedBox(width: 5, height: 5);
                      const Mihloadingcircle();
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
