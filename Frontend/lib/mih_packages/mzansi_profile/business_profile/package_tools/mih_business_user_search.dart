import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/builders/build_user_list.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';

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
  final TextEditingController searchController = TextEditingController();
  late Future<List<AppUser>> userSearchResults;
  final FocusNode _searchFocusNode = FocusNode();

  String userSearch = "";
  String errorCode = "";
  String errorBody = "";

  Future<List<AppUser>> fetchUsers(String search) async {
    return MihUserServices().searchUsers(search, context);
    // final response = await http
    //     .get(Uri.parse("${AppEnviroment.baseApiUrl}/users/search/$search"));
    // errorCode = response.statusCode.toString();
    // errorBody = response.body;
    // if (response.statusCode == 200) {
    //   Iterable l = jsonDecode(response.body);
    //   List<AppUser> users =
    //       List<AppUser>.from(l.map((model) => AppUser.fromJson(model)));
    //   return users;
    // } else {
    //   throw Exception('failed to load patients');
    // }
  }

  void submitUserForm() {
    if (searchController.text != "") {
      setState(() {
        userSearch = searchController.text;
        userSearchResults = fetchUsers(userSearch);
      });
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(width),
    );
  }

  Widget getBody(double width) {
    return MihSingleChildScroll(
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width / 20),
          child: MihSearchBar(
            controller: searchController,
            hintText: "Search Users",
            prefixIcon: Icons.search,
            fillColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            hintColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            onPrefixIconTap: () {
              submitUserForm();
            },
            onClearIconTap: () {
              setState(() {
                searchController.clear();
                userSearch = "";
              });
              submitUserForm();
            },
            searchFocusNode: _searchFocusNode,
          ),
        ),
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
                  "$errorCode: Error pulling Patients Data\n/users/search/$userSearch\n$errorBody",
                  style: TextStyle(
                      fontSize: 25,
                      color:
                          MzanziInnovationHub.of(context)!.theme.errorColor()),
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ]),
    );
  }
}
