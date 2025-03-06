import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/about_mih/mih_policy_tos_ext/policy_and_terms_text.dart';
import 'package:flutter/material.dart';

class MIHTermsOfService extends StatelessWidget {
  const MIHTermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: false,
      bodyItem: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: PolicyAndTermsText().getTermsOfServiceText(context),
        ),
      ),
    );
  }
}
