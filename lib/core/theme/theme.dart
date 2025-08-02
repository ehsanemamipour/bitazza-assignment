import 'package:flutter/material.dart';

extension CustomeColor on ThemeData {
  Color get black => const Color(0xFF000000);
  Color get white => const Color(0xFFFFFFFF);
  Color get purple => const Color(0xFF673AB7);
  Color get gray500 => const Color(0xFF9E9E9E);
  Color get gray700 => const Color(0xFF616161);
  Color get gray800 => const Color(0xFF424242);
  Color get gray900 => const Color(0xFF212121);
  Color get white70 => const Color(0xB3FFFFFF);
  Color get red => const Color(0xFFFF5252);
}

extension CustomeTextStyle on ThemeData {
  TextStyle get medium14 => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: white,
      );

  TextStyle get medium16 => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: white,
      );

  TextStyle get medium20 => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: white,
      );

  TextStyle get bold16 => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: white,
      );
  TextStyle get bold24 => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: white,
      );
}
