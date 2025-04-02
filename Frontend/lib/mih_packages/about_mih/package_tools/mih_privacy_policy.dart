import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/about_mih/mih_policy_tos_ext/policy_and_terms_text.dart';
import 'package:flutter/material.dart';

class MihPrivacyPolicy extends StatelessWidget {
  const MihPrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return MihSingleChildScroll(
      child: Column(
        children: PolicyAndTermsText().getPrivacyPolicyText(context),
      ),
    );
  }
}
