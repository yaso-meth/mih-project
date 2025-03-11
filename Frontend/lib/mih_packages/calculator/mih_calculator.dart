import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tools.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calculator/app_tools/simple_calc.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calculator/app_tools/tip_calc.dart';
import 'package:flutter/material.dart';

class MIHCalculator extends StatefulWidget {
  final bool personalSelected;
  const MIHCalculator({
    super.key,
    required this.personalSelected,
  });

  @override
  State<MIHCalculator> createState() => _MIHCalculatorState();
}

class _MIHCalculatorState extends State<MIHCalculator> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MihApp(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      selectedbodyIndex: _selectedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selectedIndex = newValue;
        });
        print("Index: $_selectedIndex");
      },
    );
  }

  MihAppAction getAction() {
    return MihAppAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  MihAppTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.calculate)] = () {
      setState(() {
        _selectedIndex = 0;
      });
    };
    temp[const Icon(Icons.money)] = () {
      setState(() {
        _selectedIndex = 1;
      });
    };
    return MihAppTools(
      tools: temp,
      selcetedIndex: _selectedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      const SimpleCalc(),
      const TipCalc(),
    ];
    return toolBodies;
  }
}
