import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_authentication_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/package_tools/mih_register.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/package_tools/mih_sign_in.dart';
import 'package:provider/provider.dart';

class MihAuthentication extends StatefulWidget {
  const MihAuthentication({super.key});

  @override
  State<MihAuthentication> createState() => _MihAuthenticationState();
}

class _MihAuthenticationState extends State<MihAuthentication> {
  late final MihSignIn _signIn;
  late final MihRegister _register;

  @override
  void initState() {
    super.initState();
    _signIn = MihSignIn();
    _register = MihRegister();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: context.watch<MihAuthenticationProvider>().toolIndex,
      onIndexChange: (newIndex) {
        context.read<MihAuthenticationProvider>().setToolIndex(newIndex);
      },
    );
  }

  List<Widget> getToolBody() {
    return [
      _signIn,
      _register,
    ];
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Sign In",
      "Create an Account",
    ];
    return toolTitles;
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.perm_identity)] = () {
      context.read<MihAuthenticationProvider>().setToolIndex(0);
    };
    temp[const Icon(Icons.create)] = () {
      context.read<MihAuthenticationProvider>().setToolIndex(1);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MihAuthenticationProvider>().toolIndex,
    );
  }

  Widget getAction() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: MihPackageAction(
        icon: const Icon(MihIcons.mihLogo),
        iconSize: 45,
        onTap: () {
          context.goNamed("aboutMih", extra: true);
        },
      ),
    );
  }
}
