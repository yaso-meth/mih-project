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
  final Widget? secondaryActionDrawer;
  final Widget? bottomNavBar;
  final bool pullDownToRefresh;
  final Future<void> Function() onPullDown;
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
    required this.pullDownToRefresh,
    required this.onPullDown,
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

  Widget getLayoutHeader() {
    List<Widget> temp = [];
    temp.add(widget.actionButton);
    temp.add(Flexible(child: widget.header));
    if (widget.secondaryActionButton != null) {
      temp.add(widget.secondaryActionButton!);
    } else {
      //print(widget.header.headerItems.length);
      if (widget.header.headerItems.length == 1) {
        temp.add(const SizedBox(
          width: 50,
        ));
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: temp,
    );
  }

  Widget getBody(double width, double height) {
    if (widget.pullDownToRefresh == true) {
      return LayoutBuilder(builder: (context, BoxConstraints constraints) {
        double newheight = constraints.maxHeight;
        print(newheight);
        return RefreshIndicator(
          onRefresh: widget.onPullDown,
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return SafeArea(
                child: SizedBox(
                  width: width,
                  height: newheight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      getLayoutHeader(),
                      Expanded(child: widget.body),
                    ],
                  ),
                ),
              );
            },
            // child: SafeArea(
            //   child: SizedBox(
            //     width: width,
            //     height: height,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [
            //         getLayoutHeader(),
            //         Expanded(child: widget.body),
            //       ],
            //     ),
            //   ),
            // ),
          ),
        );
      });
    } else {
      return SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              getLayoutHeader(),
              Expanded(child: widget.body),
            ],
          ),
        ),
      );
    }
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
      //drawerEnableOpenDragGesture: true,
      drawer: widget.actionDrawer,
      endDrawer: widget.secondaryActionDrawer,
      body: getBody(screenSize.width, screenSize.height),
      bottomNavigationBar: widget.bottomNavBar,
    );
  }
}
