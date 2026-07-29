import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/components/mih_soft_login_popup.dart';

class PackageToolFour extends StatefulWidget {
  const PackageToolFour({super.key});

  @override
  State<PackageToolFour> createState() => _PackageToolFourState();
}

class _PackageToolFourState extends State<PackageToolFour> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MihButton(
          onPressed: () async {
            final bool didReauthenticate = await showDialog<bool>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) => const MihSoftLoginPopup(),
                ) ??
                false;
            KenLogger.success("reauthenticate Successful: $didReauthenticate");
          },
          buttonColor: MihColors.secondary(),
          width: 300,
          child: Text(
            "Soft Login",
            style: TextStyle(
              color: MihColors.primary(),
            ),
          ),
        ),
      ],
    );
  }
}
