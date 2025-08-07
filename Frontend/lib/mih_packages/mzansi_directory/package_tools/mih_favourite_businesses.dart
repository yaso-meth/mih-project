import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/builders/build_favourite_businesses_list.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
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
  final ValueNotifier<List<Business?>> searchBookmarkedBusinesses =
      ValueNotifier([]);
  late Future<Map<String, Business?>> businessDetailsMapFuture;
  Map<String, Business?> _businessDetailsMap = {};
  Timer? _debounce;

  Future<Map<String, Business?>>
      getAndMapAllBusinessDetailsForBookmarkedBusinesses() async {
    String user_id = await SuperTokens.getUserId();
    List<BookmarkedBusiness> bookmarked = await MihMzansiDirectoryServices()
        .getAllUserBookmarkedBusiness(user_id);
    listBookmarkedBusinesses = bookmarked;
    Map<String, Business?> businessMap = {};
    List<Future<Business?>> detailFutures = [];
    for (var item in bookmarked) {
      detailFutures.add(MihBusinessDetailsServices()
          .getBusinessDetailsByBusinessId(item.business_id));
    }
    List<Business?> details = await Future.wait(detailFutures);
    for (int i = 0; i < bookmarked.length; i++) {
      businessMap[bookmarked[i].business_id] = details[i];
    }
    _businessDetailsMap = businessMap;
    _filterAndSetBusinesses();
    return businessMap;
  }

  void _filterAndSetBusinesses() {
    List<Business?> businessesToDisplay = [];
    String query = businessSearchController.text.toLowerCase();
    for (var bookmarked in listBookmarkedBusinesses) {
      if (bookmarked.business_name.toLowerCase().contains(query)) {
        if (_businessDetailsMap.containsKey(bookmarked.business_id)) {
          businessesToDisplay.add(_businessDetailsMap[bookmarked.business_id]);
        }
      }
    }
    searchBookmarkedBusinesses.value = businessesToDisplay;
  }

  @override
  void dispose() {
    super.dispose();
    businessSearchController.dispose();
    searchFocusNode.dispose();
    searchBookmarkedBusinesses.dispose();
  }

  @override
  void initState() {
    super.initState();
    businessDetailsMapFuture =
        getAndMapAllBusinessDetailsForBookmarkedBusinesses();
    businessSearchController.addListener(() {
      if (_debounce?.isActive ?? false) {
        _debounce!.cancel();
      }
      _debounce = Timer(const Duration(milliseconds: 200), () {
        _filterAndSetBusinesses();
      });
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
          FutureBuilder<Map<String, Business?>>(
              future: businessDetailsMapFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Mihloadingcircle(
                    message: "Getting your favourites",
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    // No need to re-filter here, _filterAndSetBusinesses is called in initState
                    // and by the text controller listener.
                    return ValueListenableBuilder<List<Business?>>(
                      valueListenable:
                          searchBookmarkedBusinesses, // Listen to changes in this
                      builder: (context, businesses, child) {
                        // Display message if no results after search
                        if (businesses.isEmpty &&
                            businessSearchController.text.isNotEmpty) {
                          return Column(
                            children: [
                              const SizedBox(height: 50),
                              Icon(
                                MihIcons.iDontKnow,
                                size: 165,
                                color: MzansiInnovationHub.of(context)!
                                    .theme
                                    .secondaryColor(),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Let's Try Refining Your Search",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: MzansiInnovationHub.of(context)!
                                      .theme
                                      .secondaryColor(),
                                ),
                              ),
                            ],
                          );
                        }
                        return BuildFavouriteBusinessesList(
                          favouriteBusinesses:
                              businesses, // Pass the filtered list from ValueNotifier
                          myLocation: widget.myLocation,
                        );
                      },
                    );
                  } else {
                    // This block handles the case where there are no bookmarked businesses initially

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          Icon(
                            MihIcons.businessProfile,
                            size: 165,
                            color: MzansiInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "No Businesses added to your Favourites",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: MzansiInnovationHub.of(context)!
                                  .theme
                                  .secondaryColor(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: MzansiInnovationHub.of(context)!
                                      .theme
                                      .secondaryColor(),
                                ),
                                children: [
                                  TextSpan(text: "Use the Mzansi Search"),
                                  // WidgetSpan(
                                  //   alignment:
                                  //       PlaceholderAlignment.middle,
                                  //   child: Icon(
                                  //     Icons.search,
                                  //     size: 20,
                                  //     color:
                                  //         MzansiInnovationHub.of(context)!
                                  //             .theme
                                  //             .secondaryColor(),
                                  //   ),
                                  // ),
                                  TextSpan(
                                      text: " to find Businesses of Mzansi"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Error loading bookmarked businesses: ${snapshot.error}"), // Show specific error
                  );
                } else {
                  // Fallback for unexpected states
                  return Center(
                    child: Text("An unknown error occurred."),
                  );
                }
              }),
        ],
      ),
    );
  }
}
