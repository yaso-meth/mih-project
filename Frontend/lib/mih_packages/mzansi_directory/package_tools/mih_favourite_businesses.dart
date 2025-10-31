import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/builders/build_favourite_businesses_list.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';
import 'package:provider/provider.dart';

class MihFavouriteBusinesses extends StatefulWidget {
  const MihFavouriteBusinesses({
    super.key,
  });

  @override
  State<MihFavouriteBusinesses> createState() => _MihFavouriteBusinessesState();
}

class _MihFavouriteBusinessesState extends State<MihFavouriteBusinesses> {
  final TextEditingController businessSearchController =
      TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final ValueNotifier<List<Business?>> searchBookmarkedBusinesses =
      ValueNotifier([]);
  Timer? _debounce;

  Future<void> getAndMapAllBusinessDetailsForBookmarkedBusinesses(
    MzansiProfileProvider mzansiProfileProvider,
    MzansiDirectoryProvider directoryProvider,
  ) async {
    await MihMzansiDirectoryServices().getAllUserBookmarkedBusiness(
      mzansiProfileProvider.user!.app_id,
      directoryProvider,
    );
    Map<String, Business?> businessMap = {};
    List<Future<Business?>> detailFutures = [];
    for (var item in directoryProvider.bookmarkedBusinesses) {
      detailFutures.add(MihBusinessDetailsServices()
          .getBusinessDetailsByBusinessId(item.business_id));
    }
    List<Business?> details = await Future.wait(detailFutures);
    for (int i = 0; i < directoryProvider.bookmarkedBusinesses.length; i++) {
      businessMap[directoryProvider.bookmarkedBusinesses[i].business_id] =
          details[i];
    }
    directoryProvider.setBusinessDetailsMap(detailsMap: businessMap);
    _filterAndSetBusinesses(directoryProvider);
  }

  void _filterAndSetBusinesses(MzansiDirectoryProvider directoryProvider) {
    List<Business?> businessesToDisplay = [];
    String query = businessSearchController.text.toLowerCase();
    for (var bookmarked in directoryProvider.bookmarkedBusinesses) {
      if (bookmarked.business_name.toLowerCase().contains(query)) {
        if (directoryProvider.businessDetailsMap
            .containsKey(bookmarked.business_id)) {
          businessesToDisplay.add(
              directoryProvider.businessDetailsMap[bookmarked.business_id]);
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
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();

    getAndMapAllBusinessDetailsForBookmarkedBusinesses(
      mzansiProfileProvider,
      directoryProvider,
    );
    businessSearchController.addListener(() {
      if (_debounce?.isActive ?? false) {
        _debounce!.cancel();
      }
      _debounce = Timer(const Duration(milliseconds: 200), () {
        _filterAndSetBusinesses(directoryProvider);
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
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              hintColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              onPrefixIconTap: () {},
              searchFocusNode: searchFocusNode,
            ),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<List<Business?>>(
              valueListenable: searchBookmarkedBusinesses,
              builder: (context, filteredBusinesses, child) {
                if (filteredBusinesses.isEmpty &&
                    businessSearchController.text.isNotEmpty) {
                  return Column(
                    children: [
                      const SizedBox(height: 50),
                      Icon(
                        MihIcons.iDontKnow,
                        size: 165,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Let's try refining your search",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                    ],
                  );
                } else if (filteredBusinesses.isEmpty &&
                    businessSearchController.text.isEmpty) {
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
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "No favourite businesses added to your mzansi directory",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
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
                                color: MihColors.getSecondaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
                              ),
                              children: [
                                TextSpan(text: "Use the mzansi search"),
                                TextSpan(
                                    text:
                                        " to find your favourite businesses of mzansi"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return BuildFavouriteBusinessesList(
                  favouriteBusinesses: filteredBusinesses,
                );
              }),
        ],
      ),
    );
  }
}
