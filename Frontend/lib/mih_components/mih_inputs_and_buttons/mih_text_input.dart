import 'package:flutter/material.dart';
import '../../main.dart';

class MIHTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool editable;
  final bool required;
  final Iterable<String>? autoFillHintGroup;

  const MIHTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.editable,
    required this.required,
    this.autoFillHintGroup,
  });

  @override
  State<MIHTextField> createState() => _MIHTextFieldState();
}

class _MIHTextFieldState extends State<MIHTextField> {
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
    // if (widget.hintText == "Username" && text.length < 8) {
    //   errorMessage += "• Username must contain at least 8 characters.\n";
    // }
    if (widget.hintText == "Username" && !isUsernameValid(text)) {
      errorMessage += "Let's create a great username for you!\n";
      errorMessage += "• Your username should start with a letter.\n";
      errorMessage += "• You can use letters, numbers, and/ or underscores.\n";
      errorMessage += "• Keep it between 6 and 30 characters.\n";
      errorMessage += "• Avoid special characters like @, #, or \$.\"\n";
    }
    if (errorMessage.isEmpty) {
      return null;
    }
    // If there are no error messages, the password is valid
    return errorMessage;
  }

  bool isUsernameValid(String username) {
    return RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{5,19}$').hasMatch(username);
  }

  bool isEmailValid(String email) {
    var regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }

  void _onFocusChange() {
    setState(() {
      startup = false;
    });
  }

  // List<AutofillGroup> getAutoFillDetails(){
  //   if(widget.autoFillHintGroup == null){
  //     return [];
  //   }
  //   else{
  //     return widget.autoFillHintGroup!;
  //   }
  // }

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
      autofillHints: widget.autoFillHintGroup,
      style: TextStyle(
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      ),
      controller: widget.controller,
      focusNode: _focus,
      readOnly: makeEditable(),
      //enabled: !makeEditable(),
      obscureText: false,
      onChanged: (_) => setState(() {
        startup = false;
      }),
      decoration: InputDecoration(
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
