import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/mih_home.dart';
import 'package:flutter/material.dart';

import '../../mih_services/mih_service_calls.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_config/mih_env.dart';

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

  MihPackageTools getErrorTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.power_off_outlined)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };

    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getErrorToolBody(String error) {
    List<Widget> toolBodies = [
      MihPackageToolBody(
        borderOn: true,
        bodyItem: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Connection Error",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.power_off_outlined,
              size: 150,
              color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
            ),
            SizedBox(
              width: 500,
              child: Text(
                "Looks like we ran into an issue getting your data.\nPlease check you internet connection and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            MihButton(
              onPressed: () {
                Navigator.of(context).popAndPushNamed("/");
              },
              buttonColor:
                  MzansiInnovationHub.of(context)!.theme.successColor(),
              width: 300,
              child: Text(
                "Refresh",
                style: TextStyle(
                  color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                          MzansiInnovationHub.of(context)!.theme.errorColor(),
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
    return MihPackage(
      appActionButton: MihPackageAction(
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    //profile = getProfile();
    profile = MIHApiCalls().getProfile(amount, context);
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
              propicFile: snapshot.data!.profilePicUrl != ""
                  ? NetworkImage(snapshot.data!.profilePicUrl)
                  : null,
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
