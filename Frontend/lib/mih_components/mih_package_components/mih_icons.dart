import 'package:flutter/widgets.dart'; // You need this import for IconData

class MihIcons {
  MihIcons._(); // This makes the class non-instantiable (good practice for utility classes)

  // This MUST match the 'family' name you specify in pubspec.yaml
  static const _mihFontFam = 'MihIcons';
  // Set to your package name ONLY if this font is part of a separate package you created
  static const String? _mihFontPkg = null;

// IconData constants based on your style.css file
  // Note: We convert the hex code from CSS (\eXXX) to an integer (0xeXXX)

  static const IconData aboutMih =
      IconData(0xe900, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData accessControl =
      IconData(0xe901, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData businessProfile =
      IconData(0xe902, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData calculator =
      IconData(0xe903, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData calendar =
      IconData(0xe904, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData mihLogo =
      IconData(0xe905, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData mzansiAi =
      IconData(0xe906, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData mzansiWallet =
      IconData(0xe907, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData patientManager =
      IconData(0xe908, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData patientProfile =
      IconData(0xe909, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData mihRing =
      IconData(0xe90a, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData profileSetup =
      IconData(0xe90c, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData businessSetup =
      IconData(0xe90b, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData notifications =
      IconData(0xe90e, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);

  static const IconData personalProfile =
      IconData(0xe90f, fontFamily: _mihFontFam, fontPackage: _mihFontPkg);
}
