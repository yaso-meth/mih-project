import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/package_tools/currency_exchange_rate.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/package_tools/simple_calc.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/package_tools/tip_calc.dart';
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
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: _selectedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selectedIndex = newValue;
        });
        print("Index: $_selectedIndex");
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          'mihHome',
          extra: widget.personalSelected,
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
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
    temp[const Icon(Icons.currency_exchange)] = () {
      setState(() {
        _selectedIndex = 2;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selectedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      const SimpleCalc(),
      const TipCalc(),
      const CurrencyExchangeRate(),
    ];
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Simple Calculator",
      "Tip Calculator",
      "Forex Calculator",
    ];
    return toolTitles;
  }
}
