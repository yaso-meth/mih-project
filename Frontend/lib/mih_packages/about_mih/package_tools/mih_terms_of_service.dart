import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/mih_policy_tos_ext/policy_and_terms_text.dart';
import 'package:flutter/material.dart';

class MIHTermsOfService extends StatelessWidget {
  const MIHTermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return MihSingleChildScroll(
      child: Column(
        children: PolicyAndTermsText().getTermsOfServiceText(context),
      ),
    );
  }
}
