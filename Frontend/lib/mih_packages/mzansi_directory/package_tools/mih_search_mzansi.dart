import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/builders/build_business_search_resultsList.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/builders/build_user_search_results_list.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:provider/provider.dart';

class MihSearchMzansi extends StatefulWidget {
  const MihSearchMzansi({
    super.key,
  });

  @override
  State<MihSearchMzansi> createState() => _MihSearchMzansiState();
}

class _MihSearchMzansiState extends State<MihSearchMzansi> {
  final TextEditingController mzansiSearchController = TextEditingController();
  final TextEditingController businessTypeController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  // late bool userSearch;
  // Future<List<AppUser>?> futureUserSearchResults = Future.value();
  List<AppUser> userSearchResults = [];
  List<Business> businessSearchResults = [];
  late Future<List<String>> availableBusinessTypes;
  bool filterOn = false;
  bool loadingSearchResults = false;
  Future<void> swapPressed(MzansiProfileProvider profileProvider,
      MzansiDirectoryProvider directoryProvider) async {
    directoryProvider.setPersonalSearch(!directoryProvider.personalSearch);
    setState(() {
      if (filterOn) {
        filterOn = !filterOn;
      }
    });
    if (businessTypeController.text.isNotEmpty) {
      setState(() {
        businessTypeController.clear();
      });
    }
    await searchPressed(profileProvider, directoryProvider);
  }

  void clearAll(MzansiDirectoryProvider directoryProvider) {
    directoryProvider
        .setSearchedBusinesses(searchedBusinesses: [], businessesImagesUrl: {});
    directoryProvider.setSearchedUsers(searchedUsers: [], userImagesUrl: {});
    directoryProvider.setSearchTerm(searchTerm: "");
    setState(() {
      mzansiSearchController.clear();
      businessTypeController.clear();
    });
  }

