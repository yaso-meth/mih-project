import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class MihAttributes extends StatefulWidget {
  const MihAttributes({super.key});

  @override
  State<MihAttributes> createState() => _MihAttributesState();
}

class _MihAttributesState extends State<MihAttributes> {
  Future<void> launchUrlLink(Uri linkUrl) async {
    if (!await launchUrl(linkUrl)) {
      throw Exception('Could not launch $linkUrl');
    }
  }

  TableRow displayIcon(IconData icon, String creator, String link) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: FittedBox(
              child: Center(
                child: Icon(
                  icon,
                  // size: 125,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                creator,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: MIHButton(
              onTap: () {
                launchUrlLink(
                  Uri.parse(
                    link,
                  ),
                );
              },
              buttonText: "Visit",
              buttonColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    String message =
        "Some icons and assets used in this MIH were sourced from third party providers.\n";
    message +=
        "We are grateful to the talented creators for providing these resources.\n";
    message +=
        "As per the terms for free user for these third party providers, the following assets require attribution";

    return MihSingleChildScroll(
      child: Column(
        children: [
          Icon(
            MihIcons.mihLogo,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            size: 125,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Attributions',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Divider(),
          ),
          SelectableText(
            message,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 700,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                          child: Text(
                            "Icon",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                          child: Text(
                            "Creator",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Center(
                          child: Text(
                            "Link",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                displayIcon(MihIcons.mihLogo, "Tarah Meth",
                    "https://www.linkedin.com/in/tarah-meth-3b6309254/"),
                displayIcon(MihIcons.mihRing, "Tarah Meth",
                    "https://www.linkedin.com/in/tarah-meth-3b6309254/"),
                displayIcon(MihIcons.mzansiWallet, "Freepik",
                    "https://www.flaticon.com/free-icon/wallet-passes-app_3884407?term=wallet&page=1&position=21&origin=search&related_id=3884407"),
                displayIcon(MihIcons.patientProfile, "RaftelDesign",
                    "https://www.flaticon.com/free-icon/patient_2376100?term=medication&page=1&position=6&origin=search&related_id=2376100"),
                displayIcon(MihIcons.patientProfile, "Srip",
                    "https://www.flaticon.com/free-icon/hospital_1233930?term=medical+snake&page=1&position=7&origin=search&related_id=1233930"),
                displayIcon(MihIcons.calendar, "Freepik",
                    "https://www.flaticon.com/free-icon/calendar_2278049?term=calendar&page=1&position=5&origin=search&related_id=2278049"),
                displayIcon(MihIcons.calculator, "Freepik",
                    "https://www.flaticon.com/free-icon/calculator_2374409?term=calculator&page=1&position=20&origin=search&related_id=2374409"),
                displayIcon(MihIcons.aboutMih, "Chanut",
                    "https://www.flaticon.com/free-icon/info_151776?term=about&page=1&position=8&origin=search&related_id=151776"),
                displayIcon(MihIcons.businessProfile, "Gravisio",
                    "https://www.flaticon.com/free-icon/contractor_11813336?term=company+profile&page=1&position=2&origin=search&related_id=11813336"),
                displayIcon(MihIcons.patientManager, "Vector Tank",
                    "https://www.flaticon.com/free-icon/doctor_10215061?term=doctor&page=1&position=73&origin=search&related_id=10215061"),
                displayIcon(MihIcons.profileSetup, "Freepik",
                    "https://www.flaticon.com/free-icon/add-user_748137?term=profile+add&page=1&position=1&origin=search&related_id=748137"),
                displayIcon(MihIcons.businessSetup, "kerismaker",
                    "https://www.flaticon.com/free-icon/business_13569850?term=company+add&page=1&position=25&origin=search&related_id=13569850"),
              ],
            ),
          ),
          // SizedBox(
          //   width: 500,
          //   child: Column(
          //     children: [
          //       const SizedBox(
          //         width: double.infinity,
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           mainAxisSize: MainAxisSize.max,
          //           children: [
          //             Flexible(
          //               child: Text(
          //                 "Icon",
          //                 style: TextStyle(
          //                   fontSize: 25,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //             Flexible(
          //               child: Text(
          //                 "Creator",
          //                 style: TextStyle(
          //                   fontSize: 25,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //             Flexible(
          //               child: Text(
          //                 "Link",
          //                 style: TextStyle(
          //                   fontSize: 25,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       const Padding(
          //         padding: EdgeInsets.symmetric(vertical: 10.0),
          //         child: Divider(),
          //       ),
          //       displayIcon(MihIcons.mihLogo, "Tarah Meth",
          //           "https://app.mzansi-innovation-hub.co.za/"),
          //       const SizedBox(height: 10),
          //       displayIcon(MihIcons.mihLogo, "Test",
          //           "https://www.flaticon.com/free-icons/mih"),
          //       const SizedBox(height: 10),
          //       displayIcon(MihIcons.mihLogo, "Test",
          //           "https://www.flaticon.com/free-icons/mih"),
          //       const SizedBox(height: 10),
          //       displayIcon(MihIcons.mihLogo, "Test",
          //           "https://www.flaticon.com/free-icons/mih"),
          //       const SizedBox(height: 10),
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
