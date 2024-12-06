import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_header.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mih_policy_tos/policy_and_terms_text.dart';
import 'package:flutter/material.dart';

class MIHPrivacyPolocy extends StatefulWidget {
  const MIHPrivacyPolocy({super.key});

  @override
  State<MIHPrivacyPolocy> createState() => _MIHPrivacyPolocyState();
}

class _MIHPrivacyPolocyState extends State<MIHPrivacyPolocy> {
  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/',
          arguments: true,
          (route) => false,
        );
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "Privacy Policy",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
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
