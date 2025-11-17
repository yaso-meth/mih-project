import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MihPersonalProfileView extends StatefulWidget {
  const MihPersonalProfileView({
    super.key,
  });

  @override
  State<MihPersonalProfileView> createState() => _MihPersonalProfileViewState();
}

class _MihPersonalProfileViewState extends State<MihPersonalProfileView> {
  late Future<String> futureImageUrl;
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
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
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
        return MihSingleChildScroll(
          child: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: futureImageUrl,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                              ConnectionState.done &&
                          asyncSnapshot.hasData) {
                        if (asyncSnapshot.requireData != "") {
                          return MihCircleAvatar(
                            imageFile: NetworkImage(asyncSnapshot.requireData),
                            width: profilePictureWidth,
                            editable: false,
                            fileNameController: TextEditingController(),
                            userSelectedfile: file,
                            frameColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            backgroundColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            onChange: () {},
                          );
                        } else {
                          return Icon(
                            MihIcons.iDontKnow,
                            size: profilePictureWidth,
                            color: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                          );
                        }
                      } else {
                        return Icon(
                          MihIcons.mihRing,
                          size: profilePictureWidth,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        );
                      }
                    }),
                FittedBox(
                  child: Text(
                    directoryProvider.selectedUser!.username.isNotEmpty
                        ? directoryProvider.selectedUser!.username
                        : "Username",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
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
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    directoryProvider.selectedUser!.type.toUpperCase(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
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
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
