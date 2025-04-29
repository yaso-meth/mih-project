import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_header.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/mih_profile_getter.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:app_settings/app_settings.dart';

class BiometricCheck extends StatefulWidget {
  final bool personalSelected;
  final bool firstBoot;
  const BiometricCheck({
    super.key,
    required this.personalSelected,
    required this.firstBoot,
  });

  @override
  State<BiometricCheck> createState() => _BiometricCheckState();
}

class _BiometricCheckState extends State<BiometricCheck> {
  bool _isBioAuthenticated = false;
  final LocalAuthentication _auth = LocalAuthentication();

  MIHAction getActionButton() {
    return MIHAction(
      icon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 50,
          child: FittedBox(
            child: Icon(
              MihIcons.mihLogo,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
        ),
      ),
      iconSize: 35,
      onTap: () async {
        await SuperTokens.signOut(completionHandler: (error) {
          print(error);
        });
        if (await SuperTokens.doesSessionExist() == false) {
          Navigator.of(context).popAndPushNamed('/');
        }
        // Navigator.of(context).pushNamed(
        //   '/about',
        //   //arguments: widget.signedInUser,
        // );
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  void authenticateUser() async {
    final bool canAuthWithBio = await _auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthWithBio || await _auth.isDeviceSupported();
    print("Auth Available: $canAuthenticate");
    if (canAuthenticate) {
      try {
        final bool didBioAuth = await _auth.authenticate(
          localizedReason: "Authenticate to access MIH",
          options: const AuthenticationOptions(
            biometricOnly: false,
          ),
        );
        if (didBioAuth) {
          setState(() {
            _isBioAuthenticated = true;
          });
        } else {
          authErrorPopUp();
        }
        // print("Authenticated: $didBioAuth");
      } catch (error) {
        print("Auth Error: $error");
        authErrorPopUp();
      }
    } else {
      print("Auth Error: No Biometrics Available");
      authErrorPopUp();
    }
  }

  void authErrorPopUp() {
    Widget alertpopUp = MihAppAlert(
      alertIcon: Icon(
        Icons.fingerprint,
        color: MzanziInnovationHub.of(context)!.theme.errorColor(),
        size: 100,
      ),
      alertTitle: "Biometric Authentication Error",
      alertBody: Column(
        children: [
          Text(
            "Hi there! To jump into the MIH Home Package, you'll need to set up biometric authentication (like fingerprint or face ID) on your device first. It looks like it's not quite ready yet.\n\nPlease head over to your device's settings to enable it, or press the button below to start the set up process now.",
            style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 300,
            child: MIHButton(
              onTap: () {
                AppSettings.openAppSettings(
                  type: AppSettingsType.security,
                );
                Navigator.of(context).pop();
              },
              buttonText: "Set Up Authentication",
              buttonColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
              textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            ),
          )
        ],
      ),
      alertColour: MzanziInnovationHub.of(context)!.theme.errorColor(),
    );
    showDialog(
      context: context,
      builder: (context) {
        return alertpopUp;
      },
    );
  }

  MIHBody getBody() {
    return MIHBody(
      borderOn: false,
      bodyItems: [
        SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Icon(
                    Icons.fingerprint,
                    size: 100,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                  //spacer
                  const SizedBox(height: 10),
                  //Heading
                  Text(
                    'Biomentric Authentication',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                  //spacer
                  const SizedBox(height: 25),
                  // if (!_isBioAuthenticated)
                  Icon(
                    Icons.lock,
                    size: 200,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                  // if (_isBioAuthenticated)
                  //   Icon(
                  //     Icons.lock_open,
                  //     size: 200,
                  //     color: MzanziInnovationHub.of(context)!
                  //         .theme
                  //         .secondaryColor(),
                  //   ),
                  const SizedBox(height: 30),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 500.0,
                      height: 50.0,
                      child: MIHButton(
                        buttonText: "Unlock",
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        onTap: () async {
                          //Check Biometrics
                          authenticateUser();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getBiomentricAuthScreen() {
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      secondaryActionButton: null,
      body: getBody(),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.firstBoot == true) authenticateUser();
  }

  @override
  Widget build(BuildContext context) {
    if (MzanziInnovationHub.of(context)!.theme.getPlatform() == "Web") {
      return MIHProfileGetter(
        personalSelected: widget.personalSelected,
      );
    } else if (!widget.firstBoot) {
      return MIHProfileGetter(
        personalSelected: widget.personalSelected,
      );
    } else {
      if (_isBioAuthenticated) {
        return MIHProfileGetter(
          personalSelected: widget.personalSelected,
        );
      } else {
        return getBiomentricAuthScreen();
      }
    }
  }
}
