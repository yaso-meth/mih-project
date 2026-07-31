import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';

class SimpleCalc extends StatefulWidget {
  const SimpleCalc({super.key});

  @override
  State<SimpleCalc> createState() => _SimpleCalcState();
}

class _SimpleCalcState extends State<SimpleCalc> {
  String userInput = '';
  String answer = '0';

  final List<String> buttons = [
    'AC',
    '(',
    ')',
    '÷',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    'D',
    '=',
  ];

  void _calculateResult() {
    if (userInput.isEmpty) {
      answer = '0';
      return;
    }

    try {
      String finalUserInput =
          userInput.replaceAll('x', '*').replaceAll('÷', '/');
      GrammarParser p = GrammarParser();
      Expression exp = p.parse(finalUserInput);
      ContextModel cm = ContextModel();
      RealEvaluator evaluator = RealEvaluator(cm);
      double eval = evaluator.evaluate(exp).toDouble();

      if (eval.isNaN || eval.isInfinite) {
        answer = 'Error';
      } else if (eval % 1 == 0) {
        answer = eval.toInt().toString();
      } else {
        answer = eval.toString();
      }
    } catch (_) {}
  }

  /// Handles user input for buttons
  void _onButtonPressed(String btn) {
    setState(() {
      switch (btn) {
        case 'AC':
          userInput = '';
          answer = '0';
          break;

        case 'D':
          if (userInput.isNotEmpty) {
            userInput = userInput.substring(0, userInput.length - 1);
            _calculateResult();
          }
          break;

        case '=':
          _calculateResult();
          userInput = answer;
          break;

        default:
          userInput += btn;
          _calculateResult();
          break;
      }
    });
  }

  /// Returns appropriate button color based on key category
  Color _getButtonColor(String btn) {
    if (btn == 'AC') return MihColors.purple();
    if (btn == 'D') return MihColors.red();
    if (btn == '=') return MihColors.green();
    if (['+', '-', 'x', '÷', '(', ')'].contains(btn)) return MihColors.grey();
    return MihColors.secondary();
  }

  /// Helper widget for building grid action buttons
  Widget _buildButton(String btn) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: MihButton(
        onPressed: () => _onButtonPressed(btn),
        buttonColor: _getButtonColor(btn),
        width: 50,
        height: 50,
        borderRadius: 5,
        child: btn == 'D'
            ? Icon(
                Icons.backspace,
                color: MihColors.primary(),
              )
            : Text(
                btn,
                style: TextStyle(
                  color: MihColors.primary(),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: _getBody(),
    );
  }

  Widget _getBody() {
    double height = MediaQuery.sizeOf(context).height;
    double calcWidth = 500;

    if (MzansiInnovationHub.of(context)!.theme.screenType == "desktop" &&
        height < 700) {
      calcWidth = 300;
    }

    return MihSingleChildScroll(
      scrollbarOn: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // User Input View
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Text(
                userInput,
                style: TextStyle(
                  fontSize: 40,
                  color: MihColors.secondary(),
                ),
              ),
            ),
          ),
          // Output Result View
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.centerRight,
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 30,
                color: MihColors.secondary(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Calculator Numpad Grid
          Container(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: calcWidth,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) => _buildButton(buttons[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

