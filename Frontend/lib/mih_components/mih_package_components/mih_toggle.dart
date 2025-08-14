import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

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
  void didUpdateWidget(covariant MihToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPostion != oldWidget.initialPostion) {
      setState(() {
        togglePosition = widget.initialPostion;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    togglePosition = widget.initialPostion;
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
          value: togglePosition,
          trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (widget.readOnly == true) {
                return Colors.grey;
              }
              if (states.contains(WidgetState.selected)) {
                return MihColors.getGreenColor(
                    MzansiInnovationHub.of(context)!.theme.mode ==
                        "Dark"); // Outline color when active
              }
              return MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode ==
                      "Dark"); // Outline color when active
            },
          ),
          activeColor:
              widget.readOnly == true ? Colors.grey : widget.secondaryFillColor,
          activeTrackColor: widget.readOnly == true
              ? Colors.grey.shade400
              : MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          inactiveThumbColor:
              widget.readOnly == true ? Colors.grey : widget.secondaryFillColor,
          inactiveTrackColor: widget.readOnly == true
              ? Colors.grey.shade400
              : MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          // activeColor: widget.secondaryFillColor,
          // activeTrackColor: widget.fillColor,
          // inactiveThumbColor: widget.fillColor,
          // inactiveTrackColor: widget.secondaryFillColor,
          // onChanged: widget.readOnly != true ? widget.onChange : null,
          onChanged: widget.readOnly != true
              ? (newValue) {
                  setState(() {
                    togglePosition = newValue; // Update internal state
                  });
                  widget.onChange(newValue); // Call the parent's onChange
                }
              : null,
        ),
      ],
    );
  }
}
