import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_calculator_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_currency_exchange_rate_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

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
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            const SizedBox(height: 20),
            FittedBox(
              child: Text(
                "Values as at $date",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
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
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
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
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
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
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Consumer(builder: (context, bannerAdDisplay, child) {
              return MihBannerAd();
            }),
          ],
        ),
      ),
    );
  }

  void displayDisclaimer() {
    final String companyName = 'Mzansi Innovation Hub';

    showDialog(
      context: context,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Disclaimer Notice",
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Title

            Text(
              'Disclaimer of Warranty and Limitation of Liability for Forex Calculator',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24.0),

            // First Paragraph - using RichText to bold "the Tool"
            _buildRichText(
              'The Forex Calculator feature ("',
              'the Tool',
              '") is provided on an "as is" and "as available" basis. It is an experimental feature and is intended solely for informational and illustrative purposes.',
            ),
            const SizedBox(height: 16.0),

            // Second Paragraph
            Text(
              '$companyName makes no representations or warranties of any kind, express or implied, as to the accuracy, completeness, reliability, or suitability of the information and calculations generated by the Tool. All exchange rates and results are estimates and are subject to change without notice.',
              style: TextStyle(
                fontSize: 15,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16.0),

            // Third Paragraph
            Text(
              'The information provided by the Tool should not be construed as financial, investment, trading, or any other form of advice. You should not make any financial decisions based solely on the output of this Tool. We expressly recommend that you seek independent professional advice and verify all data with a qualified financial advisor and/or through alternative, reliable market data sources before executing any foreign exchange transactions.',
              style: TextStyle(
                fontSize: 15,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16.0),

            // Fourth Paragraph
            Text(
              'By using the Tool, you agree that $companyName, its affiliates, directors, and employees shall not be held liable for any direct, indirect, incidental, special, consequential, or exemplary damages, including but not limited to, damages for loss of profits, goodwill, use, data, or other intangible losses, resulting from: (i) the use or the inability to use the Tool; (ii) any inaccuracies, errors, or omissions in the Tool\'s calculations or data; or (iii) any reliance placed by you on the information provided by the Tool.',
              style: TextStyle(
                fontSize: 15,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichText(String start, String bold, String end) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 15,
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          fontWeight: FontWeight.normal,
        ),
        children: <TextSpan>[
          TextSpan(text: start),
          TextSpan(
              text: bold, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: end),
        ],
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
    return Consumer<MihCalculatorProvider>(
      builder: (context, calculatorProvider, child) {
        return MihSingleChildScroll(
          child: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
            child: Column(
              children: [
                MihForm(
                  formKey: _formKey,
                  formFields: <Widget>[
                    MihTextFormField(
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
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
                      dropdownOptions: calculatorProvider.availableCurrencies,
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
                      dropdownOptions: calculatorProvider.availableCurrencies,
                      editable: true,
                      enableSearch: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                      requiredText: true,
                    ),
                    const SizedBox(height: 15),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 15,
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                        children: [
                          const TextSpan(
                              text: "* Experimental Feature: Please review "),
                          TextSpan(
                            text: "Diclaimer",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: MihColors.getSecondaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                displayDisclaimer();
                              },
                          ),
                          const TextSpan(text: " before use."),
                        ],
                      ),
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
                            buttonColor: MihColors.getGreenColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            width: 300,
                            child: Text(
                              "Calculate",
                              style: TextStyle(
                                color: MihColors.getPrimaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
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
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
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
      },
    );
  }
}
