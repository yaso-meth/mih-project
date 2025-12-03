import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_personal_profile_preview.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:provider/provider.dart';

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
    return Consumer<MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiDirectoryProvider directoryProvider,
          Widget? child) {
        return ListView.separated(
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.userList.length,
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
                  directoryProvider.setSelectedUser(
                      user: widget.userList[index]);
                  context.pushNamed(
                    'mzansiProfileView',
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
                  child: FutureBuilder(
                      future: directoryProvider
                          .userSearchImagesUrl![widget.userList[index].app_id],
                      builder: (context, asyncSnapshot) {
                        ImageProvider<Object>? imageFile;
                        bool loading = true;
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.done) {
                          loading = false;
                          if (asyncSnapshot.hasData) {
                            imageFile = asyncSnapshot.requireData != ""
                                ? CachedNetworkImageProvider(
                                    asyncSnapshot.requireData)
                                : null;
                          } else {
                            imageFile = null;
                          }
                        } else {
                          imageFile = null;
                        }
                        return MihPersonalProfilePreview(
                          user: widget.userList[index],
                          imageFile: imageFile,
                          loading: loading,
                        );
                      }),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
