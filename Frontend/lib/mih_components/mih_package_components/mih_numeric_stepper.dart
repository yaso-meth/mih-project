import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';

class MihNumericStepper extends StatefulWidget {
  final TextEditingController controller;
  final Color fillColor;
  final Color inputColor;
  final String hintText;
  final bool requiredText;
  final double? width;
  final int? minValue;
  final int? maxValue;
  final bool validationOn;
  const MihNumericStepper({
    super.key,
    required this.controller,
    required this.fillColor,
    required this.inputColor,
    required this.hintText,
    required this.requiredText,
    this.width,
    this.minValue,
    this.maxValue,
    required this.validationOn,
  });

  @override
  State<MihNumericStepper> createState() => _MihNumericStepperState();
}

class _MihNumericStepperState extends State<MihNumericStepper> {
  late int _currentValue;
  late bool error;

  @override
  void initState() {
    super.initState();
    _currentValue =
        int.tryParse(widget.controller.text) ?? widget.minValue ?? 0;
    widget.controller.text = _currentValue.toString();
    print("Current Value: $_currentValue");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              widget.hintText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: widget.fillColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              children: [
                Container(
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        25), // Optional: rounds the corners
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(60, 0, 0,
                            0), // 0.2 opacity = 51 in alpha (255 * 0.2)
                        spreadRadius: -2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2.0,
                      left: 5.0,
                    ),
                    child: SizedBox(
                      width: 40,
                      child: IconButton.filled(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(widget.fillColor),
                        ),
                        color: widget.inputColor,
                        iconSize: 20,
                        onPressed: () {
                          print("Current Value: $_currentValue");
                          if (_currentValue >= (widget.minValue ?? 0)) {
                            setState(() {
                              widget.controller.text =
                                  (_currentValue - 1).toString();
                              _currentValue =
                                  int.tryParse(widget.controller.text)!;
                            });
                          }
                          print("New Current Value: $_currentValue");
                        },
                        icon: const Icon(
                          Icons.remove,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _currentValue < (widget.minValue ?? 0) ||
                      _currentValue > widget.maxValue!,
                  child: const SizedBox(
                    height: 21,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: MihTextFormField(
                width: widget.width,
                fillColor: widget.fillColor,
                inputColor: widget.inputColor,
                controller: widget.controller,
                hintText: null,
                requiredText: widget.requiredText,
                readOnly: true,
                numberMode: true,
                textIputAlignment: TextAlign.center,
                validator: (value) {
                  if (widget.validationOn) {
                    return MihValidationServices().validateNumber(
                        value, widget.minValue, widget.maxValue);
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Container(
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        25), // Optional: rounds the corners
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(60, 0, 0,
                            0), // 0.2 opacity = 51 in alpha (255 * 0.2)
                        spreadRadius: -2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2.0,
                      left: 5.0,
                    ),
                    child: SizedBox(
                      width: 40,
                      child: IconButton.filled(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all<Color>(widget.fillColor),
                        ),
                        color: widget.inputColor,
                        iconSize: 20,
                        onPressed: () {
                          print("Current Value: $_currentValue");
                          if (widget.maxValue == null ||
                              _currentValue <= widget.maxValue!) {
                            setState(() {
                              widget.controller.text =
                                  (_currentValue + 1).toString();
                              _currentValue =
                                  int.tryParse(widget.controller.text)!;
                            });
                          }
                          print("New Current Value: $_currentValue");
                        },
                        icon: const Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _currentValue < (widget.minValue ?? 0) ||
                      _currentValue > widget.maxValue!,
                  child: const SizedBox(
                    height: 21,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
