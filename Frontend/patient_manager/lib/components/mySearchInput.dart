import 'package:flutter/material.dart';

class MySearchField extends StatelessWidget {
  final controller;
  final String hintText;
  final void Function(String)? onChanged;

  const MySearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        onChanged: onChanged,
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.blueAccent,
          ),
          filled: true,
          label: Text(hintText),
          labelStyle: const TextStyle(color: Colors.blueAccent),
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
