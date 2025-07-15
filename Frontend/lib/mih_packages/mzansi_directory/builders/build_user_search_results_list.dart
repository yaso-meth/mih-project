import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_personal_profile_preview.dart';

class BuildUserSearchResultsList extends StatefulWidget {
  final List<AppUser> userList;
  const BuildUserSearchResultsList({
    super.key,
    required this.userList,
  });

  @override
  State<BuildUserSearchResultsList> createState() =>
      _BuildUserSearchResultsListState();
}

class _BuildUserSearchResultsListState
    extends State<BuildUserSearchResultsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.userList.length,
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemBuilder: (context, index) {
        return Material(
          color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/mzansi-profile/view',
                arguments: widget.userList[index],
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
              child: MihPersonalProfilePreview(
                user: widget.userList[index],
              ),
            ),
          ),
        );
      },
    );
  }
}
