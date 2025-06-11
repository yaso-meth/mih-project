import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_header.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/mih_policy_tos_ext/policy_and_terms_text.dart';
import 'package:flutter/material.dart';

class MIHPrivacyPolocyExternal extends StatefulWidget {
  const MIHPrivacyPolocyExternal({super.key});

  @override
  State<MIHPrivacyPolocyExternal> createState() =>
      _MIHPrivacyPolocyExternalState();
}

class _MIHPrivacyPolocyExternalState extends State<MIHPrivacyPolocyExternal> {
  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          arguments: AuthArguments(true, false),
          (route) => false,
        );
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [],
    );
  }

  MIHBody getBody() {
    return MIHBody(
      borderOn: false,
      bodyItems: PolicyAndTermsText().getPrivacyPolicyText(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      secondaryActionButton: null,
      body: getBody(),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
