import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';

class PackageToolTwo extends StatefulWidget {
  const PackageToolTwo({super.key});

  @override
  State<PackageToolTwo> createState() => _PackageToolTwoState();
}

class _PackageToolTwoState extends State<PackageToolTwo> {
  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return MihSingleChildScroll(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "World",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.black,
            width: 200,
            height: 200,
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            child: IconButton.filled(
              onPressed: () {},
              icon: Icon(
                MihIcons.mihLogo,
                color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
