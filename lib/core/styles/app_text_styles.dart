import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle headline({Color? color, double fontSize = 30}) {
    return GoogleFonts.dmSerifDisplay(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: color,
      height: 37 / 30,
      letterSpacing: 0,
    );
  }

  static TextStyle body({
    Color? color,
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: 19 / 13,
      letterSpacing: 0,
      color: color,
    );
  }

  static TextStyle input({Color? color, double fontSize = 14}) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      height: 1,
      letterSpacing: 0,
      color: color,
    );
  }
}
