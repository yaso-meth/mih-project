import 'package:flutter/material.dart';

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
          const Text(
            "*",
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(widget.LableText,
              style: const TextStyle(color: Colors.blueAccent)),
        ],
      );
    } else {
      return Text(widget.LableText,
          style: const TextStyle(color: Colors.blueAccent));
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
        controller: widget.controller,
        readOnly: true,
        obscureText: false,
        focusNode: _focus,
        onChanged: (_) => setState(() {
          startup = false;
        }),
        decoration: InputDecoration(
          errorText: _errorText,
          label: setRequiredText(),
          //labelText: widget.LableText,
          //labelStyle: const TextStyle(color: Colors.blueAccent),
          prefixIcon: const Icon(
            Icons.calendar_today,
            color: Colors.blueAccent,
          ),
          fillColor: Colors.white,
          filled: true,
          //hintText: hintText,
          hintStyle: TextStyle(color: Colors.blueGrey[400]),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2.0,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
        onTap: () {
          _selectDate(context);
        },
      ),
    );
  }
}
