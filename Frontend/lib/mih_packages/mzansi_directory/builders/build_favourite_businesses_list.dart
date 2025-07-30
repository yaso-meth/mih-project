import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_business_profile_preview.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';

class BuildFavouriteBusinessesList extends StatefulWidget {
  final List<BookmarkedBusiness> favouriteBusinesses;
  final String? myLocation;
  final String? searchQuery;
  const BuildFavouriteBusinessesList({
    super.key,
    required this.favouriteBusinesses,
    required this.myLocation,
    required this.searchQuery,
  });

  @override
  State<BuildFavouriteBusinessesList> createState() =>
      _BuildFavouriteBusinessesListState();
}

class _BuildFavouriteBusinessesListState
    extends State<BuildFavouriteBusinessesList> {
  List<Business?> businesses = [];

  List<Business?> getListOfBusinesses() {
    List<Business?> businesses = [];
    for (var item in widget.favouriteBusinesses) {
      MihBusinessDetailsServices()
          .getBusinessDetailsByBusinessId(item.business_id)
          .then((business) {
        if (business != null) {
          businesses.add(business);
        }
      });
    }
    return businesses;
  }

  @override
  void initState() {
    super.initState();
    businesses = getListOfBusinesses();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.favouriteBusinesses.length,
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: Theme.of(context).colorScheme.secondary,
        );
      },
      itemBuilder: (context, index) {
        Future<Business?> businessDetails =
            MihBusinessDetailsServices().getBusinessDetailsByBusinessId(
          widget.favouriteBusinesses[index].business_id,
        );
        return FutureBuilder<Business?>(
          future: businessDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              Business business = snapshot.data!;
              return Material(
                color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/business-profile/view',
                      arguments: BusinessViewArguments(
                        business,
                        business.Name,
                      ),
                    );
                  },
                  splashColor: MzansiInnovationHub.of(context)!
                      .theme
                      .secondaryColor()
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      // vertical: 5,
                      horizontal: 25,
                    ),
                    child: MihBusinessProfilePreview(
                        business: business, myLocation: widget.myLocation),
                  ),
                ),
              );
            } else {
              print(snapshot.data);
              return SizedBox();
            }
          },
        );
      },
    );
  }
}
