import 'package:flutter/material.dart';

class MihColors {
  static Color getPrimaryColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0XFF3A4454);
    } else {
      return const Color(0XFFbedcfe);
    }
  }

  static Color getSecondaryColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0XFFbedcfe);
    } else {
      return const Color(0XFF3A4454);
    }
  }

  static Color getHighlightColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0XFF9bc7fa);
    } else {
      return const Color(0XFF354866);
    }
  }

  static Color getGreyColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0XFFc8c8c8);
    } else {
      return const Color(0XFF747474);
    }
  }

  static Color getGreenColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0xff8ae290);
    } else {
      return const Color(0xFF41B349);
    }
  }

  static Color getRedColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0xffD87E8B);
    } else {
      return const Color(0xffbb3d4f);
    }
  }

  static Color getPinkColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0xffdaa2e9);
    } else {
      // Add a different shade of pink for light mode
      return const Color(0xffdaa2e9);
    }
  }

  static Color getOrangeColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0xffd69d7d);
    } else {
      // Add a different shade of pink for light mode
      return const Color(0xFFBD7145);
    }
  }

  static Color getYellowColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0xfff4e467);
    } else {
      // Add a different shade of pink for light mode
      return const Color(0xffd4af37);
    }
  }

  static Color getBluishPurpleColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0xff6e7dcc);
    } else {
      // Add a different shade of pink for light mode
      return const Color(0xFF5567C0);
    }
  }

  static Color getPurpleColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0xffb682e7);
    } else {
      // Add a different shade of pink for light mode
      return const Color(0xFF9857D4);
    }
  }

  static Color getGoldColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0xFFD4AF37);
    } else {
      // Add a different shade of pink for light mode
      return const Color(0xffFFD700);
    }
  }

  static Color getSilverColor(bool darkMode) {
    if (darkMode == true) {
      return const Color(0xffC0C0C0);
    } else {
      // Add a different shade of pink for light mode
      return const Color(0xFFA6A6A6);
    }
  }

  static Color getBronze(bool darkMode) {
    if (darkMode == true) {
      return const Color(0xffB1560F);
    } else {
      // Add a different shade of pink for light mode
      return const Color(0xFFCD7F32);
    }
  }
}
