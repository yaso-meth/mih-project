import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_app_drawer.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';

class MIHLayoutBuilder extends StatefulWidget {
  final Widget actionButton;
  final Widget? secondaryActionButton;
  final MIHHeader header;
  final MIHBody body;
  final MIHAppDrawer? actionDrawer;
  final MIHAppDrawer? secondaryActionDrawer;
  final Widget? bottomNavBar;

  //final String type;
  const MIHLayoutBuilder({
    super.key,
    required this.actionButton,
    required this.header,
    required this.secondaryActionButton,
    required this.body,
    required this.actionDrawer,
    required this.secondaryActionDrawer,
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
      drawer: widget.actionDrawer,
      endDrawer: widget.secondaryActionButton,
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
