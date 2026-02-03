import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_employee.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_edit_employee_details_window.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:flutter/material.dart';
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
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
            return ListTile(
              title: Text(
                  "${mzansiProfileProvider.employeeList![index].fname} ${mzansiProfileProvider.employeeList![index].lname} - ${mzansiProfileProvider.employeeList![index].title} $isMe"),
              subtitle: Text(
                "${mzansiProfileProvider.employeeList![index].username}\n${mzansiProfileProvider.employeeList![index].email}\nAccess: ${mzansiProfileProvider.employeeList![index].access}",
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
              onTap: () {
                updateEmployeePopUp(employee);
              },
            );
          },
        );
      },
    );
  }
}
