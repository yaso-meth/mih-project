import 'package:flutter/material.dart';
import '../../main.dart';

class MIHSearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool required;
  final bool editable;
  final void Function() onTap;

  const MIHSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.required,
    required this.editable,
    required this.onTap,
  });

  @override
  State<MIHSearchField> createState() => _MIHSearchFieldState();
}

class _MIHSearchFieldState extends State<MIHSearchField> {
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
          Text(
            "*",
            style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.errorColor()),
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(
            widget.hintText,
            style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
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
      onChanged: (_) {
        setState(() {
          startup = false;
        });
      },
      controller: widget.controller,
      //style: TextStyle(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
      readOnly: makeEditable(),
      focusNode: _focus,
      obscureText: false,
      decoration: InputDecoration(
        fillColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.search,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
        errorStyle: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            fontWeight: FontWeight.bold),
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
