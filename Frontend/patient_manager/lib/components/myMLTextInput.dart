import 'package:flutter/material.dart';

class MyMLTextField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool editable;
  final bool required;

  const MyMLTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.editable,
    required this.required,
  });

  @override
  State<MyMLTextField> createState() => _MyMLTextFieldState();
}

class _MyMLTextFieldState extends State<MyMLTextField> {
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
        children: [
          const Text(
            "*",
            style: TextStyle(color: Colors.red),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(widget.hintText,
              style: const TextStyle(color: Colors.blueAccent)),
        ],
      );
    } else {
      return Text(widget.hintText,
          style: const TextStyle(color: Colors.blueAccent));
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
          labelStyle: const TextStyle(color: Colors.blueAccent),
          alignLabelWithHint: true,
          fillColor: Colors.white,
          filled: true,
          //hintText: hintText,
          //hintStyle: TextStyle(color: Colors.blueGrey[400]),
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
      ),
    );
  }
}
