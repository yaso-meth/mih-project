import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/mih_policy_tos_ext/policy_and_terms_text.dart';
import 'package:flutter/material.dart';

class MIHTermsOfService extends StatefulWidget {
  const MIHTermsOfService({super.key});

  @override
  State<MIHTermsOfService> createState() => _MIHTermsOfServiceState();
}

class _MIHTermsOfServiceState extends State<MIHTermsOfService> {
  bool englishOn = true;
  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    List<Widget> children = [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MihButton(
            onPressed: () {
              setState(() {
                englishOn = !englishOn;
              });
            },
            buttonColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            elevation: 10,
            child: Text(
              englishOn ? "Simplified Chinese" : "English",
              style: TextStyle(
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
    ];
    children
        .addAll(PolicyAndTermsText().getTermsOfServiceText(context, englishOn));
    return MihSingleChildScroll(
      child: Column(
        children: children,
      ),
    );
  }
}
