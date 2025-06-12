import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';

class MihToggle extends StatefulWidget {
  final String hintText;
  final bool initialPostion;
  final Color fillColor;
  final Color secondaryFillColor;
  final bool? readOnly;
  final void Function(bool) onChange;
  const MihToggle({
    super.key,
    required this.hintText,
    required this.initialPostion,
    required this.fillColor,
    required this.secondaryFillColor,
    this.readOnly,
    required this.onChange,
  });

  @override
  State<MihToggle> createState() => _MihToggleState();
}

class _MihToggleState extends State<MihToggle> {
  late bool togglePosition;

  @override
  void initState() {
    super.initState();
    setState(() {
      togglePosition = widget.initialPostion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            widget.hintText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: widget.fillColor,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Switch(
          value: widget.initialPostion,
          trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return MzanziInnovationHub.of(context)!
                    .theme
                    .successColor(); // Outline color when active
              }
              return MzanziInnovationHub.of(context)!
                  .theme
                  .errorColor(); // Outline color when active
            },
          ),
          activeColor:
              widget.readOnly == true ? Colors.grey : widget.secondaryFillColor,
          activeTrackColor: widget.readOnly == true
              ? Colors.grey.shade400
              : MzanziInnovationHub.of(context)!.theme.successColor(),
          inactiveThumbColor:
              widget.readOnly == true ? Colors.grey : widget.secondaryFillColor,
          inactiveTrackColor: widget.readOnly == true
              ? Colors.grey.shade400
              : MzanziInnovationHub.of(context)!.theme.errorColor(),
          // activeColor: widget.secondaryFillColor,
          // activeTrackColor: widget.fillColor,
          // inactiveThumbColor: widget.fillColor,
          // inactiveTrackColor: widget.secondaryFillColor,
          onChanged: widget.readOnly != true ? widget.onChange : null,
        ),
      ],
    );
  }
}
