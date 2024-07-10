import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MyTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool editable;
  final bool required;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.editable,
    required this.required,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool startup = true;
  FocusNode _focus = FocusNode();

  bool makeEditable() {
    if (widget.editable) {
      return false;
    } else {
      return true;
    }
  }

  String? get _errorText {
    final text = widget.controller.text;
    if (startup) {
      return null;
    }
    if (!widget.required) {
      return null;
    }
    if (text.isEmpty) {
      return "${widget.hintText} is required";
    }
    return null;
  }

  void _onFocusChange() {
    setState(() {
      startup = false;
    });
  }

  Widget setRequiredText() {
    if (widget.required) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "*",
            style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.errorColor()),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(widget.hintText,
              style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor())),
        ],
      );
    } else {
      return Text(widget.hintText,
          style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()));
    }
  }

  @override
  void initState() {
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        controller: widget.controller,
        focusNode: _focus,
        readOnly: makeEditable(),
        obscureText: false,
        onChanged: (_) => setState(() {
          startup = false;
        }),
        decoration: InputDecoration(
          label: setRequiredText(),
          //labelStyle: TextStyle(color: MzanziInnovationHub.of(context)!.theme.primaryColor()),
          fillColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          filled: true,
          errorText: _errorText,
          errorStyle: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              fontWeight: FontWeight.bold),
          //errorBorder: const InputBorder(),
          //hintText: hintText,
          //hintStyle: TextStyle(color: Colors.blueGrey[400]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
          ),
        ),
      ),
    );
  }
}
