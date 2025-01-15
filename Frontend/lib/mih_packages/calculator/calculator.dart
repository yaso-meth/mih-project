import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_header.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calculator/simple_calc.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calculator/tip_calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';

class MIHCalculator extends StatefulWidget {
  const MIHCalculator({super.key});

  @override
  State<MIHCalculator> createState() => _MIHCalculatorState();
}

class _MIHCalculatorState extends State<MIHCalculator> {
  int _selectedIndex = 0;

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).popAndPushNamed(
          '/',
          arguments: AuthArguments(true, false),
        );
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  MIHHeader getSecAction() {
    return MIHHeader(
      headerAlignment: MainAxisAlignment.end,
      headerItems: [
        //============ Simple Calc ================
        Visibility(
          visible: _selectedIndex != 0,
          child: IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            icon: const Icon(
              Icons.calculate,
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: _selectedIndex == 0,
          child: IconButton.filled(
            iconSize: 35,
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            icon: const Icon(
              Icons.calculate,
            ),
          ),
        ),
        //============ Tip Calc ================
        Visibility(
          visible: _selectedIndex != 1,
          child: IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
            icon: const Icon(
              Icons.money,
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: _selectedIndex == 1,
          child: IconButton.filled(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
            icon: const Icon(
              Icons.money,
              size: 35,
            ),
          ),
        ),
        // //============ Patient Files ================
        // Visibility(
        //   visible: _selectedIndex != 2,
        //   child: IconButton(
        //     onPressed: () {
        //       setState(() {
        //         _selectedIndex = 2;
        //       });
        //     },
        //     icon: const Icon(
        //       Icons.file_present,
        //       size: 35,
        //     ),
        //   ),
        // ),
        // Visibility(
        //   visible: _selectedIndex == 2,
        //   child: IconButton.filled(
        //     onPressed: () {
        //       setState(() {
        //         _selectedIndex = 2;
        //       });
        //     },
        //     icon: const Icon(
        //       Icons.file_present,
        //       size: 35,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  MIHBody getBody() {
    return MIHBody(
      borderOn: true,
      bodyItems: [showSelection(_selectedIndex)],
    );
  }

  Widget showSelection(int index) {
    if (index == 0) {
      return const SimpleCalc();
    } else if (index == 1) {
      return const TipCalc();
    } else {
      return const Placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwipeDetector(
      onSwipeLeft: (offset) {
        if (_selectedIndex < 1) {
          setState(() {
            _selectedIndex += 1;
          });
        }
        //print("swipe left");
      },
      onSwipeRight: (offset) {
        if (_selectedIndex > 0) {
          setState(() {
            _selectedIndex -= 1;
          });
        }
        //print("swipe right");
      },
      child: MIHLayoutBuilder(
        actionButton: getActionButton(),
        header: getHeader(),
        secondaryActionButton: getSecAction(),
        body: getBody(),
        actionDrawer: null,
        secondaryActionDrawer: null,
        bottomNavBar: null,
        pullDownToRefresh: false,
        onPullDown: () async {},
      ),
    );
  }
}
