import 'package:flutter/material.dart';
import '../../main.dart';

class MIHFileField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool editable;
  final bool required;
  final void Function() onPressed;

  const MIHFileField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.editable,
    required this.required,
    required this.onPressed,
  });

  @override
  State<MIHFileField> createState() => _MIHFileFieldState();
}

class _MIHFileFieldState extends State<MIHFileField> {
  bool startup = true;
  final FocusNode _focus = FocusNode();

  bool makeEditable() {
    if (widget.editable) {
      return false;
    } else {
      return true;
    }
  }

  String? get _errorText {
    final text = widget.controller.text;
    String errorMessage = '';
    if (startup) {
      return null;
    }
    if (!widget.required) {
      return null;
    }
    if (text.isEmpty) {
      return "${widget.hintText} is required";
    }
    if (widget.hintText == "Email" && !isEmailValid(text)) {
      errorMessage += "Enter a valid email address\n";
    }
    if (widget.hintText == "Username" && text.length < 8) {
      errorMessage += "• Username must contain at least 8 characters.\n";
    }
    if (widget.hintText == "Username" && !isUsernameValid(text)) {
      errorMessage += "• Username can only contain '_' special Chracters.\n";
    }
    if (errorMessage.isEmpty) {
      return null;
    }
    // If there are no error messages, the password is valid
    return errorMessage;
  }

  bool isUsernameValid(String username) {
    return RegExp(r'^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$')
        .hasMatch(username);
  }

  bool isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
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
          Text(
            "*",
            style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.errorColor()),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(widget.hintText,
              style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor())),
        ],
      );
    } else {
      return Text(widget.hintText,
          style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()));
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _focus.addListener(_onFocusChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
      controller: widget.controller,
      focusNode: _focus,
      readOnly: makeEditable(),
      //enabled: !makeEditable(),
      obscureText: false,
      onChanged: (_) => setState(() {
        startup = false;
      }),
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: const Icon(Icons.attach_file),
          onPressed: widget.onPressed,
        ),
        label: setRequiredText(),
        //labelStyle: TextStyle(color: MzanziInnovationHub.of(context)!.theme.primaryColor()),
        fillColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        filled: true,
        errorText: _errorText,
        errorStyle: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            fontWeight: FontWeight.bold),
        //errorBorder: const InputBorder(),
        //hintText: hintText,
        //hintStyle: TextStyle(color: Colors.blueGrey[400]),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        ),
      ),
    );
  }
}
