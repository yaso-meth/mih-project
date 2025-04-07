import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:Mzansi_Innovation_Hub/mih_env/env.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/business_profile/builders/build_user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihBusinessUserSearch extends StatefulWidget {
  final BusinessArguments arguments;
  const MihBusinessUserSearch({
    super.key,
    required this.arguments,
  });

  @override
  State<MihBusinessUserSearch> createState() => _MihBusinessUserSearchState();
}

class _MihBusinessUserSearchState extends State<MihBusinessUserSearch> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  late Future<List<AppUser>> userSearchResults;

  String userSearch = "";
  String errorCode = "";
  String errorBody = "";

  Future<List<AppUser>> fetchUsers(String search) async {
    final response = await http
        .get(Uri.parse("${AppEnviroment.baseApiUrl}/users/search/$search"));
    errorCode = response.statusCode.toString();
    errorBody = response.body;
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<AppUser> users =
          List<AppUser>.from(l.map((model) => AppUser.fromJson(model)));
      return users;
    } else {
      throw Exception('failed to load patients');
    }
  }

  void submitUserForm() {
    if (searchController.text != "") {
      setState(() {
        userSearch = searchController.text;
        userSearchResults = fetchUsers(userSearch);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
  }

  Widget displayUserList(List<AppUser> userList) {
    if (userList.isNotEmpty) {
      return BuildUserList(
        users: userList,
        arguments: widget.arguments,
      );
    }
    return Center(
      child: Text(
        "Enter Username or Email to search",
        style: TextStyle(
            fontSize: 25,
            color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userSearchResults = fetchUsers("abc");
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return MihSingleChildScroll(
      child: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) async {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            submitUserForm();
          }
        },
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          const Text(
            "User Search",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          //spacer
          Divider(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
          const SizedBox(height: 10),
          MIHSearchField(
            controller: searchController,
            hintText: "Username or Email Search",
            required: true,
            editable: true,
            onTap: () {
              submitUserForm();
            },
          ),
          //spacer
          const SizedBox(height: 10),
          FutureBuilder(
            future: userSearchResults,
            builder: (context, snapshot) {
              //print("patient Liust  ${snapshot.data}");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Mihloadingcircle();
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                List<AppUser> patientsList;
                if (userSearch == "") {
                  patientsList = [];
                } else {
                  patientsList = snapshot.data!;
                  //print(patientsList);
                }
                return displayUserList(patientsList);
              } else {
                return Center(
                  child: Text(
                    "$errorCode: Error pulling Patients Data\n/patients/search/$userSearch\n$errorBody",
                    style: TextStyle(
                        fontSize: 25,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .errorColor()),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
        ]),
      ),
    );
  }
}
