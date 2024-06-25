import 'package:flutter/material.dart';

class MyDateField extends StatefulWidget {
  final controller;
  final String LableText;
  //final bool editable;

  const MyDateField({
    super.key,
    required this.controller,
    required this.LableText,
    //required this.editable,
  });

  @override
  State<MyDateField> createState() => _MyDateFieldState();
}

class _MyDateFieldState extends State<MyDateField> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        readOnly: true,
        obscureText: false,
        decoration: InputDecoration(
          labelText: widget.LableText,
          prefixIcon: const Icon(Icons.calendar_today),
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
