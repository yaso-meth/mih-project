import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_number_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_window.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:math_expressions/math_expressions.dart';

class TipCalc extends StatefulWidget {
  const TipCalc({super.key});

  @override
  State<TipCalc> createState() => _TipCalcState();
}

class _TipCalcState extends State<TipCalc> {
  TextEditingController billAmountController = TextEditingController();
  TextEditingController tipPercentageController = TextEditingController();
  TextEditingController splitBillController = TextEditingController();
  TextEditingController noPeopleController = TextEditingController();
  final ValueNotifier<String> splitValue = ValueNotifier("");
  String tip = "";
  String total = "";
  String amountPerPerson = "";
  void splitSelected() {
    if (splitBillController.text.isNotEmpty) {
      splitValue.value = splitBillController.text;
    } else {
      splitValue.value = "";
    }
  }

  void validateInput() async {
    bool valid = false;
    if (splitBillController.text.isNotEmpty &&
        splitBillController.text == "Yes") {
      if (billAmountController.text.isEmpty ||
          tipPercentageController.text.isEmpty ||
          noPeopleController.text.isEmpty) {
        valid = false;
      } else {
        valid = true;
      }
    } else if (splitBillController.text.isNotEmpty &&
        splitBillController.text == "No") {
      if (billAmountController.text.isEmpty ||
          tipPercentageController.text.isEmpty) {
        valid = false;
      } else {
        valid = true;
      }
    } else {
      valid = false;
    }
    print("Is input valid: $valid");
    if (valid) {
      calculatePressed();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
  }

  void calculatePressed() {
    String tipCalc =
        "${billAmountController.text}*(${tipPercentageController.text}/100)";
    Parser p = Parser();
    ContextModel cm = ContextModel();
    Expression exp = p.parse(tipCalc);
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    tip = eval.toStringAsFixed(2);
    //print("Tip: $tip");
    String totalCalc = "${billAmountController.text}+$tip";
    exp = p.parse(totalCalc);
    eval = exp.evaluate(EvaluationType.REAL, cm);
    total = eval.toStringAsFixed(2);
    //print("Total Amount: $total");
    if (splitBillController.text == "Yes") {
      String splitCalc = "$total/${noPeopleController.text}";
      exp = p.parse(splitCalc);
      eval = exp.evaluate(EvaluationType.REAL, cm);
      amountPerPerson = eval.toStringAsFixed(2);
    }

    //print("Amount Per Person: $amountPerPerson");
    displayResult();
  }

  void clearInput() {
    billAmountController.clear();
    tipPercentageController.clear();
    noPeopleController.clear();
    setState(() {
      splitBillController.text = "No";
    });
  }

  @override
  void dispose() {
    billAmountController.dispose();
    tipPercentageController.dispose();
    splitBillController.dispose();
    noPeopleController.dispose();
    super.dispose();
  }

  void displayResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MIHWindow(
        fullscreen: false,
        windowTitle: "Calculation Results",
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowTools: const [],
        windowBody: [
          // FaIcon(
          //   FontAwesomeIcons.moneyBills,
          //   color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          //   size: 30,
          // ),
          // const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.coins,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                size: 35,
              ),
              const SizedBox(width: 15),
              Text(
                "Tip",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
            ],
          ),
          Text(
            tip,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          const Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                FontAwesomeIcons.moneyBills,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                size: 35,
              ),
              const SizedBox(width: 15),
              Text(
                "Total",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
            ],
          ),
          Text(
            total,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          Text(
            "~ ${double.parse(total).ceil()}.00",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          const Divider(),
          if (splitBillController.text == "Yes")
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.peopleGroup,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  size: 35,
                ),
                const SizedBox(width: 15),
                Text(
                  "Total per Person",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ],
            ),
          if (splitBillController.text == "Yes")
            Text(
              amountPerPerson,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
          if (splitBillController.text == "Yes")
            Text(
              "~ ${double.parse(amountPerPerson).ceil()}.00",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
          // if (splitBillController.text == "Yes") const Divider(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    splitBillController.text = "No";
    splitBillController.addListener(splitSelected);
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          "Tip Calculator",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        const SizedBox(height: 10),
        MIHNumberField(
          controller: billAmountController,
          hintText: "Bill Amount",
          editable: true,
          required: true,
          enableDecimal: true,
        ),
        const SizedBox(height: 10),
        MIHNumberField(
          controller: tipPercentageController,
          hintText: "Tip %",
          editable: true,
          required: true,
          enableDecimal: false,
        ),
        const SizedBox(height: 10),
        MIHDropdownField(
          controller: splitBillController,
          hintText: "Split Bill",
          dropdownOptions: const ["Yes", "No"],
          required: true,
          editable: true,
          enableSearch: false,
        ),
        const SizedBox(height: 10),
        ValueListenableBuilder(
          valueListenable: splitValue,
          builder: (BuildContext context, String value, Widget? child) {
            return Visibility(
              visible: value == "Yes",
              child: Column(
                children: [
                  MIHNumberField(
                    controller: noPeopleController,
                    hintText: "No. of People",
                    editable: true,
                    required: true,
                    enableDecimal: false,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: MIHButton(
            onTap: () {
              validateInput();
            },
            buttonText: "Calculate",
            buttonColor: MzanziInnovationHub.of(context)!.theme.successColor(),
            textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: MIHButton(
            onTap: () {
              clearInput();
            },
            buttonText: "Clear",
            buttonColor: MzanziInnovationHub.of(context)!.theme.errorColor(),
            textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          ),
        ),
      ],
    );
  }
}
