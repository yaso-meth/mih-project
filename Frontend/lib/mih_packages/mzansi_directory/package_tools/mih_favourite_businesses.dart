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

  Future<List<BookmarkedBusiness>> getAllBookmarkedBusinessesForUser() async {
    String user_id = await SuperTokens.getUserId();
    return MihMzansiDirectoryServices().getAllUserBookmarkedBusiness(user_id);
  }

  @override
  void initState() {
    super.initState();
    boookmarkedBusinessListFuture = getAllBookmarkedBusinessesForUser();
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
                    List<BookmarkedBusiness> bookmarkedBusinesses =
                        snapshot.data!;
                    return BuildFavouriteBusinessesList(
                      favouriteBusinesses: bookmarkedBusinesses,
                      myLocation: widget.myLocation,
                    );
                  } else {
                    return Center(
                      child: Text("No bookmarked businesses found"),
                    );
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
