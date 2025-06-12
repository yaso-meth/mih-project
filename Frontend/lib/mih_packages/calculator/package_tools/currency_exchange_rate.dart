import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_currency_exchange_rate_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';

class CurrencyExchangeRate extends StatefulWidget {
  const CurrencyExchangeRate({super.key});

  @override
  State<CurrencyExchangeRate> createState() => _CurrencyExchangeRateState();
}

class _CurrencyExchangeRateState extends State<CurrencyExchangeRate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromCurrencyController = TextEditingController();
  final TextEditingController _toCurrencyController = TextEditingController();
  final TextEditingController _fromAmountController = TextEditingController();
  final TextEditingController _toAmountController = TextEditingController();
  late Future<List<String>> availableCurrencies;

  Future<void> submitForm() async {
    String fromCurrencyCode = _fromCurrencyController.text.split(" - ")[0];
    String toCurrencyCode = _toCurrencyController.text.split(" - ")[0];
    List<String> dateValue = [];
    double exchangeRate = 0;
    await MihCurrencyExchangeRateServices.getCurrencyExchangeValue(
            fromCurrencyCode, toCurrencyCode)
        .then((amount) {
      dateValue = amount;
    });
    exchangeRate = double.parse(dateValue[1]);
    double exchangeValue =
        double.parse(_fromAmountController.text) * exchangeRate;

    print(
        "Date: ${dateValue[0]}\n${_fromAmountController.text} | $fromCurrencyCode\n$exchangeValue | $toCurrencyCode");
    displayResult(dateValue[0], _fromAmountController.text, fromCurrencyCode,
        exchangeValue, toCurrencyCode);
  }

  void clearInput() {
    _fromCurrencyController.clear();
    _fromAmountController.clear();
    _toCurrencyController.clear();
    _toAmountController.clear();
  }

  void displayResult(String date, String amount, String fromCurrencyCode,
      double exchangeValue, String toCurrencyCode) {
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
            Icon(
              Icons.currency_exchange,
              size: 150,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
            const SizedBox(height: 20),
            FittedBox(
              child: Text(
                "Values as at $date",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    amount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    fromCurrencyCode.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    exchangeValue.toStringAsFixed(2),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    toCurrencyCode.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _fromCurrencyController.dispose();
    _fromAmountController.dispose();
    _toCurrencyController.dispose();
    _toAmountController.dispose();
  }

  @override
  void initState() {
    super.initState();
    availableCurrencies = MihCurrencyExchangeRateServices.getCurrencyCodeList();
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
    return FutureBuilder(
        future: availableCurrencies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Mihloadingcircle();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return MihSingleChildScroll(
              child: Padding(
                padding: MzanziInnovationHub.of(context)!.theme.screenType ==
                        "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
                child: Column(
                  children: [
                    MihForm(
                      formKey: _formKey,
                      formFields: <Widget>[
                        MihTextFormField(
                          fillColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          inputColor: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          controller: _fromAmountController,
                          multiLineInput: false,
                          requiredText: true,
                          hintText: "Currency Amount",
                          numberMode: true,
                          validator: (value) {
                            return MihValidationServices().isEmpty(value);
                          },
                        ),
                        const SizedBox(height: 10),
                        MihDropdownField(
                          controller: _fromCurrencyController,
                          hintText: "From",
                          dropdownOptions: snapshot.data!,
                          editable: true,
                          enableSearch: true,
                          validator: (value) {
                            return MihValidationServices().isEmpty(value);
                          },
                          requiredText: true,
                        ),
                        const SizedBox(height: 10),
                        MihDropdownField(
                          controller: _toCurrencyController,
                          hintText: "To",
                          dropdownOptions: snapshot.data!,
                          editable: true,
                          enableSearch: true,
                          validator: (value) {
                            return MihValidationServices().isEmpty(value);
                          },
                          requiredText: true,
                        ),
                        const SizedBox(height: 25),
                        Center(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              MihButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    submitForm();
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                  } else {
                                    MihAlertServices()
                                        .formNotFilledCompletely(context);
                                  }
                                },
                                buttonColor: MzanziInnovationHub.of(context)!
                                    .theme
                                    .successColor(),
                                width: 300,
                                child: Text(
                                  "Calculate",
                                  style: TextStyle(
                                    color: MzanziInnovationHub.of(context)!
                                        .theme
                                        .primaryColor(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              MihButton(
                                onPressed: () {
                                  clearInput();
                                },
                                buttonColor: MzanziInnovationHub.of(context)!
                                    .theme
                                    .errorColor(),
                                width: 300,
                                child: Text(
                                  "Clear",
                                  style: TextStyle(
                                    color: MzanziInnovationHub.of(context)!
                                        .theme
                                        .primaryColor(),
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
          } else {
            return Center(
              child: Text(
                "Error pulling Currency Exchange Data.",
                style: TextStyle(
                    fontSize: 25,
                    color: MzanziInnovationHub.of(context)!.theme.errorColor()),
                textAlign: TextAlign.center,
              ),
            );
          }
        });
  }
}
