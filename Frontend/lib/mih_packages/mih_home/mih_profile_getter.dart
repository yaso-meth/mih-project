import 'package:flutter/material.dart';

import '../../mih_apis/mih_api_calls.dart';
import '../../mih_components/mih_layout/mih_action.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_env/env.dart';
import '../../mih_objects/app_user.dart';
import '../../mih_objects/arguments.dart';
import '../../mih_objects/business_user.dart';
import 'mih_home.dart';

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
            return MIHHome(
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
          } else {
            return MIHLayoutBuilder(
              actionButton: MIHAction(
                icon: const Icon(Icons.refresh),
                iconSize: 35,
                onTap: () {
                  Navigator.of(context).popAndPushNamed("/");
                },
              ),
              header: const MIHHeader(
                headerAlignment: MainAxisAlignment.center,
                headerItems: [
                  Text(
                    "Mzanzi Innovation Hub",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              secondaryActionButton: null,
              body: MIHBody(
                borderOn: false,
                bodyItems: [
                  Center(
                    child: Text(
                      '${snapshot.error} occurred',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              actionDrawer: null,
              secondaryActionDrawer: null,
              bottomNavBar: null,
              pullDownToRefresh: false,
              onPullDown: () async {},
            );
          }
        }
        return const Mihloadingcircle();
      },
    );
  }
}
