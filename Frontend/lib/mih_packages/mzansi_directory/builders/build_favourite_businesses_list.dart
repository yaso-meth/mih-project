import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_business_profile_preview.dart';

class BuildFavouriteBusinessesList extends StatefulWidget {
  final List<Business?> favouriteBusinesses;
  final String? myLocation;
  const BuildFavouriteBusinessesList({
    super.key,
    required this.favouriteBusinesses,
    required this.myLocation,
  });

  @override
  State<BuildFavouriteBusinessesList> createState() =>
      _BuildFavouriteBusinessesListState();
}

class _BuildFavouriteBusinessesListState
    extends State<BuildFavouriteBusinessesList> {
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
        final Business? business = widget.favouriteBusinesses[index];

        if (business == null) {
          return const SizedBox(); // Or a placeholder if a business couldn't be loaded
        }

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
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: MihBusinessProfilePreview(
                  business: business, myLocation: widget.myLocation),
            ),
          ),
        );
      },
    );
  }
}
