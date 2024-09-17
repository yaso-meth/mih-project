import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/MIH_Layout/mih_action.dart';
import 'package:patient_manager/mih_components/MIH_Layout/mih_body.dart';
import 'package:patient_manager/mih_components/MIH_Layout/mih_header.dart';

class MIHLayoutBuilder extends StatefulWidget {
  final MIHAction actionButton;
  final MIHHeader header;
  final MIHBody body;
  const MIHLayoutBuilder({
    super.key,
    required this.actionButton,
    required this.header,
    required this.body,
  });

  @override
  State<MIHLayoutBuilder> createState() => _MIHLayoutBuilderState();
}

class _MIHLayoutBuilderState extends State<MIHLayoutBuilder> {
  List<Widget> getList() {
    List<Widget> temp = [];
    temp.add(widget.header);
    temp.add(widget.body);
    return temp;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      body: SizedBox(
        width: screenSize.width,
        height: screenSize.height,
        child: Stack(
          children: [
            widget.actionButton,
            Column(
              children: [
                widget.header,
                Expanded(child: widget.body),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
