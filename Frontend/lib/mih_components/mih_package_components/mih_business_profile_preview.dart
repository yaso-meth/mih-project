import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';

class MihBusinessProfilePreview extends StatefulWidget {
  final Business business;
  final String? myLocation;
  const MihBusinessProfilePreview({
    super.key,
    required this.business,
    required this.myLocation,
  });

  @override
  State<MihBusinessProfilePreview> createState() =>
      _MihBusinessProfilePreviewState();
}

class _MihBusinessProfilePreviewState extends State<MihBusinessProfilePreview> {
  late Future<String> futureImageUrl;
  PlatformFile? file;

  String calculateDistance() {
    try {
      double distanceInKm = MIHLocationAPI().getDistanceInMeaters(
              widget.myLocation!, widget.business.gps_location) /
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
    futureImageUrl =
        MihFileApi.getMinioFileUrl(widget.business.logo_path, context);
  }

  @override
  Widget build(BuildContext context) {
    double profilePictureWidth = 60;
    return Row(
      children: [
        FutureBuilder(
            future: futureImageUrl,
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
                    frameColor:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    backgroundColor:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    onChange: () {},
                  );
                } else {
                  return Icon(
                    MihIcons.iDontKnow,
                    size: profilePictureWidth,
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  );
                }
              } else {
                return Icon(
                  MihIcons.mihRing,
                  size: profilePictureWidth,
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
              widget.myLocation != null || widget.myLocation!.isEmpty
                  ? calculateDistance()
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
  }
}
