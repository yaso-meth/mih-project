// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_wallet/components/mih_card_display.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_wallet_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';

class MihAddCardWindow extends StatefulWidget {
  final AppUser signedInUser;
  Future<List<MIHLoyaltyCard>> cardList;

  MihAddCardWindow({
    super.key,
    required this.signedInUser,
    required this.cardList,
  });

  @override
  State<MihAddCardWindow> createState() => _MihAddCardWindowState();
}

class _MihAddCardWindowState extends State<MihAddCardWindow> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _shopController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final ValueNotifier<String> _shopName = ValueNotifier("");

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(
          errorType: "Internet Connection",
        );
      },
    );
  }

  void successPopUp(String title, String message, int packageIndex) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.check_circle_outline_rounded,
            size: 150,
            color: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: title,
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: MihButton(
                  onPressed: () {
                    context.pop();
                    context.goNamed(
                      'mzansiWallet',
                      extra: WalletArguments(widget.signedInUser, 0),
                    );
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  elevation: 10,
                  width: 300,
                  child: Text(
                    "Dismiss",
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          alertColour: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _shopController.dispose();
    _nicknameController.dispose();
    _shopName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _shopController.addListener(_shopSelected);
  }

  void _shopSelected() {
    if (_shopController.text.isNotEmpty) {
      _shopName.value = _shopController.text;
    } else {
      _shopName.value = "";
    }
  }

  // ... rest of your existing methods

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Add New Loyalty Card",
      onWindowTapClose: () {
        _shopController.clear();
        _cardNumberController.clear();
        _nicknameController.clear();
        _shopName.value = "";
        Navigator.pop(context);
      },
      windowBody: Padding(
        padding: MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
            ? EdgeInsets.symmetric(horizontal: width * 0.05)
            : EdgeInsets.symmetric(horizontal: width * 0),
        child: Column(
          children: [
            MihForm(
              formKey: _formKey,
              formFields: [
                MihDropdownField(
                  controller: _shopController,
                  hintText: "Shop Name",
                  editable: true,
                  enableSearch: true,
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                  requiredText: true,
                  dropdownOptions: const [
                    "+More",
                    "Apple Tree",
                    "+More",
                    "Apple Tree",
                    "Auchan",
                    "Best Before",
                    "Big Save",
                    "Boxer",
                    "BP",
                    "Builders Warehouse",
                    "Checkers",
                    "Choppies",
                    "Clicks",
                    "Continente",
                    "Cotton:On",
                    "Carrefour",
                    "Dis-Chem",
                    "Edgars",
                    "Eskom",
                    "Exclusive Books",
                    "Fresh Stop",
                    "Fresmart",
                    "Infinity",
                    "Jet",
                    "Justrite",
                    "Kero",
                    "Leroy Merlin",
                    "Makro",
                    "Naivas",
                    "OK Foods",
                    "Panarottis",
                    "Pick n Pay",
                    "PnA",
                    "PQ Clothing",
                    "Rage",
                    "Sefalana",
                    "Sasol",
                    "Shell",
                    "Shoprite",
                    "Signature Cosmetics & Fragrances",
                    "Spar",
                    "Spur",
                    "TFG Group",
                    "Total Energies",
                    "Toys R Us",
                    "Woermann Brock",
                    "Woolworths"
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: _shopName,
                  builder: (BuildContext context, String value, Widget? child) {
                    return Visibility(
                      visible: value != "",
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          MihCardDisplay(
                              shopName: _shopName.value,
                              nickname: "",
                              height: 200),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: _nicknameController,
                  multiLineInput: false,
                  requiredText: false,
                  hintText: "Card Title",
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: MihTextFormField(
                        fillColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        inputColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        controller: _cardNumberController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Card Number",
                        numberMode: true,
                        validator: (value) {
                          return MihValidationServices().isEmpty(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    MihButton(
                      onPressed: () {
                        context.pushNamed(
                          "barcodeScanner",
                          extra: _cardNumberController, // Use local controller
                        );
                      },
                      buttonColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 100,
                      child: Text(
                        "Scan",
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
                const SizedBox(height: 15),
                Center(
                  child: MihButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (_shopController.text == "") {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const MIHErrorMessage(
                                  errorType: "Input Error");
                            },
                          );
                        } else {
                          int statusCode =
                              await MIHMzansiWalletApis.addLoyaltyCardAPICall(
                            widget.signedInUser,
                            widget.signedInUser.app_id,
                            _shopController.text,
                            _cardNumberController.text,
                            "",
                            0,
                            _nicknameController.text,
                            context,
                          );
                          if (statusCode == 201) {
                            setState(() {
                              widget.cardList =
                                  MIHMzansiWalletApis.getLoyaltyCards(
                                      widget.signedInUser.app_id);
                            });
                            context.pop();
                            KenLogger.error("Card Added Successfully");
                            successPopUp(
                              "Successfully Added Card",
                              "The loyalty card has been added to your favourites.",
                              0,
                            );
                          } else {
                            internetConnectionPopUp();
                          }
                        }
                      } else {
                        MihAlertServices().formNotFilledCompletely(context);
                      }
                    },
                    buttonColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    width: 300,
                    child: Text(
                      "Add",
                      style: TextStyle(
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
}
