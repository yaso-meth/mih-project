import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_authentication/package_tools/mih_reset_password.dart';

class MihAuthPasswordReset extends StatefulWidget {
  final String token;
  const MihAuthPasswordReset({
    super.key,
    required this.token,
  });

  @override
  State<MihAuthPasswordReset> createState() => _MihAuthPasswordResetState();
}

class _MihAuthPasswordResetState extends State<MihAuthPasswordReset> {
  int _selectedIndex = 0;
  late final MihResetPassword _resetPassword;

  @override
  void initState() {
    super.initState();
    _resetPassword = MihResetPassword(token: widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      packageActionButton: getAction(),
      packageTools: getTools(),
      packageToolBodies: getToolBody(),
      packageToolTitles: ["Reset Password"],
      selectedBodyIndex: _selectedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selectedIndex = newValue;
        });
      },
    );
  }

  Widget getAction() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: MihPackageAction(
        icon: const Icon(MihIcons.mihLogo),
        iconSize: 45,
        onTap: () {
          context.goNamed(
            'mihHome',
            extra: true,
          );
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.password_rounded)] = () {
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
      _resetPassword,
    ];
  }
}
