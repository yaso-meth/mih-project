import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
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
          child: SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: FittedBox(
                child: Center(
                  child: Icon(
                    icon,
                    // size: 125,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
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
            child: MihButton(
              onPressed: () {
                launchUrlLink(
                  Uri.parse(
                    link,
                  ),
                );
              },
              buttonColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              width: 100,
              child: Text(
                "Visit",
                style: TextStyle(
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    String message =
        "Some APIs, Icons and Assets used in MIH were sourced from third party providers.\n";
    message +=
        "We are grateful to the talented creators for providing these resources.\n";
    message +=
        "As per the terms for free use for these third party providers, the following assets require attribution";

    return MihSingleChildScroll(
      child: Column(
        children: [
          Icon(
            MihIcons.mihLogo,
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            size: 165,
          ),
          const SizedBox(
            height: 10,
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
                            "Resources",
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
                displayIcon(MihIcons.mihRing, "Tarah Meth",
                    "https://www.linkedin.com/in/tarah-meth-3b6309254/"),
                displayIcon(MihIcons.mihLogo, "Tarah Meth",
                    "https://www.linkedin.com/in/tarah-meth-3b6309254/"),
                displayIcon(MihIcons.mzansiAi, "Ollama", "https://ollama.com/"),
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
                displayIcon(MihIcons.personalProfile, "Freepik",
                    "https://www.flaticon.com/free-icon/user_1077063?term=profile&page=1&position=6&origin=search&related_id=1077063"),
                displayIcon(MihIcons.businessProfile, "Gravisio",
                    "https://www.flaticon.com/free-icon/contractor_11813336?term=company+profile&page=1&position=2&origin=search&related_id=11813336"),
                displayIcon(MihIcons.patientManager, "Vector Tank",
                    "https://www.flaticon.com/free-icon/doctor_10215061?term=doctor&page=1&position=73&origin=search&related_id=10215061"),
                displayIcon(MihIcons.profileSetup, "Freepik",
                    "https://www.flaticon.com/free-icon/add-user_748137?term=profile+add&page=1&position=1&origin=search&related_id=748137"),
                displayIcon(MihIcons.businessSetup, "kerismaker",
                    "https://www.flaticon.com/free-icon/business_13569850?term=company+add&page=1&position=25&origin=search&related_id=13569850"),
                displayIcon(MihIcons.calculator, "fawazahmed0",
                    "https://github.com/fawazahmed0/exchange-api"),
                displayIcon(MihIcons.iDontKnow, "Freepik",
                    "https://www.flaticon.com/free-icon/i-dont-know_5359909?term=i+dont+know&page=1&position=7&origin=search&related_id=5359909"),
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
