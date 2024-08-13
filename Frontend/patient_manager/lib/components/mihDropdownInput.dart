import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MIHDropdownField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool required;
  final List<String> dropdownOptions;
  final void Function(String?)? onSelect;
  final bool editable;

  const MIHDropdownField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.dropdownOptions,
    required this.required,
    required this.editable,
    this.onSelect,
  });

  @override
  State<MIHDropdownField> createState() => _MIHDropdownFieldState();
}

class _MIHDropdownFieldState extends State<MIHDropdownField> {
  //var dropbownItems = ["Dr.", "Assistant"];
  bool startup = true;
  final FocusNode _focus = FocusNode();
  late var menu;

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
      menueList.add(DropdownMenuEntry(
          value: i,
          label: i,
          style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(
                  MzanziInnovationHub.of(context)!.theme.secondaryColor()))));
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
    return DropdownMenu(
      enabled: widget.editable,
      trailingIcon: Icon(
        Icons.arrow_drop_down,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      ),
      selectedTrailingIcon: Icon(
        Icons.arrow_drop_up,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      ),
      textStyle: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
      menuHeight: 300,
      controller: widget.controller,
      expandedInsets: EdgeInsets.zero,
      label: setRequiredText(),
      errorText: _errorText,

      focusNode: _focus,
      onSelected: (_) {
        setState(() {
          startup = false;
        });
        // if (widget.editable == false) {
        //   return false;
        // }
      },
      leadingIcon: IconButton(
        onPressed: () {
          setState(() {
            startup = false;
          });
          widget.controller.clear();
        },
        icon: Icon(
          Icons.delete_outline_rounded,
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
            MzanziInnovationHub.of(context)!.theme.primaryColor()),
        side: WidgetStatePropertyAll(
          BorderSide(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              width: 2.0),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        errorStyle: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            fontWeight: FontWeight.bold),
        fillColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 2.0,
          ),
        ),
        outlineBorder: BorderSide(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
      ),
      dropdownMenuEntries: menu,
      // const <DropdownMenuEntry<String>>[
      //   DropdownMenuEntry(value: "Dr.", label: "Dr."),
      //   DropdownMenuEntry(value: "Assistant", label: "Assistant"),
      // ],
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
