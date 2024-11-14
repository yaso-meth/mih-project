import 'package:flutter/material.dart';
import '../../main.dart';

class MIHTimeField extends StatefulWidget {
  final TextEditingController controller;
  final String lableText;
  final bool required;

  const MIHTimeField({
    super.key,
    required this.controller,
    required this.lableText,
    required this.required,
  });

  @override
  State<MIHTimeField> createState() => _MIHDateFieldState();
}

class _MIHDateFieldState extends State<MIHTimeField> {
  final FocusNode _focus = FocusNode();
  bool startup = true;

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child as Widget,
        );
      },
    );
    if (picked != null) {
      String hours = "";
      String minutes = "";
      setState(() {
        if (picked.hour <= 9) {
          hours = "0${picked.hour}";
        } else {
          hours = "${picked.hour}";
        }

        if (picked.minute <= 9) {
          minutes = "0${picked.minute}";
        } else {
          minutes = "${picked.minute}";
        }

        widget.controller.text = "$hours:$minutes";
      });
    }
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
          Text(widget.lableText,
              style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor())),
        ],
      );
    } else {
      return Text(widget.lableText,
          style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()));
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
      return "${widget.lableText} is required";
    }
    return null;
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
      readOnly: true,
      obscureText: false,
      focusNode: _focus,
      onChanged: (_) => setState(() {
        startup = false;
      }),
      decoration: InputDecoration(
        errorText: _errorText,
        errorStyle: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            fontWeight: FontWeight.bold),
        label: setRequiredText(),
        //labelText: widget.lableText,
        //labelStyle: const TextStyle(color: Colors.blueAccent),
        prefixIcon: Icon(
          Icons.access_alarm,
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
        fillColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        filled: true,
        //hintText: hintText,
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
      ),
      onTap: () {
        _selectTime(context);
      },
    );
  }
}
