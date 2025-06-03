import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mzansi_innovation_hub/main.dart';

class MihTextFormField extends StatefulWidget {
  final double? width;
  final double? height;
  final Color fillColor;
  final Color inputColor;
  final TextEditingController controller;
  final bool? hasError;
  final String hintText;
  final double? borderRadius;
  final bool? multiLineInput;
  final bool? editable;
  final bool? passwordMode;
  final bool? numberMode;
  final bool requiredText;
  final FormFieldValidator<String>? validator;
  final List<String>? autofillHints;
  final double? elevation;

  const MihTextFormField({
    Key? key,
    this.width,
    this.height,
    required this.fillColor,
    required this.inputColor,
    required this.controller,
    this.hasError,
    required this.hintText,
    required this.requiredText,
    this.borderRadius,
    this.multiLineInput,
    this.editable,
    this.passwordMode,
    this.numberMode,
    this.validator,
    this.autofillHints,
    this.elevation,
  }) : super(key: key);

  @override
  State<MihTextFormField> createState() => _MihTextFormFieldState();
}

class _MihTextFormFieldState extends State<MihTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.passwordMode ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: widget.inputColor.withValues(alpha: 0.3),
          selectionHandleColor: widget.inputColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.hintText,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: widget.fillColor,
                  fontSize: 15,
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
          FormField<String>(
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (field) {
              return Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // <-- Add this line
                children: [
                  Material(
                    elevation: widget.elevation ?? 4.0,
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius ?? 8.0),
                    child: SizedBox(
                      width: widget.width,
                      height: widget.height,
                      child: TextFormField(
                        controller: widget.controller,
                        cursorColor: widget.inputColor,
                        autofillHints: widget.autofillHints,
                        textAlign: TextAlign.start,
                        textAlignVertical: widget.multiLineInput == true
                            ? TextAlignVertical.top
                            : TextAlignVertical.center,
                        obscureText:
                            widget.passwordMode == true ? _obscureText : false,
                        expands: widget.passwordMode == true
                            ? false
                            : (widget.multiLineInput ?? false),
                        maxLines: widget.passwordMode == true ? 1 : null,
                        readOnly: widget.editable ?? false,
                        keyboardType: widget.numberMode == true
                            ? TextInputType.number
                            : null,
                        inputFormatters: widget.numberMode == true
                            ? [FilteringTextInputFormatter.digitsOnly]
                            : null,
                        style: TextStyle(
                          color: widget.inputColor,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: widget.passwordMode == true
                              ? IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: widget.inputColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                )
                              : null,
                          errorStyle: const TextStyle(
                              height: 0, fontSize: 0), // <-- Add this line
                          // errorStyle: TextStyle(
                          //   color: MzanziInnovationHub.of(context)!
                          //       .theme
                          //       .errorColor(),
                          //   fontWeight: FontWeight.bold,
                          // ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 8.0),
                          filled: true,
                          fillColor: widget.fillColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 8.0),
                            borderSide: field.hasError
                                ? BorderSide(
                                    color: MzanziInnovationHub.of(context)!
                                        .theme
                                        .errorColor(),
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
                                  ? MzanziInnovationHub.of(context)!
                                      .theme
                                      .errorColor()
                                  : widget.inputColor,
                              width: 2.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 8.0),
                            borderSide: BorderSide(
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .errorColor(),
                              width: 2.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                widget.borderRadius ?? 8.0),
                            borderSide: BorderSide(
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .errorColor(),
                              width: 2.0,
                            ),
                          ),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(
                          //       widget.borderRadius ?? 8.0),
                          //   borderSide: BorderSide.none,
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(
                          //       widget.borderRadius ?? 8.0),
                          //   borderSide: BorderSide.none,
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(
                          //       widget.borderRadius ?? 8.0),
                          //   borderSide: BorderSide(
                          //     color: widget.inputColor,
                          //     width: 2.0,
                          //   ),
                          // ),
                          // errorBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(
                          //       widget.borderRadius ?? 8.0),
                          //   borderSide: BorderSide(
                          //     color: MzanziInnovationHub.of(context)!
                          //         .theme
                          //         .errorColor(),
                          //     width: 2.0,
                          //   ),
                          // ),
                          // focusedErrorBorder: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(
                          //       widget.borderRadius ?? 8.0),
                          //   borderSide: BorderSide(
                          //     color: MzanziInnovationHub.of(context)!
                          //         .theme
                          //         .errorColor(),
                          //     width: 2.0,
                          //   ),
                          // ),
                        ),
                        onChanged: (value) {
                          field.didChange(value);
                        },
                      ),
                    ),
                  ),
                  if (field.hasError)
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                          child: Text(
                            field.errorText ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .errorColor(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
