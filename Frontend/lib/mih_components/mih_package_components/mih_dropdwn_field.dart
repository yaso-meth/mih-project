import 'package:flutter/material.dart';
import '../../main.dart';

class MihDropdownField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool requiredText;
  final List<String> dropdownOptions;
  final bool editable;
  final bool enableSearch;
  final FormFieldValidator<String>? validator;

  const MihDropdownField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.dropdownOptions,
    required this.requiredText,
    required this.editable,
    required this.enableSearch,
    this.validator,
  });

  @override
  State<MihDropdownField> createState() => _MihDropdownFieldState();
}

class _MihDropdownFieldState extends State<MihDropdownField> {
  late List<DropdownMenuEntry<String>> menu;

  List<DropdownMenuEntry<String>> buildMenuOptions(List<String> options) {
    List<DropdownMenuEntry<String>> menuList = [];
    final theme = MzanziInnovationHub.of(context)!.theme;
    for (final i in options) {
      menuList.add(DropdownMenuEntry(
        value: i,
        label: i,
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(theme.primaryColor()),
        ),
      ));
    }
    return menuList;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    menu = buildMenuOptions(widget.dropdownOptions);
  }

  @override
  void initState() {
    super.initState();
    menu = widget.dropdownOptions
        .map((e) => DropdownMenuEntry(value: e, label: e))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = MzanziInnovationHub.of(context)!.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.hintText,
              style: TextStyle(
                color: theme.secondaryColor(),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!widget.requiredText)
              Text(
                "(Optional)",
                style: TextStyle(
                  color: theme.secondaryColor(),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        FormField<String>(
          validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: widget.controller.text,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: theme.primaryColor(),
                      selectionColor:
                          theme.primaryColor().withValues(alpha: 0.3),
                      selectionHandleColor: theme.primaryColor(),
                    ),
                  ),
                  child: DropdownMenu(
                    controller: widget.controller,
                    dropdownMenuEntries: menu,
                    enableSearch: widget.enableSearch,
                    enableFilter: widget.enableSearch,
                    enabled: widget.editable,
                    textInputAction: TextInputAction.search,
                    requestFocusOnTap: true,
                    menuHeight: 400,
                    expandedInsets: EdgeInsets.zero,
                    textStyle: TextStyle(
                      color: theme.primaryColor(),
                      fontWeight: FontWeight.w500,
                    ),
                    trailingIcon: Icon(
                      Icons.arrow_drop_down,
                      color: theme.primaryColor(),
                    ),
                    selectedTrailingIcon: Icon(
                      Icons.arrow_drop_up,
                      color: theme.primaryColor(),
                    ),
                    leadingIcon: IconButton(
                      onPressed: () {
                        widget.controller.clear();
                        field.didChange('');
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: theme.primaryColor(),
                      ),
                    ),
                    onSelected: (String? selectedValue) {
                      field.didChange(selectedValue);
                    },
                    menuStyle: MenuStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(theme.secondaryColor()),
                      side: WidgetStatePropertyAll(
                        BorderSide(color: theme.primaryColor(), width: 1.0),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Increase for more roundness
                        ),
                      ),
                    ),
                    inputDecorationTheme: InputDecorationTheme(
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      filled: true,
                      fillColor: theme.secondaryColor(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: field.hasError
                              ? theme.errorColor()
                              : theme.secondaryColor(),
                          width: 3.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: theme.errorColor(),
                          width: 3.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: theme.errorColor(),
                          width: 3.0,
                        ),
                      ),
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      field.errorText ?? '',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.errorColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
