import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_business_profile_preview.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class BuildBusinessSearchResultsList extends StatefulWidget {
  final List<Business> businessList;
  final String myLocation;
  final String? startUpSearch;
  const BuildBusinessSearchResultsList({
    super.key,
    required this.businessList,
    required this.myLocation,
    required this.startUpSearch,
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
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
      itemBuilder: (context, index) {
        return Material(
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          child: InkWell(
            onTap: () {
              context.goNamed(
                'businessProfileView',
                extra: BusinessViewArguments(
                  widget.businessList[index],
                  widget.businessList[index].Name,
                ),
              );
              // // Navigator.of(context).pushNamed(
              // //   '/business-profile/view',
              // //   arguments: BusinessViewArguments(
              // //     widget.businessList[index],
              // //     widget.businessList[index].Name,
              // //   ),
              // );
            },
            splashColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark")
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
