import 'package:flutter/widgets.dart'; // You need this import for IconData

class MihIcons {
  MihIcons._(); // This makes the class non-instantiable (good practice for utility classes)

  // This MUST match the 'family' name you specify in pubspec.yaml
  static const _mihFontFam = 'MihIcons';
  // Set to your package name ONLY if this font is part of a separate package you created
  static const String? _mihFontPkg = null;

  // IconData constant for 'mih_circle_frame' using its code 59392
  // Note: We use lowerCamelCase for Dart variable names
  static const IconData mihCircleFrame =
      IconData(59393, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  // IconData constant for 'mih_logo' using its code 59393
  static const IconData mihLogo =
      IconData(59392, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  // IconData constant for 'mzansi_ai_logo' using its code 59394
  static const IconData mzansiAiLogo =
      IconData(59394, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);
}
