import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/package_tools/mih_forgot_password.dart';

class MihAuthForgotPassword extends StatefulWidget {
  const MihAuthForgotPassword({super.key});

  @override
  State<MihAuthForgotPassword> createState() => _MihAuthForgotPasswordState();
}

class _MihAuthForgotPasswordState extends State<MihAuthForgotPassword> {
  int _selectedIndex = 0;
  late final MihForgotPassword _forgotPassword;

  @override
  void initState() {
    super.initState();
    _forgotPassword = MihForgotPassword();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      packageActionButton: getAction(),
      packageTools: getTools(),
      packageToolTitles: ["Forgot Password"],
      packageToolBodies: getToolBody(),
      selectedBodyIndex: _selectedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selectedIndex = newValue;
        });
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          'mihHome',
          extra: true,
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.question_mark_rounded)] = () {
      setState(() {
        _selectedIndex = 0;
      });
    };
    return MihPackageTools(
      tools: temp,
      selectedIndex: _selectedIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _forgotPassword,
    ];
  }
}
