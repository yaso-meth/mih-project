import 'package:flutter/material.dart';

class MyDropdownField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool required;
  final List<String> dropdownOptions;
  final void Function(String?)? onSelect;
  //final bool editable;

  const MyDropdownField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.dropdownOptions,
    required this.required,
    this.onSelect,
  });

  @override
  State<MyDropdownField> createState() => _MyDropdownFieldState();
}

class _MyDropdownFieldState extends State<MyDropdownField> {
  //var dropbownItems = ["Dr.", "Assistant"];
  bool startup = true;
  final FocusNode _focus = FocusNode();
  late var menu;

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

  List<DropdownMenuEntry<String>> buidMenueOptions(List<String> options) {
    List<DropdownMenuEntry<String>> menueList = [];
    for (final i in options) {
      menueList.add(DropdownMenuEntry(value: i, label: i));
    }
    return menueList;
  }

  @override
  void initState() {
    menu = buidMenueOptions(widget.dropdownOptions);
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  // bool makeEditable() {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: DropdownMenu(
        //onSelected: widget.onSelect,
        menuHeight: 300,
        controller: widget.controller,
        expandedInsets: EdgeInsets.zero,
        label: setRequiredText(),
        errorText: _errorText,
        focusNode: _focus,
        onSelected: (_) => setState(() {
          startup = false;
        }),
        leadingIcon: IconButton(
          onPressed: () {
            setState(() {
              startup = false;
            });
            widget.controller.clear();
          },
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: Colors.blueAccent,
          ),
        ),
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
        dropdownMenuEntries: menu,
        // const <DropdownMenuEntry<String>>[
        //   DropdownMenuEntry(value: "Dr.", label: "Dr."),
        //   DropdownMenuEntry(value: "Assistant", label: "Assistant"),
        // ],
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
