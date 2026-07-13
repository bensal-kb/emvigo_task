import 'package:flutter/material.dart';
import 'package:emvigo_test/core/styles/theme.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  Themes currentTheme = LightTheme();

  ThemeData getTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: currentTheme.primary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: currentTheme.primary,
      ),
      primaryColor: currentTheme.primary,
      colorScheme: ColorScheme.light(
        primary: currentTheme.primary,
        surface: currentTheme.surface,
        error: currentTheme.error,
      ),
      scaffoldBackgroundColor: currentTheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: currentTheme.surface,
        foregroundColor: currentTheme.text,
        elevation: 0,
        centerTitle: true,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
