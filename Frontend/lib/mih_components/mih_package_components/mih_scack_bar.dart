import 'package:flutter/material.dart';

SnackBar MihSnackBar({
  required Widget child,
}) {
  return SnackBar(
    content: child,
    shape: StadiumBorder(),
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 2),
    width: null,
    action: SnackBarAction(
      label: "Dismiss",
      onPressed: () {},
    ),
    // elevation: 30,
  );
}
