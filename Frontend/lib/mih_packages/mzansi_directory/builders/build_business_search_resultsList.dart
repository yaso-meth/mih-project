import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_business_profile_preview.dart';

class BuildBusinessSearchResultsList extends StatefulWidget {
  final List<Business> businessList;
  final String myLocation;
  const BuildBusinessSearchResultsList({
    super.key,
    required this.businessList,
    required this.myLocation,
  });

  @override
  State<BuildBusinessSearchResultsList> createState() =>
      _BuildBusinessSearchResultsListState();
}

class _BuildBusinessSearchResultsListState
    extends State<BuildBusinessSearchResultsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.businessList.length,
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemBuilder: (context, index) {
        return Material(
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/business-profile/view',
                arguments: widget.businessList[index],
              );
            },
            splashColor: MzanziInnovationHub.of(context)!
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
                business: widget.businessList[index],
                myLocation: widget.myLocation,
              ),
            ),
          ),
        );
      },
    );
  }
}
