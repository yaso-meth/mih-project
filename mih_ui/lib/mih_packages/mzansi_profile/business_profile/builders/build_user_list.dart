import 'package:cached_network_image/cached_network_image.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_add_employee_window.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:provider/provider.dart';

class BuildUserList extends StatefulWidget {
  const BuildUserList({
    super.key,
  });

  @override
  State<BuildUserList> createState() => _BuildUserListState();
}

class _BuildUserListState extends State<BuildUserList> {
  final baseAPI = AppEnviroment.baseApiUrl;

  String hideEmail(String email) {
    var firstLetter = email[0];
    var end = email.split("@")[1];
    return "$firstLetter********@$end";
  }

  void addEmployeePopUp(
      MzansiProfileProvider profileProvider, int index, double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihAddEmployeeWindow(
        user: profileProvider.userSearchResults[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          Widget? child) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, index) {
            return SizedBox(
              height: 3,
            );
          },
          itemCount: profileProvider.userSearchResults.length,
          itemBuilder: (context, index) {
            var isYou = "";
            if (profileProvider.user!.app_id ==
                profileProvider.userSearchResults[index].app_id) {
              isYou = "(You)";
            }
            ImageProvider? image;
            if (profileProvider.userSearchResults[index].pro_pic_path == '' ||
                profileProvider.userSearchResults[index].pro_pic_path
                    .endsWith('/')) {
              image = null;
            } else {
              String? userPicUrl = MihFileApi.getMinioFileUrlV2(
                  profileProvider.userSearchResults[index].pro_pic_path);
              image = CachedNetworkImageProvider(userPicUrl);
            }
            return Material(
              color: MihColors.highlight(),
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                hoverColor: MihColors.secondary(),
                splashColor: Color.lerp(
                  MihColors.bluishPurple(),
                  Colors.black,
                  0.01,
                ),
                leading: MihCircleAvatar(
                  imageFile: image,
                  width: 50,
                  expandable: true,
                  editable: false,
                  fileNameController: null,
                  userSelectedfile: null,
                  frameColor: MihColors.primary(),
                  backgroundColor: MihColors.highlight(),
                  onChange: null,
                ),
                title: Text(
                  "@${profileProvider.userSearchResults[index].username} $isYou",
                  style: TextStyle(
                    color: MihColors.primary(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Email: ${hideEmail(profileProvider.userSearchResults[index].email)}",
                  style: TextStyle(
                    color: MihColors.primary(),
                  ),
                ),
                onTap: () {
                  addEmployeePopUp(profileProvider, index, screenWidth);
                },
              ),
            );
          },
        );
      },
    );
  }
}
