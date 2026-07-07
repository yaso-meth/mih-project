import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_profile_links_service.dart';
import 'package:provider/provider.dart';
import 'package:redacted/redacted.dart';

class MihPersonalProfileView extends StatefulWidget {
  const MihPersonalProfileView({
    super.key,
  });

  @override
  State<MihPersonalProfileView> createState() => _MihPersonalProfileViewState();
}

class _MihPersonalProfileViewState extends State<MihPersonalProfileView> {
  late Future<String> futureImageUrl;
  late Future<List<ProfileLink>> futureLinks;
  PlatformFile? file;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    futureImageUrl = MihFileApi.getMinioFileUrl(
        directoryProvider.selectedUser!.pro_pic_path);
    futureLinks = MihProfileLinksServices.getUserProfileLinksMD(
        directoryProvider, directoryProvider.selectedUser!.app_id);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(screenWidth),
    );
  }

  Widget getBody(double width) {
    double profilePictureWidth = 150;
    return Consumer<MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiDirectoryProvider directoryProvider,
          Widget? child) {
        return Column(
          children: [
            Expanded(
              child: MihSingleChildScroll(
                scrollbarOn: true,
                child: Padding(
                  padding: MzansiInnovationHub.of(context)!.theme.screenType ==
                          "desktop"
                      ? EdgeInsets.symmetric(horizontal: width * 0.2)
                      : EdgeInsets.symmetric(horizontal: width * 0.075),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MihCircleAvatar(
                        imageFile: CachedNetworkImageProvider(
                          MihFileApi.getMinioFileUrlV2(
                            directoryProvider.selectedUser!.pro_pic_path,
                          ),
                        ),
                        width: profilePictureWidth,
                        expandable: true,
                        editable: false,
                        fileNameController: TextEditingController(),
                        userSelectedfile: file,
                        frameColor: MihColors.secondary(),
                        backgroundColor: MihColors.primary(),
                        onChange: () {},
                      ),
                      FittedBox(
                        child: Text(
                          directoryProvider.selectedUser!.username.isNotEmpty
                              ? directoryProvider.selectedUser!.username
                              : "Username",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: MihColors.secondary(),
                          ),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          directoryProvider.selectedUser!.fname.isNotEmpty
                              ? "${directoryProvider.selectedUser!.fname} ${directoryProvider.selectedUser!.lname}"
                              : "Name Surname",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: MihColors.secondary(),
                          ),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          directoryProvider.selectedUser!.type.toUpperCase(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: MihColors.secondary(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Center(
                        child: SizedBox(
                          width: 700,
                          child: Text(
                            directoryProvider.selectedUser!.purpose.isNotEmpty
                                ? directoryProvider.selectedUser!.purpose
                                : "No Personal Mission added yet",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: MihColors.secondary(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      FutureBuilder(
                        future: futureLinks,
                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.connectionState ==
                                  ConnectionState.done &&
                              asyncSnapshot.hasData) {
                            return MihProfileLinks(
                              links: asyncSnapshot.requireData,
                            );
                          } else {
                            return Wrap(
                              alignment: WrapAlignment.center,
                              runAlignment: WrapAlignment.center,
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                Container(width: 70, height: 70).redacted(
                                  context: context,
                                  redact: true,
                                ),
                                Container(width: 70, height: 70).redacted(
                                  context: context,
                                  redact: true,
                                ),
                                Container(width: 70, height: 70).redacted(
                                  context: context,
                                  redact: true,
                                ),
                                Container(width: 70, height: 70).redacted(
                                  context: context,
                                  redact: true,
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            !kIsWeb && (Platform.isAndroid || Platform.isIOS)
                ? MihBannerAd()
                : SizedBox(),
            SizedBox(height: 10),
          ],
        );
      },
    );
  }
}
