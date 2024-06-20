import 'package:flutter/material.dart';

class MyMLTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool editable;

  const MyMLTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.editable,
  });

  bool makeEditable() {
    if (editable) {
      return false;
    } else {
      return true;
    }
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
        controller: controller,
        readOnly: makeEditable(),
        obscureText: false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
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
      ),
    );
  }
}
