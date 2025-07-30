import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/builders/build_favourite_businesses_list.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';
import 'package:supertokens_flutter/supertokens.dart';

class MihFavouriteBusinesses extends StatefulWidget {
  final String? myLocation;
  const MihFavouriteBusinesses({
    super.key,
    required this.myLocation,
  });

  @override
  State<MihFavouriteBusinesses> createState() => _MihFavouriteBusinessesState();
}

class _MihFavouriteBusinessesState extends State<MihFavouriteBusinesses> {
  final TextEditingController businessSearchController =
      TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  late Future<List<BookmarkedBusiness>> boookmarkedBusinessListFuture;
  List<BookmarkedBusiness> listBookmarkedBusinesses = [];
  final ValueNotifier<List<BookmarkedBusiness>> searchBookmarkedBusinesses =
      ValueNotifier([]);
  Future<List<BookmarkedBusiness>> getAllBookmarkedBusinessesForUser() async {
    String user_id = await SuperTokens.getUserId();
    return MihMzansiDirectoryServices().getAllUserBookmarkedBusiness(user_id);
  }

  void searchBookmarkedBusinessByName() {
    if (businessSearchController.text.isEmpty) {
      searchBookmarkedBusinesses.value = listBookmarkedBusinesses;
    } else {
      List<BookmarkedBusiness> temp = [];
      for (var item in listBookmarkedBusinesses) {
        if (item.business_name
            .toLowerCase()
            .contains(businessSearchController.text.toLowerCase())) {
          temp.add(item);
        }
      }
      searchBookmarkedBusinesses.value = temp;
    }
  }

  @override
  void dispose() {
    super.dispose();
    businessSearchController.removeListener(searchBookmarkedBusinessByName);
    businessSearchController.dispose();
    searchFocusNode.dispose();
    searchBookmarkedBusinesses.dispose();
  }

  @override
  void initState() {
    super.initState();
    boookmarkedBusinessListFuture = getAllBookmarkedBusinessesForUser();
    businessSearchController.addListener(searchBookmarkedBusinessByName);
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
              controller: businessSearchController,
              hintText: "Search Businesses",
              prefixIcon: Icons.search,
              fillColor:
                  MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              hintColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              onPrefixIconTap: () {},
              searchFocusNode: searchFocusNode,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder(
              future: boookmarkedBusinessListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Mihloadingcircle(
                    message: "Getting your favourites",
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    listBookmarkedBusinesses = snapshot.data!;
                    searchBookmarkedBusinessByName();
                    return ValueListenableBuilder(
                        valueListenable: searchBookmarkedBusinesses,
                        builder: (context, value, child) {
                          return BuildFavouriteBusinessesList(
                            favouriteBusinesses: value,
                            myLocation: widget.myLocation,
                            searchQuery: businessSearchController.text,
                          );
                        });
                  } else {
                    return Column(
                      children: [
                        const SizedBox(height: 50),
                        Icon(
                          Icons.business_center_rounded,
                          size: 150,
                          color: MzansiInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: SizedBox(
                            width: 500,
                            child: Text(
                              "No favourites yet, use Mzansi Search to find and bookmark businesses you like",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                    // return Center(
                    //   child: Text("No bookmarked businesses found"),
                    // );
                  }
                } else {
                  return Center(
                    child: Text("Error loading bookmarked businesses"),
                  );
                }
              }),
        ],
      ),
    );
  }
}
