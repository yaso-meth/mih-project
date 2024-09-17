import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MIHPassField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool required;
  final bool signIn;

  const MIHPassField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.required,
    required this.signIn,
  });

  @override
  State<MIHPassField> createState() => _MIHPassFieldState();
}

class _MIHPassFieldState extends State<MIHPassField> {
  bool startup = true;
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;
  //bool valid = false;

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
    String _errorMessage = '';
    if (startup) {
      return null;
    }
    if (!widget.required) {
      return null;
    }
    if (text.isEmpty) {
      return "${widget.hintText} is required";
    }
    // Password length greater than 8
    if (text.length <= 8 && !widget.signIn) {
      _errorMessage += '• Password must contain at least 8 characters.\n';
    }

    // Contains at least one uppercase letter
    if (!text.contains(RegExp(r'[A-Z]')) && !widget.signIn) {
      _errorMessage += '• Uppercase letter is missing.\n';
    }

    // Contains at least one lowercase letter
    if (!text.contains(RegExp(r'[a-z]')) && !widget.signIn) {
      _errorMessage += '• Lowercase letter is missing.\n';
    }

    // Contains at least one digit
    if (!text.contains(RegExp(r'[0-9]')) && !widget.signIn) {
      _errorMessage += '• number is missing.\n';
    }

    // Contains at least one special character
    if (!text.contains(RegExp(r'[!@#$%^&*]')) && !widget.signIn) {
      _errorMessage += '• Special character is missing - !@#\$%^&*\n';
    }

    // Contains no errors
    if (_errorMessage.isEmpty) {
      return null;
    }
    // If there are no error messages, the password is valid
    return _errorMessage;
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

  void _onFocusChange() {
    setState(() {
      startup = false;
    });
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    textFieldFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
      obscureText: _obscured,
      focusNode: textFieldFocusNode,
      onChanged: (_) => setState(() {
        startup = false;
      }),
      decoration: InputDecoration(
        fillColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        filled: true,
        label: setRequiredText(),
        //labelStyle: const TextStyle(color: Colors.blueAccent),
        errorText: _errorText,
        errorStyle: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            fontWeight: FontWeight.bold),
        //hintText: widget.hintText,
        //hintStyle: TextStyle(color: Colors.blueGrey[400]),
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
        suffixIcon: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: GestureDetector(
            onTap: _toggleObscured,
            child: Icon(
              _obscured
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              size: 24,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
        ),
      ),
    );
  }
}
