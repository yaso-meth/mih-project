import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_personal_profile_preview.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
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
          itemCount: widget.userList.length,
          separatorBuilder: (BuildContext context, index) {
            return Divider(
              color: MihColors.secondary(),
            );
          },
          itemBuilder: (context, index) {
            return Material(
              color: MihColors.primary(),
              child: InkWell(
                onTap: () {
                  directoryProvider.setSelectedUser(
                      user: widget.userList[index]);
                  context.pushNamed(
                    'mzansiProfileView',
                  );
                },
                splashColor: MihColors.secondary().withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    // vertical: 5,
                    horizontal: 25,
                  ),
                  child: MihPersonalProfilePreview(
                    user: widget.userList[index],
                    imageFile: CachedNetworkImageProvider(
                      MihFileApi.getMinioFileUrlV2(
                          widget.userList[index].pro_pic_path),
                    ),
                    loading: false,
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
