import 'package:flutter/widgets.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih-app_tool_body.dart';

class MihAttributes extends StatefulWidget {
  const MihAttributes({super.key});

  @override
  State<MihAttributes> createState() => _MihAttributesState();
}

class _MihAttributesState extends State<MihAttributes> {
  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return MihSingleChildScroll(
      child: Column(
        children: [
          Text(
            'Attributes',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
