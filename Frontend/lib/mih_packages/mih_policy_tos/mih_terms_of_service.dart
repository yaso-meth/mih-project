import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_header.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mih_policy_tos/policy_and_terms_text.dart';
import 'package:flutter/material.dart';

class MIHTermsOfService extends StatefulWidget {
  const MIHTermsOfService({super.key});

  @override
  State<MIHTermsOfService> createState() => _MIHTermsOfServiceState();
}

class _MIHTermsOfServiceState extends State<MIHTermsOfService> {
  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pushNamed(
          '/',
          arguments: true,
        );
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "Terms of Service",
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
      bodyItems: PolicyAndTermsText().getTermsOfServiceText(context),
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
