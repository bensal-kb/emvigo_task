import 'package:flutter/material.dart';

abstract class Themes {
  Color get primary => const Color(0xFF006E5C);
  Color get light => const Color(0xFFFFFFFF);
  Color get dark => const Color(0xFF000000);
  Color get transparent => Colors.transparent;

  Color get text => const Color(0xFF000000);
  Color get hint => const Color(0xFF848484);
  Color get border => const Color(0xFFF7F7F7);
  Color get divider => const Color(0xFFEEEEEE);

  Color get background => const Color(0xFFFFFFFF);
  Color get surface => const Color(0xFFF7F7F7);
  Color get card => const Color(0xFFFFFFFF);

  Color get error => const Color(0xFFE53935);
  Color get success => const Color(0xFF43A047);
  Color get warning => const Color(0xFFFB8C00);

  Color get primaryDark => const Color(0xFF00594A);
  Color get primaryLight => const Color(0xFF3D8C7D);
  Color get primaryBackground => const Color(0x1A006E5C);

  Color get textButton => const Color(0xFF767676);
  Color get link => const Color(0xFF767676);

  List<Color> get primaryGradients => [primaryDark, primary];
}

class LightTheme extends Themes {}
