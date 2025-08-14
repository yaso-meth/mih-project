import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihTimeField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool required;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? elevation;
  final FormFieldValidator<String>? validator;

  const MihTimeField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.required,
    this.width,
    this.height,
    this.borderRadius,
    this.elevation,
    this.validator,
  });

  @override
  State<MihTimeField> createState() => _MihTimeFieldState();
}

class _MihTimeFieldState extends State<MihTimeField> {
  FormFieldState<String>? _formFieldState;

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.controller.text.isNotEmpty
          ? TimeOfDay(
              hour: int.tryParse(widget.controller.text.split(":")[0]) ?? 0,
              minute: int.tryParse(widget.controller.text.split(":")[1]) ?? 0,
            )
          : TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child as Widget,
        );
      },
    );
    if (picked != null) {
      final hours = picked.hour.toString().padLeft(2, '0');
      final minutes = picked.minute.toString().padLeft(2, '0');
      widget.controller.text = "$hours:$minutes";
      _formFieldState?.didChange(widget.controller.text);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.labelText,
                  style: TextStyle(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!widget.required)
                  Text(
                    "(Optional)",
                    style: TextStyle(
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            FormField<String>(
              initialValue: widget.controller.text,
              validator: widget.validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              builder: (field) {
                _formFieldState = field;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      elevation: widget.elevation ?? 4.0,
                      borderRadius:
                          BorderRadius.circular(widget.borderRadius ?? 8.0),
                      child: TextFormField(
                        controller: widget.controller,
                        readOnly: true,
                        onTap: () => _selectTime(context),
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.access_time,
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                          ),
                          errorStyle: const TextStyle(height: 0, fontSize: 0),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          filled: true,
                          fillColor: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 8.0),
                            borderSide: field.hasError
                                ? BorderSide(
                                    color: MihColors.getRedColor(
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
                                            "Dark"),
                                    width: 2.0,
                                  )
                                : BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 8.0),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 8.0),
                            borderSide: BorderSide(
                              color: field.hasError
                                  ? MihColors.getRedColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark")
                                  : MihColors.getSecondaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                              width: 3.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 8.0),
                            borderSide: BorderSide(
                              color: MihColors.getRedColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              width: 3.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 8.0),
                            borderSide: BorderSide(
                              color: MihColors.getRedColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              width: 3.0,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          field.didChange(value);
                        },
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                        child: Text(
                          field.errorText ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: MihColors.getRedColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
