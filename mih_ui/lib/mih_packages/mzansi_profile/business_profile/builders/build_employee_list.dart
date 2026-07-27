import 'package:cached_network_image/cached_network_image.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_employee.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_edit_employee_details_window.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:provider/provider.dart';

class BuildEmployeeList extends StatefulWidget {
  const BuildEmployeeList({
    super.key,
  });

  @override
  State<BuildEmployeeList> createState() => _BuildEmployeeListState();
}

class _BuildEmployeeListState extends State<BuildEmployeeList> {
  final baseAPI = AppEnviroment.baseApiUrl;

  void updateEmployeePopUp(BusinessEmployee employee) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihEditEmployeeDetailsWindow(
        employee: employee,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, index) {
            return Divider(
              color: MihColors.secondary(),
            );
          },
          itemCount: mzansiProfileProvider.employeeList!.length,
          itemBuilder: (context, index) {
            //final patient = widget.patients[index].id_no.contains(widget.searchString);
            //print(index);
            BusinessEmployee employee =
                mzansiProfileProvider.employeeList![index];
            String isMe = "";
            if (mzansiProfileProvider.user!.app_id ==
                mzansiProfileProvider.employeeList![index].app_id) {
              isMe = "(You)";
            }
            Future<AppUser?> reviewer = MihUserServices().getMIHUserDetailsV2(
                mzansiProfileProvider.employeeList![index].app_id);
            return Material(
              color: MihColors.secondary(),
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                splashColor: Color.lerp(
                  MihColors.bluishPurple(),
                  Colors.black,
                  0.01,
                ),
                hoverColor: MihColors.highlight(),
                leading: FutureBuilder<AppUser?>(
                  future: reviewer,
                  builder: (context, snapshot) {
                    ImageProvider? image;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      image = CachedNetworkImageProvider("");
                    }

                    if (snapshot.hasData) {
                      String? userPicUrl = MihFileApi.getMinioFileUrlV2(
                          snapshot.data!.pro_pic_path);
                      image = CachedNetworkImageProvider(userPicUrl);
                    }

                    if (snapshot.hasError) {
                      image = null;
                    }

                    return MihCircleAvatar(
                      imageFile: image,
                      width: 50,
                      expandable: true,
                      editable: false,
                      fileNameController: null,
                      userSelectedfile: null,
                      frameColor: MihColors.primary(),
                      backgroundColor: MihColors.secondary(),
                      onChange: null,
                    );
                  },
                ),
                title: Text(
                  "${mzansiProfileProvider.employeeList![index].fname} ${mzansiProfileProvider.employeeList![index].lname} - ${mzansiProfileProvider.employeeList![index].title} $isMe",
                  style: TextStyle(
                    color: MihColors.primary(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${mzansiProfileProvider.employeeList![index].username}\n${mzansiProfileProvider.employeeList![index].email}\nAccess: ${mzansiProfileProvider.employeeList![index].access}",
                  style: TextStyle(
                    color: MihColors.primary(),
                  ),
                ),
                onTap: () {
                  updateEmployeePopUp(employee);
                },
              ),
            );
          },
        );
      },
    );
  }
}
