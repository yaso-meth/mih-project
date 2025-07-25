import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';

class MihColors {

  static Color getPrimaryColor(BuildContext context) {
    if(MzansiInnovationHub.of(context)!.theme.mode == "Dark"){
      return const Color(0XFF3A4454);
    }else{
      return const Color(0XFFbedcfe);
    }
  }

  static Color getSecondaryColor(BuildContext context) {
    if(MzansiInnovationHub.of(context)!.theme.mode == "Dark"){
      return const Color(0XFFbedcfe);
    }else{
      return const Color(0XFF3A4454);
    }
  }

  static Color getGreenColor(BuildContext context) {
    if(MzansiInnovationHub.of(context)!.theme.mode == "Dark"){
      return const Color(0xff8ae290);
    }else{
      return const Color(0xffB0F2B4);
    }
  }

  static Color getRedColor(BuildContext context) {
    if(MzansiInnovationHub.of(context)!.theme.mode == "Dark"){
      return const Color(0xffD87E8B);
    }else{
      return const Color(0xffbb3d4f);
    }
  }

  static Color getPinkColor(BuildContext context) {
    if(MzansiInnovationHub.of(context)!.theme.mode == "Dark"){
      return const Color(0xffdaa2e9);
    }else{
      // Add a different shade of pink for light mode
      return const Color(0xffdaa2e9);
    }
  }

  static Color getOrangeColor(BuildContext context) {
    if(MzansiInnovationHub.of(context)!.theme.mode == "Dark"){
      return const Color(0xffd69d7d);
    }else{
      // Add a different shade of pink for light mode
      return const Color(0xffd69d7d);
    }
  }

  static Color getYellowColor(BuildContext context) {
    if(MzansiInnovationHub.of(context)!.theme.mode == "Dark"){
      return const Color(0xfff4e467);
    }else{
      // Add a different shade of pink for light mode
      return const Color(0xffd4af37);
    }
}

  static Color getBluishPurpleColor(BuildContext context) {
    if(MzansiInnovationHub.of(context)!.theme.mode == "Dark"){
      return const Color(0xff6e7dcc);
    }else{
      // Add a different shade of pink for light mode
      return const Color(0xff6e7dcc);
    }
}

}