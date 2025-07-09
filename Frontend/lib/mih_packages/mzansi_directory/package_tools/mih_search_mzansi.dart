import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
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
  const MihSearchMzansi({super.key});

  @override
  State<MihSearchMzansi> createState() => _MihSearchMzansiState();
}

class _MihSearchMzansiState extends State<MihSearchMzansi> {
  final TextEditingController mzansiSearchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  bool userSearch = true;
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
              suffixTools: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        // searchTypeVisibility = !searchTypeVisibility;
                        userSearch = !userSearch;
                      });
                    },
                    icon: Icon(
                      Icons.display_settings,
                      size: 35,
                      color:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    ))
              ],
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              hintColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Mihloadingcircle(
                    message: "Getting things ready for you",
                  );
                } else {
                  final myLocation = asyncSnapshot.data
                      .toString()
                      .replaceAll("Latitude: ", "")
                      .replaceAll("Longitude: ", "");
                  print("My Location is : $myLocation");
                  return displaySearchResults(userSearch, myLocation);
                }
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
              snapshot.hasData) {
            // return Text("Pulled Data successfully");
            return BuildUserSearchResultsList(userList: snapshot.requireData!);
          } else if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 165,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
                    color: MzanziInnovationHub.of(context)!.theme.errorColor()),
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
              snapshot.hasData) {
            // return Text("Pulled Data successfully");
            return BuildBusinessSearchResultsList(
              businessList: snapshot.requireData!,
              myLocation: myLocation,
            );
          } else if (!snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 165,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
                    color: MzanziInnovationHub.of(context)!.theme.errorColor()),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      );
    }
  }
}
