import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:patient_manager/objects/appUser.dart';

class MyDropdownField extends StatefulWidget {
  final controller;
  final AppUser signedInUser;
  //final String hintText;
  final List<DropdownMenuEntry<String>> dropdownOptions;

  //final bool editable;

  const MyDropdownField({
    super.key,
    required this.controller,
    required this.signedInUser,
    //required this.hintText,
    required this.dropdownOptions,
  });

  @override
  State<MyDropdownField> createState() => _MyDropdownFieldState();
}

class _MyDropdownFieldState extends State<MyDropdownField> {
  var dropbownItems = ["Dr.", "Assistant"];
  // bool makeEditable() {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownMenu(
        controller: widget.controller,
        expandedInsets: EdgeInsets.zero,
        label: const Text("Title", style: TextStyle(color: Colors.blueAccent)),
        menuStyle: const MenuStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.white),
          side: WidgetStatePropertyAll(
            BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2.0,
            ),
          ),
          outlineBorder: BorderSide(color: Colors.blue),
        ),
        dropdownMenuEntries: widget.dropdownOptions,
      ),
    );
  }
}

//           filled: true,
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.blueGrey[400]),
//           enabledBorder: const OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.blueAccent,
//               width: 2.0,
//             ),
//           ),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blue),
