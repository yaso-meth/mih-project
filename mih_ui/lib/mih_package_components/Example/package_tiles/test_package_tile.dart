import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class TestPackageTile extends StatefulWidget {
  final double packageSize;
  const TestPackageTile({
    super.key,
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
        context.pushNamed(
          'testPackage',
        );
        // Navigator.of(context).pushNamed(
        //   '/package-dev',
        //   arguments: TestArguments(
        //     widget.signedInUser,
        //     widget.business,
        //   ),
        // );
      },
      packageName: "Test",
      packageIcon: Icon(
        Icons.warning_amber_rounded,
        color: MihColors.secondary(),
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
