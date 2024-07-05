import 'package:flutter/material.dart';

class MySearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool required;
  final bool editable;
  final void Function(String)? onChanged;
  final void Function() onTap;

  const MySearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.required,
    required this.editable,
    required this.onTap,
  });

  @override
  State<MySearchField> createState() => _MySearchFieldState();
}

class _MySearchFieldState extends State<MySearchField> {
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
        onChanged: widget.onChanged,
        controller: widget.controller,
        readOnly: makeEditable(),
        focusNode: _focus,
        obscureText: false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          prefixIcon: IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.blueAccent,
            ),
            onPressed: () {
              setState(() {
                startup = false;
              });
              if (widget.controller.text != "") {
                widget.onTap();
              }
            },
          ),
          filled: true,
          label: setRequiredText(),
          errorText: _errorText,
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
