import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_app_drawer.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';

class MIHLayoutBuilder extends StatefulWidget {
  final Widget actionButton;
  final MIHHeader header;
  final MIHBody body;
  final MIHAppDrawer? rightDrawer;
  final Widget? bottomNavBar;

  //final String type;
  const MIHLayoutBuilder({
    super.key,
    required this.actionButton,
    required this.header,
    required this.body,
    required this.rightDrawer,
    required this.bottomNavBar,
    //required this.type,
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

  // openTheDrawer() {
  //   _scaffoldKey.currentState!.openEndDrawer();
  // }

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
      //drawerEnableOpenDragGesture: true,
      drawer: widget.rightDrawer,
      body: SafeArea(
        child: SizedBox(
          width: screenSize.width,
          height: screenSize.height,
          child: Stack(
            children: [
              Builder(builder: (context) {
                return widget.actionButton;
              }),
              Column(
                children: [
                  widget.header,
                  Expanded(child: widget.body),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.bottomNavBar,
    );
  }
}
