import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/loyalty_card.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

import '../../../mih_services/mih_alert_services.dart';

class MihCardEditWindow extends StatefulWidget {
  final MIHLoyaltyCard editCard;
  final int listIndex;
  const MihCardEditWindow({
    super.key,
    required this.editCard,
    required this.listIndex,
  });

  @override
  State<MihCardEditWindow> createState() => _MihCardEditWindowState();
}

class _MihCardEditWindowState extends State<MihCardEditWindow> {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void openscanner() async {
    context.pushNamed(
      "barcodeScanner",
      extra: _cardNumberController,
    );
  }

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.editCard.nickname;
    _cardNumberController.text = widget.editCard.card_number;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Consumer2<MzansiProfileProvider, MzansiWalletProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider mzansiProfileProvider,
        MzansiWalletProvider walletProvider,
        Widget? child,
      ) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Edit Loyalty Card",
          onWindowTapClose: () {
            _cardNumberController.clear();
            _nicknameController.clear();
            Navigator.pop(context);
          },
          windowBody: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: size.width * 0.05)
                    : EdgeInsets.symmetric(horizontal: size.width * 0),
            child: Column(
              children: [
                MihForm(
                  formKey: _formKey,
                  formFields: [
                    MihTextFormField(
                      fillColor: MihColors.secondary(),
                      inputColor: MihColors.primary(),
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
                            fillColor: MihColors.secondary(),
                            inputColor: MihColors.primary(),
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
                            openscanner();
                          },
                          buttonColor: MihColors.secondary(),
                          width: 100,
                          child: Text(
                            "Scan",
                            style: TextStyle(
                              color: MihColors.primary(),
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
                            walletProvider.updateLocalLoyaltyCard(
                              mzansiProfileProvider,
                              MIHLoyaltyCard(
                                idloyalty_cards:
                                    widget.editCard.idloyalty_cards,
                                app_id: widget.editCard.app_id,
                                shop_name: widget.editCard.shop_name,
                                card_number: _cardNumberController.text,
                                favourite: widget.editCard.favourite,
                                priority_index: widget.editCard.priority_index,
                                nickname: _nicknameController.text,
                              ),
                            );
                            context.pop();
                            context.pop();
                            MihAlertServices().successBasicAlert(
                              "Success!",
                              "You have successfully updated the loyalty card details.",
                              context,
                            );
                          } else {
                            MihAlertServices().inputErrorAlert(context);
                          }
                        },
                        buttonColor: MihColors.green(),
                        width: 300,
                        child: Text(
                          "Update",
                          style: TextStyle(
                            color: MihColors.primary(),
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
      },
    );
  }
}