  Future<void> searchPressed(MzansiProfileProvider profileProvider,
      MzansiDirectoryProvider directoryProvider) async {
    setState(() {
      loadingSearchResults = true;
    });
    directoryProvider.setSearchTerm(searchTerm: mzansiSearchController.text);
    directoryProvider.setBusinessTypeFilter(
        businessTypeFilter: businessTypeController.text);
    if (directoryProvider.personalSearch &&
        directoryProvider.searchTerm.isNotEmpty) {
      final userResults = await MihUserServices()
          .searchUsers(profileProvider, directoryProvider.searchTerm, context);
      Map<String, Future<String>> userImages = {};
      Future<String> usernProPicUrl;
      for (var user in userResults) {
        KenLogger.success("Business Logo Path: ${user.pro_pic_path}");
        usernProPicUrl = MihFileApi.getMinioFileUrl(user.pro_pic_path);
        KenLogger.success("Business Logo Path: ${user.pro_pic_path}");
        userImages[user.app_id] = usernProPicUrl;
        // != ""
        //     ? CachedNetworkImageProvider(usernProPicUrl)
        //     : null;
      }

      directoryProvider.setSearchedUsers(
        searchedUsers: userResults,
        userImagesUrl: userImages,
      );
    } else {
      List<Business>? businessSearchResults = [];
      if (directoryProvider.businessTypeFilter.isNotEmpty) {
        businessSearchResults = await MihBusinessDetailsServices()
            .searchBusinesses(directoryProvider.searchTerm,
                directoryProvider.businessTypeFilter, context);
      } else if (directoryProvider.searchTerm.isNotEmpty) {
        businessSearchResults = await MihBusinessDetailsServices()
            .searchBusinesses(directoryProvider.searchTerm,
                directoryProvider.businessTypeFilter, context);
      }
      Map<String, Future<String>> busImagesUrl = {};
      Future<String> businessLogoUrl;
      for (var bus in businessSearchResults) {
        KenLogger.success("Business Logo Path: ${bus.logo_path}");
        businessLogoUrl = MihFileApi.getMinioFileUrl(bus.logo_path);
        KenLogger.success("Business Logo Path: ${bus.logo_path}");
        busImagesUrl[bus.business_id] = businessLogoUrl;
        // != ""
        //     ? CachedNetworkImageProvider(businessLogoUrl)
        //     : null;
      }
      directoryProvider.setSearchedBusinesses(
        searchedBusinesses: businessSearchResults,
        businessesImagesUrl: busImagesUrl,
      );
    }
    setState(() {
      loadingSearchResults = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    businessTypeController.dispose();
    mzansiSearchController.dispose();
  }

  @override
  void initState() {
    super.initState();
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    availableBusinessTypes =
        MihBusinessDetailsServices().fetchAllBusinessTypes();
    mzansiSearchController.text = "";
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      directoryProvider.setSearchedUsers(
        searchedUsers: [],
        userImagesUrl: {},
      );
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
    return Consumer2<MzansiProfileProvider, MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          MzansiDirectoryProvider directoryProvider, Widget? child) {
        return Column(
          children: [
            Text(
              directoryProvider.personalSearch
                  ? "People Search"
                  : "Businesses Search",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width / 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: MihSearchBar(
                      controller: mzansiSearchController,
                      hintText: "Search Mzansi",
                      prefixIcon: Icons.search,
                      prefixAltIcon: directoryProvider.personalSearch
                          ? Icons.person
                          : Icons.business,
                      suffixTools: [
                        IconButton(
                          onPressed: () {
                            swapPressed(profileProvider, directoryProvider);
                          },
                          icon: Icon(
                            Icons.swap_horiz_rounded,
                            size: 35,
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                          ),
                        ),
                      ],
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      hintColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      onPrefixIconTap: () {
                        searchPressed(profileProvider, directoryProvider);
                      },
                      onClearIconTap: () {
                        clearAll(directoryProvider);
                      },
                      searchFocusNode: searchFocusNode,
                    ),
                  ),
                  Visibility(
                    visible: !directoryProvider.personalSearch,
                    child: const SizedBox(width: 10),
                  ),
                  Visibility(
                    visible: !directoryProvider.personalSearch,
                    child: IconButton(
                      onPressed: () {
                        if (filterOn) {
                          clearAll(directoryProvider);
                        }
                        setState(() {
                          filterOn = !filterOn;
                        });
                      },
                      icon: Icon(
                        !filterOn
                            ? Icons.filter_list_rounded
                            : Icons.filter_list_off_rounded,
                        size: 35,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder(
                future: availableBusinessTypes,
                builder: (context, asyncSnapshot) {
                  List<String> options = [];
                  if (asyncSnapshot.connectionState == ConnectionState.done) {
                    options.addAll(asyncSnapshot.data!);
                  }
                  return Visibility(
                    visible: filterOn,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width / 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: MihDropdownField(
                              controller: businessTypeController,
                              hintText: "Business Type",
                              dropdownOptions: options,
                              requiredText: true,
                              editable: true,
                              enableSearch: true,
                            ),
                          ),
                          const SizedBox(width: 10),
                          MihButton(
                            onPressed: () {
                              if (businessTypeController.text.isNotEmpty) {
                                searchPressed(
                                    profileProvider, directoryProvider);
                              } else {
                                MihAlertServices().errorBasicAlert(
                                  "Business Type Not Selected",
                                  "Please ensure you have selected a Business Type before seareching for Businesses of Mzansi",
                                  context,
                                );
                              }
                            },
                            buttonColor: MihColors.getGreenColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            elevation: 10,
                            child: Text(
                              "Search",
                              style: TextStyle(
                                color: MihColors.getPrimaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            const SizedBox(height: 10),
            Expanded(
              child: directoryProvider.personalSearch
                  ? displayPersonalSearchResults(directoryProvider)
                  : displayBusinessSearchResults(directoryProvider),
            ),
          ],
        );
      },
    );
  }

  Widget displayBusinessSearchResults(
      MzansiDirectoryProvider directoryProvider) {
    if (directoryProvider.searchedBusinesses == null || loadingSearchResults) {
      return Center(
        child: const Mihloadingcircle(),
      );
    } else if (directoryProvider.searchedBusinesses!.isNotEmpty) {
      // return Text("Pulled Data successfully");
      directoryProvider.searchedBusinesses!
          .sort((a, b) => a.Name.compareTo(b.Name));
      return BuildBusinessSearchResultsList(
        businessList: directoryProvider.searchedBusinesses!,
      );
    } else if (directoryProvider.searchedBusinesses!.isEmpty &&
        directoryProvider.searchTerm.isNotEmpty) {
      return MihSingleChildScroll(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Icon(
              MihIcons.iDontKnow,
              size: 165,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            const SizedBox(height: 25),
            Text(
              "Let's try refining your search",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
          ],
        ),
      );
    } else if (directoryProvider.searchedBusinesses!.isEmpty &&
        directoryProvider.searchTerm.isEmpty) {
      return MihSingleChildScroll(
        child: Padding(
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
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              const SizedBox(height: 10),
              Text(
                "Search for businesses of Mzansi!",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    children: [
                      TextSpan(text: "Press "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.swap_horiz_rounded,
                          size: 20,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                      TextSpan(text: " to search for people of Mzansi"),
                    ],
                  ),
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
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    children: [
                      TextSpan(text: "Press "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.filter_list_rounded,
                          size: 20,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                      TextSpan(text: " to filter business types"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          "Error pulling Patients Data\n/users/search/${directoryProvider.searchTerm}",
          style: TextStyle(
              fontSize: 25,
              color: MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark")),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget displayPersonalSearchResults(
      MzansiDirectoryProvider directoryProvider) {
    if (directoryProvider.searchedUsers == null || loadingSearchResults) {
      return Center(
        child: const Mihloadingcircle(),
      );
    } else if (directoryProvider.searchedUsers!.isNotEmpty) {
      directoryProvider.searchedUsers!
          .sort((a, b) => a.username.compareTo(b.username));
      return BuildUserSearchResultsList(
          userList: directoryProvider.searchedUsers!);
    } else if (directoryProvider.searchedUsers!.isEmpty &&
        directoryProvider.searchTerm.isEmpty) {
      return MihSingleChildScroll(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Icon(
                MihIcons.personalProfile,
                size: 165,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              const SizedBox(height: 10),
              Text(
                "Search for people of Mzansi!",
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    children: [
                      TextSpan(text: "Press "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.swap_horiz_rounded,
                          size: 20,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                      TextSpan(text: " to search for businesses of Mzansi"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (directoryProvider.searchedUsers!.isEmpty &&
        directoryProvider.searchTerm.isNotEmpty) {
      return MihSingleChildScroll(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Icon(
              MihIcons.iDontKnow,
              size: 165,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          "Error pulling Patients Data\n/users/search/${directoryProvider.searchTerm}",
          style: TextStyle(
              fontSize: 25,
              color: MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark")),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
