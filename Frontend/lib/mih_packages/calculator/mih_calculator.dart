import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calculator_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/package_tools/currency_exchange_rate.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/package_tools/simple_calc.dart';
import 'package:mzansi_innovation_hub/mih_packages/calculator/package_tools/tip_calc.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_currency_exchange_rate_services.dart';
import 'package:provider/provider.dart';

class MIHCalculator extends StatefulWidget {
  const MIHCalculator({
    super.key,
  });

  @override
  State<MIHCalculator> createState() => _MIHCalculatorState();
}

class _MIHCalculatorState extends State<MIHCalculator> {
  late final SimpleCalc _simpleCalc;
  late final TipCalc _tipCalc;
  late final CurrencyExchangeRate _currencyExchangeRate;

  Future<void> getCurrencyCodeList() async {
    await MihCurrencyExchangeRateServices.getCurrencyCodeList(context);
  }

  @override
  void initState() {
    super.initState();
    _simpleCalc = SimpleCalc();
    _tipCalc = TipCalc();
    _currencyExchangeRate = CurrencyExchangeRate();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getCurrencyCodeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: context.watch<MihCalculatorProvider>().toolIndex,
      onIndexChange: (newIndex) {
        context.read<MihCalculatorProvider>().setToolIndex(newIndex);
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
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.calculate)] = () {
      context.read<MihCalculatorProvider>().setToolIndex(0);
    };
    temp[const Icon(Icons.money)] = () {
      context.read<MihCalculatorProvider>().setToolIndex(1);
    };
    temp[const Icon(Icons.currency_exchange)] = () {
      context.read<MihCalculatorProvider>().setToolIndex(2);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MihCalculatorProvider>().toolIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _simpleCalc,
      _tipCalc,
      _currencyExchangeRate,
    ];
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
