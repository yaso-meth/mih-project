import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/builders/build_user_list.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:provider/provider.dart';

class MihBusinessUserSearch extends StatefulWidget {
  const MihBusinessUserSearch({
    super.key,
  });

  @override
  State<MihBusinessUserSearch> createState() => _MihBusinessUserSearchState();
}

class _MihBusinessUserSearchState extends State<MihBusinessUserSearch> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool hasSearchedBefore = false;
  String userSearch = "";
  String errorCode = "";
  String errorBody = "";

  Future<void> fetchUsers(
      MzansiProfileProvider profileProvider, String search) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Mihloadingcircle();
        },
      );
      await MihUserServices().searchUsers(profileProvider, search, context);
      context.pop();
    } catch (error) {
      context.pop();
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  void submitUserForm(MzansiProfileProvider profileProvider) {
    if (searchController.text != "") {
      userSearch = searchController.text;
      hasSearchedBefore = true;
      fetchUsers(profileProvider, userSearch);
    }
  }

  Widget displayUserList(MzansiProfileProvider profileProvider) {
    if (profileProvider.userSearchResults.isNotEmpty) {
      return Expanded(
        child: BuildUserList(),
      );
    }
    if (hasSearchedBefore && userSearch.isNotEmpty) {
      return Column(
        children: [
          const SizedBox(height: 50),
          Icon(
            MihIcons.mihIDontKnow,
            size: 165,
            color: MihColors.secondary(),
          ),
          const SizedBox(height: 10),
          Text(
            "Let's try refining your search",
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: MihColors.secondary(),
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Icon(
              MihIcons.personalProfile,
              size: 165,
              color: MihColors.secondary(),
            ),
            const SizedBox(height: 10),
            Text(
              "Search for a member of Mzansi to add to your team",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MihColors.secondary(),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: MihColors.secondary(),
                  ),
                  children: [
                    TextSpan(
                        text: "You can search using their username or email"),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(width),
    );
  }

  Widget getBody(double width) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          Widget? child) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: MihSearchBar(
                controller: searchController,
                hintText: "Search Users",
                prefixIcon: Icons.search,
                fillColor: MihColors.secondary(),
                hintColor: MihColors.primary(),
                onPrefixIconTap: () {
                  submitUserForm(profileProvider);
                },
                onClearIconTap: () {
                  setState(() {
                    searchController.clear();
                    userSearch = "";
                  });
                  profileProvider.setUserearchResults(userSearchResults: []);
                },
                searchFocusNode: _searchFocusNode,
              ),
            ),
            const SizedBox(height: 10),
            displayUserList(profileProvider),
          ],
        );
      },
    );
  }
}
