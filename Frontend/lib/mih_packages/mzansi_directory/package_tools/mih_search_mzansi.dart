import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/builders/build_business_search_resultsList.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/builders/build_user_search_results_list.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';

class MihSearchMzansi extends StatefulWidget {
  final String? startUpSearch;
  final bool personalSearch;
  const MihSearchMzansi({
    super.key,
    required this.startUpSearch,
    required this.personalSearch,
  });

  @override
  State<MihSearchMzansi> createState() => _MihSearchMzansiState();
}

class _MihSearchMzansiState extends State<MihSearchMzansi> {
  final TextEditingController mzansiSearchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late bool userSearch;
  Future<List<AppUser>?> futureUserSearchResults = Future.value();
  Future<List<Business>?> futureBusinessSearchResults = Future.value();
  late Future<Position?> futurePosition =
      MIHLocationAPI().getGPSPosition(context);
  List<AppUser> userSearchResults = [];
  List<Business> businessSearchResults = [];

  @override
  void dispose() {
    super.dispose();
    mzansiSearchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      userSearch = widget.personalSearch;
      mzansiSearchController.text = widget.startUpSearch ?? "";
      if (userSearch) {
        futureUserSearchResults =
            MihUserServices().searchUsers(mzansiSearchController.text, context);
      } else {
        futureBusinessSearchResults = MihBusinessDetailsServices()
            .searchBusinesses(mzansiSearchController.text, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(width),
    );
  }

  Widget getBody(double width) {
    return MihSingleChildScroll(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width / 20),
            child: MihSearchBar(
              controller: mzansiSearchController,
              hintText: "Search Mzansi",
              prefixIcon: Icons.search,
              prefixAltIcon: userSearch ? Icons.person : Icons.business,
              suffixTools: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        // searchTypeVisibility = !searchTypeVisibility;
                        userSearch = !userSearch;
                        if (userSearch) {
                          futureUserSearchResults = MihUserServices()
                              .searchUsers(
                                  mzansiSearchController.text, context);
                        } else {
                          futureBusinessSearchResults =
                              MihBusinessDetailsServices().searchBusinesses(
                                  mzansiSearchController.text, context);
                        }
                      });
                    },
                    icon: Icon(
                      Icons.swap_horiz_rounded,
                      size: 35,
                      color:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    ))
              ],
              fillColor:
                  MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              hintColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              onPrefixIconTap: () {
                if (userSearch) {
                  setState(() {
                    futureUserSearchResults = MihUserServices()
                        .searchUsers(mzansiSearchController.text, context);
                  });
                } else {
                  setState(() {
                    futureBusinessSearchResults = MihBusinessDetailsServices()
                        .searchBusinesses(mzansiSearchController.text, context);
                  });
                }
              },
              onClearIconTap: () {
                setState(() {
                  futureUserSearchResults = Future.value();
                  futureBusinessSearchResults = Future.value();
                  mzansiSearchController.clear();
                });
              },
              searchFocusNode: searchFocusNode,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder(
              future: futurePosition,
              builder: (context, asyncSnapshot) {
                String myLocation = "";
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  myLocation = "Getting Your GPS Location Ready";
                } else {
                  myLocation = asyncSnapshot.data
                      .toString()
                      .replaceAll("Latitude: ", "")
                      .replaceAll("Longitude: ", "");
                }
                return displaySearchResults(userSearch, myLocation);
              }),
        ],
      ),
    );
  }

  Widget displaySearchResults(bool userSearch, String myLocation) {
    if (userSearch) {
      return FutureBuilder(
        future: futureUserSearchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Mihloadingcircle();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.requireData!.isNotEmpty) {
            // return Text("Pulled Data successfully");
            snapshot.requireData!
                .sort((a, b) => a.username.compareTo(b.username));
            return Column(
              children: [
                Text(
                  "People of Mzansi",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                BuildUserSearchResultsList(userList: snapshot.requireData!),
              ],
            );
          } else if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(
                  MihIcons.personalProfile,
                  size: 165,
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                const SizedBox(height: 10),
                Text(
                  "People Of Mzansi!",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.requireData!.isEmpty) {
            // return Text("Pulled Data successfully");
            return Column(
              children: [
                const SizedBox(height: 50),
                Icon(
                  MihIcons.iDontKnow,
                  size: 165,
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                const SizedBox(height: 10),
                Text(
                  "Let's Try Refining Your Search",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                "Error pulling Patients Data\n/users/search/${mzansiSearchController.text}",
                style: TextStyle(
                    fontSize: 25,
                    color: MzansiInnovationHub.of(context)!.theme.errorColor()),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      );
    } else {
      return FutureBuilder(
        future: futureBusinessSearchResults,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Mihloadingcircle();
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.requireData!.isNotEmpty) {
            // return Text("Pulled Data successfully");
            snapshot.requireData!.sort((a, b) => a.Name.compareTo(b.Name));
            return Column(
              children: [
                Text(
                  "Businesses of Mzansi",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                BuildBusinessSearchResultsList(
                  businessList: snapshot.requireData!,
                  myLocation: myLocation,
                  startUpSearch: mzansiSearchController.text,
                ),
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData &&
              snapshot.requireData!.isEmpty) {
            // return Text("Pulled Data successfully");
            return Column(
              children: [
                const SizedBox(height: 50),
                Icon(
                  MihIcons.iDontKnow,
                  size: 165,
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                const SizedBox(height: 10),
                Text(
                  "Let's Try Refining Your Search",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            );
          } else if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(
                  MihIcons.businessProfile,
                  size: 165,
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                const SizedBox(height: 10),
                Text(
                  "Businesses Of Mzansi!",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text(
                "Error pulling Patients Data\n/users/search/${mzansiSearchController.text}",
                style: TextStyle(
                    fontSize: 25,
                    color: MzansiInnovationHub.of(context)!.theme.errorColor()),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      );
    }
  }
}
