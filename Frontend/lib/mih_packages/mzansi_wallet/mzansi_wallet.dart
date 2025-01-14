import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_header.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_wallet/loyalty_cards.dart';
import 'package:flutter/material.dart';

class MzansiWallet extends StatefulWidget {
  final AppUser signedInUser;
  const MzansiWallet({
    super.key,
    required this.signedInUser,
  });

  @override
  State<MzansiWallet> createState() => _MzansiWalletState();
}

class _MzansiWalletState extends State<MzansiWallet> {
  int _selectedIndex = 0;

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).popAndPushNamed(
          '/',
          arguments: AuthArguments(true, false),
        );
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  MIHHeader getSecAction() {
    return MIHHeader(
      headerAlignment: MainAxisAlignment.end,
      headerItems: [
        //============ Patient Details ================
        Visibility(
          visible: _selectedIndex != 0,
          child: IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            icon: const Icon(
              Icons.card_membership,
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: _selectedIndex == 0,
          child: IconButton.filled(
            iconSize: 35,
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            icon: const Icon(
              Icons.card_membership,
            ),
          ),
        ),
        //============ Patient Notes ================
        // Visibility(
        //   visible: _selectedIndex != 1,
        //   child: IconButton(
        //     onPressed: () {
        //       setState(() {
        //         _selectedIndex = 1;
        //       });
        //     },
        //     icon: const Icon(
        //       Icons.article_outlined,
        //       size: 35,
        //     ),
        //   ),
        // ),
        // Visibility(
        //   visible: _selectedIndex == 1,
        //   child: IconButton.filled(
        //     onPressed: () {
        //       setState(() {
        //         _selectedIndex = 1;
        //       });
        //     },
        //     icon: const Icon(
        //       Icons.article_outlined,
        //       size: 35,
        //     ),
        //   ),
        // ),
        // //============ Patient Files ================
        // Visibility(
        //   visible: _selectedIndex != 2,
        //   child: IconButton(
        //     onPressed: () {
        //       setState(() {
        //         _selectedIndex = 2;
        //       });
        //     },
        //     icon: const Icon(
        //       Icons.file_present,
        //       size: 35,
        //     ),
        //   ),
        // ),
        // Visibility(
        //   visible: _selectedIndex == 2,
        //   child: IconButton.filled(
        //     onPressed: () {
        //       setState(() {
        //         _selectedIndex = 2;
        //       });
        //     },
        //     icon: const Icon(
        //       Icons.file_present,
        //       size: 35,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  MIHBody getBody() {
    return MIHBody(
      borderOn: true,
      bodyItems: [showSelection(_selectedIndex)],
    );
  }

  Widget showSelection(int index) {
    if (index == 0) {
      return LoyaltyCards(signedInUser: widget.signedInUser);
    } else if (index == 1) {
      return const Placeholder();
    } else {
      return const Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      secondaryActionButton: getSecAction(),
      body: getBody(),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
