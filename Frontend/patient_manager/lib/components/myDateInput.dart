import 'package:flutter/material.dart';
import 'package:patient_manager/theme/mihTheme.dart';

class MyDateField extends StatefulWidget {
  final controller;
  final String LableText;
  final bool required;

  const MyDateField({
    super.key,
    required this.controller,
    required this.LableText,
    required this.required,
  });

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
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
            style: TextStyle(color: MyTheme().errorColor()),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(widget.LableText,
              style: TextStyle(color: MyTheme().secondaryColor())),
        ],
      );
    } else {
      return Text(widget.LableText,
          style: TextStyle(color: MyTheme().secondaryColor()));
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        style: TextStyle(color: MyTheme().secondaryColor()),
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
              color: MyTheme().errorColor(), fontWeight: FontWeight.bold),
          label: setRequiredText(),
          //labelText: widget.LableText,
          //labelStyle: const TextStyle(color: Colors.blueAccent),
          prefixIcon: Icon(
            Icons.calendar_today,
            color: MyTheme().secondaryColor(),
          ),
          fillColor: MyTheme().primaryColor(),
          filled: true,
          //hintText: hintText,
          //hintStyle: TextStyle(color: Colors.blueGrey[400]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyTheme().secondaryColor(),
              width: 2.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyTheme().errorColor(),
              width: 2.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: MyTheme().errorColor(),
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme().secondaryColor()),
          ),
        ),
        onTap: () {
          _selectDate(context);
        },
      ),
    );
  }
}
