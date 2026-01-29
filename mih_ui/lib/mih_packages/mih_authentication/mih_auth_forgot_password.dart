import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/package_tools/mih_forgot_password.dart';

class MihAuthForgotPassword extends StatefulWidget {
  const MihAuthForgotPassword({super.key});

  @override
  State<MihAuthForgotPassword> createState() => _MihAuthForgotPasswordState();
}

class _MihAuthForgotPasswordState extends State<MihAuthForgotPassword> {
  int _selcetedIndex = 0;
  late final MihForgotPassword _forgotPassword;

  @override
  void initState() {
    super.initState();
    _forgotPassword = MihForgotPassword();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appToolTitles: ["Forgot Password"],
      appBody: getToolBody(),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
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
        _selcetedIndex = 0;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _forgotPassword,
    ];
  }
}
