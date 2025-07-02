import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/package_tools/mih_register.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/package_tools/mih_sign_in.dart';

class MihAuthentication extends StatefulWidget {
  const MihAuthentication({super.key});

  @override
  State<MihAuthentication> createState() => _MihAuthenticationState();
}

class _MihAuthenticationState extends State<MihAuthentication> {
  int _selcetedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
        });
      },
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      MihSignIn(
        onNewUserButtonTap: () {
          setState(() {
            _selcetedIndex = 1;
          });
        },
      ),
      MihRegister(onExistingUserButtonTap: () {
        setState(() {
          _selcetedIndex = 0;
        });
      })
    ];
    return toolBodies;
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.perm_identity)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.create)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: const Icon(MihIcons.mihLogo),
      ),
      iconSize: 45,
      onTap: () {
        Navigator.of(context).pushNamed(
          '/about',
          arguments: 0,
        );
      },
    );
  }
}
