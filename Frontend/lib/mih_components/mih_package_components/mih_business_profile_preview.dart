import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';
import 'package:provider/provider.dart';

class MihBusinessProfilePreview extends StatefulWidget {
  final Business business;
  const MihBusinessProfilePreview({
    super.key,
    required this.business,
  });

  @override
  State<MihBusinessProfilePreview> createState() =>
      _MihBusinessProfilePreviewState();
}

class _MihBusinessProfilePreviewState extends State<MihBusinessProfilePreview> {
  late Future<String> futureImageUrl;
  PlatformFile? file;

  String calculateDistance(MzansiDirectoryProvider directoryProvider) {
    try {
      double distanceInKm = MIHLocationAPI().getDistanceInMeaters(
              directoryProvider.userLocation, widget.business.gps_location) /
          1000;
      return "${distanceInKm.toStringAsFixed(2)} km";
    } catch (error) {
      print(error);
      return "*.** km";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double profilePictureWidth = 60;
    return Consumer<MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiDirectoryProvider directoryProvider,
          Widget? child) {
        return Row(
          children: [
            FutureBuilder(
                future: MihFileApi.getMinioFileUrl(widget.business.logo_path),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.done &&
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
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.business.Name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  widget.business.type,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  directoryProvider.userPosition != null
                      ? calculateDistance(directoryProvider)
                      : "0.00 km",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
