import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class TestPackageTile extends StatefulWidget {
  final AppUser signedInUser;
  final Business? business;
  final double packageSize;
  const TestPackageTile({
    super.key,
    required this.signedInUser,
    required this.business,
    required this.packageSize,
  });

  @override
  State<TestPackageTile> createState() => _TestPackageTileState();
}

class _TestPackageTileState extends State<TestPackageTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.goNamed(
          'testPackage',
          extra: TestArguments(
            widget.signedInUser,
            widget.business,
          ),
        );
        // Navigator.of(context).pushNamed(
        //   '/package-dev',
        //   arguments: TestArguments(
        //     widget.signedInUser,
        //     widget.business,
        //   ),
        // );
      },
      appName: "Test",
      appIcon: Icon(
        Icons.warning_amber_rounded,
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
      iconSize: widget.packageSize,
      primaryColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      secondaryColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
  }
}
