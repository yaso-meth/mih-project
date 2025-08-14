import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_header.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
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
              color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
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
    Widget alertpopUp = MihPackageAlert(
      alertIcon: Icon(
        Icons.fingerprint,
        color: MzansiInnovationHub.of(context)!.theme.errorColor(),
        size: 100,
      ),
      alertTitle: "Biometric Authentication Error",
      alertBody: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hi there! To jump into the MIH Home Package, you'll need to authenticate yourself with your phones biometrics, please set up biometric authentication (like fingerprint, face ID, pattern or pin) on your device first.\n\nIf you have already set up biometric authentication, press \"Authenticate now\" to try again or press \"Set Up Authentication\" to go to your device settings.",
            style: TextStyle(
              fontSize: 15,
              color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              MihButton(
                onPressed: () {
                  AppSettings.openAppSettings(
                    type: AppSettingsType.security,
                  );
                  Navigator.of(context).pop();
                },
                buttonColor:
                    MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                width: 300,
                child: Text(
                  "Set Up Authentication",
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MihButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  authenticateUser();
                },
                buttonColor: MihColors.getGreenColor(context),
                width: 300,
                child: Text(
                  "Authenticate Now",
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      alertColour: MzansiInnovationHub.of(context)!.theme.errorColor(),
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
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
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
                      color: MzansiInnovationHub.of(context)!
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
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                  const SizedBox(height: 30),
                  MihButton(
                    onPressed: () {
                      authenticateUser();
                    },
                    buttonColor: MihColors.getGreenColor(context),
                    width: 300,
                    child: Text(
                      "Authenticate Now",
                      style: TextStyle(
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
    if (MzansiInnovationHub.of(context)!.theme.getPlatform() == "Web") {
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
