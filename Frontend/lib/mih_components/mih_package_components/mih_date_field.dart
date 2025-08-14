import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihDateField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool required;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? elevation;
  final FormFieldValidator<String>? validator;
  const MihDateField({
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
  State<MihDateField> createState() => _MihDateFieldState();
}

class _MihDateFieldState extends State<MihDateField> {
  FormFieldState<String>? _formFieldState;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.controller.text.isNotEmpty
          ? DateTime.tryParse(widget.controller.text) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      widget.controller.text = picked.toString().split(" ")[0];
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
                        onTap: () => _selectDate(context),
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.calendar_today,
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
