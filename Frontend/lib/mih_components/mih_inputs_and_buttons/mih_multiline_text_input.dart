import 'package:flutter/material.dart';
import '../../main.dart';

class MIHMLTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool editable;
  final bool required;

  const MIHMLTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.editable,
    required this.required,
  });

  @override
  State<MIHMLTextField> createState() => _MIHMLTextFieldState();
}

class _MIHMLTextFieldState extends State<MIHMLTextField> {
  bool startup = true;
  final FocusNode _focus = FocusNode();

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
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.top,
      expands: true,
      maxLines: null,
      controller: widget.controller,
      readOnly: makeEditable(),
      obscureText: false,
      focusNode: _focus,
      onChanged: (_) => setState(() {
        startup = false;
      }),
      decoration: InputDecoration(
        label: setRequiredText(),
        errorText: _errorText,
        errorStyle: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            fontWeight: FontWeight.bold),
        labelStyle: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        alignLabelWithHint: true,
        fillColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        filled: true,
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
    );
  }
}
