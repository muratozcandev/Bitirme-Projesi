// Uygulamada kullanılan ortak renk paletini ve tema erişim sınıfını tanımlar.

import 'package:flutter/material.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class AppColors {
  AppColors._();

  static const Color primaryDarkGreen = Color(0xFF0D3B26);
  static const Color primaryGreen = Color(0xFF14532D);
  static const Color pitchGreen = Color(0xFF1DB954);
  static const Color pitchLightGreen = Color(0xFF2ECC71);
  static const Color pitchGrassDark = Color(0xFF155E34);
  static const Color pitchGrassLight = Color(0xFF1E7A44);
  static const Color goldAccent = Color(0xFFEAB308);

  static const Color lightBackground = Color(0xFFF3F6F4);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF0B1410);
  static const Color darkSurface = Color(0xFF14241C);
  static const Color darkCard = Color(0xFF1B3025);

  static const Color success = Color(0xFF16A34A);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);
  static const Color warning = Color(0xFFD97706);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => buildLightTheme();
  static ThemeData get dark => buildDarkTheme();
}
