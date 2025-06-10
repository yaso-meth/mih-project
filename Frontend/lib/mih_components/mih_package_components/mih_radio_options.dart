import 'package:flutter/material.dart';

class MihRadioOptions extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Color fillColor;
  final Color secondaryFillColor;
  final bool requiredText;
  final List<String> radioOptions;
  const MihRadioOptions({
    super.key,
    required this.controller,
    required this.hintText,
    required this.fillColor,
    required this.secondaryFillColor,
    required this.requiredText,
    required this.radioOptions,
  });

  @override
  State<MihRadioOptions> createState() => _MihRadioOptionsState();
}

class _MihRadioOptionsState extends State<MihRadioOptions> {
  late String _currentSelection;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentSelection = widget.radioOptions[0];
    });
  }

  Widget displayRadioOptions() {
    return Material(
      elevation: 4.0,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: widget.fillColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: widget.radioOptions.map((option) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  int index = widget.radioOptions
                      .indexWhere((element) => element == option);
                  _currentSelection = widget.radioOptions[index];
                  widget.controller.text = option;
                });
              },
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: widget.secondaryFillColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Radio<String>(
                    value: option,
                    groupValue: _currentSelection,
                    onChanged: (value) {
                      setState(() {
                        _currentSelection = value!;
                        widget.controller.text = value;
                      });
                    },
                    activeColor: widget.secondaryFillColor,
                    fillColor: WidgetStateProperty.resolveWith<Color?>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return widget.secondaryFillColor; // Color when selected
                      }
                      return widget.secondaryFillColor;
                    }),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.hintText,
              textAlign: TextAlign.left,
              style: TextStyle(
                color: widget.fillColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Visibility(
              visible: !widget.requiredText,
              child: Text(
                "(Optional)",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: widget.fillColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        displayRadioOptions(),
      ],
    );
  }
}
