import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tools.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mih_home/mih_home.dart';
import 'package:flutter/material.dart';

import '../../mih_apis/mih_api_calls.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_env/env.dart';
import '../../mih_objects/app_user.dart';
import '../../mih_objects/arguments.dart';
import '../../mih_objects/business_user.dart';

class MIHProfileGetter extends StatefulWidget {
  final bool personalSelected;
  const MIHProfileGetter({
    super.key,
    required this.personalSelected,
  });

  @override
  State<MIHProfileGetter> createState() => _MIHProfileGetterState();
}

class _MIHProfileGetterState extends State<MIHProfileGetter> {
  String useremail = "";
  int amount = 10;
  final baseAPI = AppEnviroment.baseApiUrl;
  late Future<HomeArguments> profile;

  String proPicUrl = "empty";
  ImageProvider<Object>? propicFile;
  int _selcetedIndex = 0;

  ImageProvider<Object>? isPictureAvailable(String url) {
    if (url == "") {
      return const AssetImage('images/i-dont-know-2.png');
    } else if (url != "") {
      return NetworkImage(url);
    } else {
      return null;
    }
  }

  bool isUserNew(AppUser signedInUser) {
    if (signedInUser.fname == "") {
      return true;
    } else {
      return false;
    }
  }

  bool isDevActive() {
    if (AppEnviroment.getEnv() == "Dev") {
      return true;
    } else {
      return false;
    }
  }

  bool isBusinessUser(AppUser signedInUser) {
    if (signedInUser.type == "personal") {
      return false;
    } else {
      return true;
    }
  }

  bool isBusinessUserNew(BusinessUser? businessUser) {
    if (businessUser == null) {
      return true;
    } else {
      return false;
    }
  }

  MihAppTools getErrorTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.power_off_outlined)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };

    return MihAppTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getErrorToolBody(String error) {
    List<Widget> toolBodies = [
      MihAppToolBody(
        borderOn: true,
        bodyItem: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Connection Error",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.power_off_outlined,
              size: 150,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
            SizedBox(
              width: 500,
              child: Text(
                "Looks like we ran into an issue getting your data.\nPlease check you internet connection and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            MIHButton(
              onTap: () {
                Navigator.of(context).popAndPushNamed("/");
              },
              buttonText: "Refresh",
              buttonColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 500,
                child: SelectionArea(
                  child: Text(
                    "Error: $error",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color:
                          MzanziInnovationHub.of(context)!.theme.errorColor(),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ];
    return toolBodies;
  }

  Widget errorPage(String error) {
    return MihApp(
      appActionButton: MihAppAction(
        icon: const Icon(Icons.refresh),
        iconSize: 35,
        onTap: () {
          Navigator.of(context).popAndPushNamed("/");
        },
      ),
      appTools: getErrorTools(),
      appBody: getErrorToolBody(error),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
        });
        //print("Index: $_selcetedIndex");
      },
    );
    // return MIHLayoutBuilder(
    //   actionButton: MIHAction(
    //     icon: const Icon(Icons.refresh),
    //     iconSize: 35,
    //     onTap: () {
    //       Navigator.of(context).popAndPushNamed("/");
    //     },
    //   ),
    //   header: const MIHHeader(
    //     headerAlignment: MainAxisAlignment.center,
    //     headerItems: [
    //       Text(
    //         "Mzanzi Innovation Hub",
    //         style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 20,
    //         ),
    //       ),
    //     ],
    //   ),
    //   secondaryActionButton: null,
    //   body: MIHBody(
    //     borderOn: false,
    //     bodyItems: [
    //       Align(
    //         alignment: Alignment.center,
    //         child: Text(
    //           '$error occurred',
    //           style: const TextStyle(fontSize: 18),
    //         ),
    //       ),
    //     ],
    //   ),
    //   actionDrawer: null,
    //   secondaryActionDrawer: null,
    //   bottomNavBar: null,
    //   pullDownToRefresh: false,
    //   onPullDown: () async {},
    // );
  }

// <a href="https://www.flaticon.com/free-icons/dont-know" title="dont know icons">Dont know icons created by Freepik - Flaticon</a>
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    //profile = getProfile();
    profile = MIHApiCalls().getProfile(amount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: profile,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return MihHome(
              signedInUser: snapshot.requireData.signedInUser,
              businessUser: snapshot.data!.businessUser,
              business: snapshot.data!.business,
              patient: snapshot.data!.patient,
              notifications: snapshot.data!.notifi,
              propicFile: isPictureAvailable(snapshot.data!.profilePicUrl),
              isUserNew: isUserNew(snapshot.requireData.signedInUser),
              isBusinessUser: isBusinessUser(snapshot.requireData.signedInUser),
              isBusinessUserNew: isBusinessUserNew(snapshot.data!.businessUser),
              isDevActive: isDevActive(),
              personalSelected: widget.personalSelected,
            );
            // return MIHHomeLegacy(
            //   signedInUser: snapshot.requireData.signedInUser,
            //   businessUser: snapshot.data!.businessUser,
            //   business: snapshot.data!.business,
            //   patient: snapshot.data!.patient,
            //   notifications: snapshot.data!.notifi,
            //   propicFile: isPictureAvailable(snapshot.data!.profilePicUrl),
            //   isUserNew: isUserNew(snapshot.requireData.signedInUser),
            //   isBusinessUser: isBusinessUser(snapshot.requireData.signedInUser),
            //   isBusinessUserNew: isBusinessUserNew(snapshot.data!.businessUser),
            //   isDevActive: isDevActive(),
            //   personalSelected: widget.personalSelected,
            // );
          } else {
            return errorPage(snapshot.error.toString());
          }
        }
        return const Mihloadingcircle();
      },
    );
  }
}
