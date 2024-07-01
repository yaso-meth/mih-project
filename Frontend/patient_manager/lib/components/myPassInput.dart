import 'package:flutter/material.dart';

class MyPassField extends StatefulWidget {
  final controller;
  final String hintText;
  final bool required;

  const MyPassField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.required,
  });

  @override
  State<MyPassField> createState() => _MyPassFieldState();
}

class _MyPassFieldState extends State<MyPassField> {
  bool startup = true;
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
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
      return "${widget.hintText} is required";
    }
    return null;
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

  void _onFocusChange() {
    setState(() {
      startup = false;
    });
  }

  @override
  void initState() {
    textFieldFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscured,
        focusNode: textFieldFocusNode,
        onChanged: (_) => setState(() {
          startup = false;
        }),
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          label: setRequiredText(),
          //labelStyle: const TextStyle(color: Colors.blueAccent),
          errorText: _errorText,
          //hintText: widget.hintText,
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
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
            child: GestureDetector(
              onTap: _toggleObscured,
              child: Icon(
                _obscured
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                size: 24,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
