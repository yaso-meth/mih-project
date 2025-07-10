import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';

class MihPersonalProfilePreview extends StatefulWidget {
  final AppUser user;
  const MihPersonalProfilePreview({
    super.key,
    required this.user,
  });

  @override
  State<MihPersonalProfilePreview> createState() =>
      _MihPersonalProfilePreviewState();
}

class _MihPersonalProfilePreviewState extends State<MihPersonalProfilePreview> {
  late Future<String> futureImageUrl;
  // String imageUrl = "";
  PlatformFile? file;

  @override
  void initState() {
    super.initState();
    futureImageUrl =
        MihFileApi.getMinioFileUrl(widget.user.pro_pic_path, context);
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
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  backgroundColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  onChange: () {},
                );
              } else {
                return Icon(
                  MihIcons.iDontKnow,
                  size: profilePictureWidth,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                );
              }
            } else {
              return Icon(
                MihIcons.mihRing,
                size: profilePictureWidth,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              );
            }
          },
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.username.isNotEmpty
                  ? widget.user.username
                  : "Username",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.user.fname.isNotEmpty
                  ? "${widget.user.fname} ${widget.user.lname}"
                  : "Name Surname",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              widget.user.type.toUpperCase(),
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
