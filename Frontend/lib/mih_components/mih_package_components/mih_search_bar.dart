import 'package:flutter/material.dart';

class MihSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final IconData? prefixAltIcon;
  final List<Widget>? suffixTools;
  final double? width;
  final double? height;
  final Color fillColor;
  final Color hintColor;
  final void Function()? onPrefixIconTap;
  final void Function()? onClearIconTap;
  final double? elevation;
  final FocusNode searchFocusNode;

  const MihSearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.prefixAltIcon,
    this.suffixTools,
    this.width,
    this.height,
    required this.fillColor,
    required this.hintColor,
    required this.onPrefixIconTap,
    this.onClearIconTap,
    this.elevation,
    required this.searchFocusNode,
  }) : super(key: key);

  @override
  State<MihSearchBar> createState() => _MihSearchBarState();
}

class _MihSearchBarState extends State<MihSearchBar> {
  bool _showClearIcon = false;

  Widget getPrefixIcon() {
    if (_showClearIcon) {
      // If the clear icon is shown and an alternative prefix icon is provided, use it
      return widget.prefixAltIcon != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                widget.prefixAltIcon,
                color: widget.hintColor,
                size: 35,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                Icons.search,
                color: widget.hintColor,
                size: 35,
              ),
            ); // Default to search icon if no alt icon
    } else {
      // Return the primary prefix icon or the alternative if provided
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Icon(
          Icons.search,
          color: widget.hintColor,
          size: 35,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // 1. Add the listener to the controller
    widget.controller.addListener(_updateClearIconVisibility);
    // 2. Initialize the clear icon visibility based on the current text
    _updateClearIconVisibility();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateClearIconVisibility);
    super.dispose();
  }

  void _updateClearIconVisibility() {
    if (!mounted) {
      return;
    }
    final bool shouldShow = widget.controller.text.isNotEmpty;
    // Only call setState if the visibility state actually changes
    if (_showClearIcon != shouldShow) {
      setState(() {
        _showClearIcon = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.elevation ?? 4.0, // Use provided elevation or default
      borderRadius: BorderRadius.circular(30.0),
      color: widget.fillColor,
      child: AnimatedContainer(
        // Keep AnimatedContainer for width/height transitions
        width: widget.width,
        height: widget.height ?? 50,
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: widget.hintColor.withValues(alpha: 0.3),
              selectionHandleColor: widget.hintColor,
            ),
          ),
          child: TextField(
            controller: widget.controller, // Assign the controller
            focusNode: widget.searchFocusNode,
            style: TextStyle(
              color: widget.hintColor,
              fontWeight: FontWeight.w600,
            ),
            cursorColor: widget.hintColor,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                color: widget.hintColor,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              prefixIcon: GestureDetector(
                onTap: widget.onPrefixIconTap,
                child: getPrefixIcon(),
              ),
              suffixIcon: Row(
                // Use a Row for multiple suffix icons
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Optional suffix tools
                  if (widget.suffixTools != null) ...widget.suffixTools!,
                  // Clear Icon (conditionally visible)
                  if (_showClearIcon) // Only show if input is not empty
                    IconButton(
                      icon: Icon(Icons.clear,
                          color: widget.hintColor), // Clear icon
                      onPressed: widget.onClearIconTap ??
                          () {
                            widget.controller.clear();
                            // No need for setState here, _updateClearIconVisibility will handle it
                          },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
