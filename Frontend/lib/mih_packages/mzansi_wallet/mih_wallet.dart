import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_tools.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/package_tools/mih_card_favourites.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/package_tools/mih_cards.dart';
import 'package:flutter/material.dart';

class MihWallet extends StatefulWidget {
  final WalletArguments arguments;
  // final AppUser signedInUser;
  const MihWallet({
    super.key,
    required this.arguments,
    // required this.signedInUser,
  });

  @override
  State<MihWallet> createState() => _MihWalletState();
}

class _MihWalletState extends State<MihWallet> {
  late int _selcetedIndex;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selcetedIndex = widget.arguments.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MihApp(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
        });
        print("Index: $_selcetedIndex");
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihAppTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.card_membership)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.favorite)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };

    return MihAppTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      MihCards(
        signedInUser: widget.arguments.signedInUser,
      ),
      MihCardFavourites(
        signedInUser: widget.arguments.signedInUser,
      ),
    ];
    return toolBodies;
  }
}
