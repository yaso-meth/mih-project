import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_business_profile_preview.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:provider/provider.dart';

class BuildBusinessSearchResultsList extends StatefulWidget {
  final List<Business> businessList;
  const BuildBusinessSearchResultsList({
    super.key,
    required this.businessList,
  });

  @override
  State<BuildBusinessSearchResultsList> createState() =>
      _BuildBusinessSearchResultsListState();
}

class _BuildBusinessSearchResultsListState
    extends State<BuildBusinessSearchResultsList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiDirectoryProvider directoryProvider,
          Widget? child) {
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
                  directoryProvider.setSelectedBusiness(
                    business: widget.businessList[index],
                  );
                  context.pushNamed(
                    'businessProfileView',
                  );
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
                    imageFile: directoryProvider.busSearchImages![
                        widget.businessList[index].business_id],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
