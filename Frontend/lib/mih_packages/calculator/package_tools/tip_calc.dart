import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_numeric_stepper.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_toggle.dart';
import 'package:provider/provider.dart';

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
  late bool splitPosition;
  final _formKey = GlobalKey<FormState>();
  String tip = "";
  String total = "";
  String amountPerPerson = "";
  String temp = "";
  void splitSelected() {
    if (splitBillController.text.isNotEmpty) {
      splitValue.value = splitBillController.text;
    } else {
      splitValue.value = "";
    }
  }

  void validateInput() async {
    calculatePressed();
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
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Calculation Results",
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.coins,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  size: 35,
                ),
                const SizedBox(width: 15),
                Text(
                  "Tip",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.moneyBills,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  size: 35,
                ),
                const SizedBox(width: 15),
                Text(
                  "Total",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            Text(
              "~ ${double.parse(total).ceil()}.00",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            if (splitBillController.text == "Yes") const Divider(),
            if (splitBillController.text == "Yes")
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.peopleGroup,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    size: 35,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "Total per Person",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
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
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
            if (splitBillController.text == "Yes")
              Text(
                "~ ${double.parse(amountPerPerson).ceil()}.00",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
            SizedBox(height: 10),
            Consumer(builder: (context, bannerAdDisplay, child) {
              return MihBannerAd();
            }),
            // if (splitBillController.text == "Yes") const Divider(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    splitBillController.text = "No";
    noPeopleController.text = "2";
    splitPosition = false;
    splitBillController.addListener(splitSelected);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(screenWidth),
    );
  }

  Widget getBody(double width) {
    return MihSingleChildScroll(
      child: Padding(
        padding: MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
            ? EdgeInsets.symmetric(horizontal: width * 0.2)
            : EdgeInsets.symmetric(horizontal: width * 0.075),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            MihForm(
              formKey: _formKey,
              formFields: [
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: billAmountController,
                  multiLineInput: false,
                  requiredText: true,
                  hintText: "Bill Amount",
                  numberMode: true,
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: tipPercentageController,
                  multiLineInput: false,
                  requiredText: true,
                  hintText: "Tip Percentage",
                  numberMode: true,
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10),
                MihToggle(
                  hintText: "Split Bill",
                  initialPostion: splitPosition,
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  secondaryFillColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  onChange: (value) {
                    setState(() {
                      splitBillController.text = value ? "Yes" : "No";
                      splitPosition = value;
                      if (value) {
                        noPeopleController.text =
                            noPeopleController.text.isEmpty
                                ? "2"
                                : noPeopleController.text;
                      } else {
                        noPeopleController.clear();
                      }
                    });
                    // if (value) {
                    //   setState(() {
                    //     splitBillController.text = "Yes";
                    //     splitPosition = value;
                    //   });
                    // } else {
                    //   setState(() {
                    //     splitBillController.text = "No";
                    //     splitPosition = value;
                    //   });
                    // }
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: splitValue,
                  builder: (BuildContext context, String value, Widget? child) {
                    temp = value;
                    return Visibility(
                      visible: temp == "Yes",
                      child: Column(
                        children: [
                          MihNumericStepper(
                            controller: noPeopleController,
                            fillColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            inputColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            hintText: "No. People",
                            requiredText: temp == "Yes",
                            minValue: 2,
                            // maxValue: 5,
                            validationOn: true,
                          ),
                          // MihTextFormField(
                          //   fillColor: MzansiInnovationHub.of(context)!
                          //       .theme
                          //       .secondaryColor(),
                          //   inputColor: MzansiInnovationHub.of(context)!
                          //       .theme
                          //       .primaryColor(),
                          //   controller: noPeopleController,
                          //   multiLineInput: false,
                          //   requiredText: temp == "Yes",
                          //   hintText: "No. of People",
                          //   numberMode: true,
                          //   validator: (validationValue) {
                          //     if (temp == "Yes") {
                          //       return MihValidationServices()
                          //           .isEmpty(validationValue);
                          //     } else {
                          //       return null;
                          //     }
                          //   },
                          // ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      MihButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            validateInput();
                          } else {
                            MihAlertServices().inputErrorAlert(context);
                          }
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Calculate",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MihButton(
                        onPressed: () {
                          clearInput();
                        },
                        buttonColor: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Clear",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
