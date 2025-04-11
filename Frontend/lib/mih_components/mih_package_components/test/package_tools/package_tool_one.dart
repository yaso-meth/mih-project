import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';

class PackageToolOne extends StatefulWidget {
  const PackageToolOne({super.key});

  @override
  State<PackageToolOne> createState() => _PackageToolOneState();
}

class _PackageToolOneState extends State<PackageToolOne> {
  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: MihSingleChildScroll(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "Hello",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
