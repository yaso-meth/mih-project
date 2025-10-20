import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_add_employee_window.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildUserList extends StatefulWidget {
  final List<AppUser> users;

  const BuildUserList({
    super.key,
    required this.users,
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

  void addEmployeePopUp(int index, double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihAddEmployeeWindow(
        user: widget.users[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, index) {
            return Divider(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            );
          },
          itemCount: widget.users.length,
          itemBuilder: (context, index) {
            var isYou = "";
            if (mzansiProfileProvider.user!.app_id ==
                widget.users[index].app_id) {
              isYou = "(You)";
            }
            return ListTile(
              title: Text("@${widget.users[index].username} $isYou"),
              subtitle: Text(
                "Email: ${hideEmail(widget.users[index].email)}",
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
              onTap: () {
                addEmployeePopUp(index, screenWidth);
              },
            );
          },
        );
      },
    );
  }
}
