import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MIHDateField extends StatefulWidget {
  final controller;
  final String LableText;
  final bool required;

  const MIHDateField({
    super.key,
    required this.controller,
    required this.LableText,
    required this.required,
  });

  @override
  State<MIHDateField> createState() => _MIHDateFieldState();
}

class _MIHDateFieldState extends State<MIHDateField> {
  FocusNode _focus = FocusNode();
  bool startup = true;
  // bool makeEditable() {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        widget.controller.text = picked.toString().split(" ")[0];
      });
    }
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
          Text(widget.LableText,
              style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor())),
        ],
      );
    } else {
      return Text(widget.LableText,
          style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()));
    }
  }

  void _onFocusChange() {
    setState(() {
      startup = false;
    });
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
      return "${widget.LableText} is required";
    }
    return null;
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
      controller: widget.controller,
      readOnly: true,
      obscureText: false,
      focusNode: _focus,
      onChanged: (_) => setState(() {
        startup = false;
      }),
      decoration: InputDecoration(
        errorText: _errorText,
        errorStyle: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            fontWeight: FontWeight.bold),
        label: setRequiredText(),
        //labelText: widget.LableText,
        //labelStyle: const TextStyle(color: Colors.blueAccent),
        prefixIcon: Icon(
          Icons.calendar_today,
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
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
      onTap: () {
        _selectDate(context);
      },
    );
  }
}
