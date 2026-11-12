import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'dark_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import 'light_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class AppColors { // AppColors veri/yardımcı sınıfını tanımlar
  AppColors._(); // İlgili kod satırını ve işlemi yürütür

  // Primary & Secondary Football Greens
  static const Color primaryDarkGreen = Color(0xFF0D3B26); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color primaryGreen = Color(0xFF14532D); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color pitchGreen = Color(0xFF1DB954); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color pitchLightGreen = Color(0xFF2ECC71); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color pitchGrassDark = Color(0xFF155E34); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color pitchGrassLight = Color(0xFF1E7A44); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color goldAccent = Color(0xFFEAB308); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  // Backgrounds & Surfaces
  static const Color lightBackground = Color(0xFFF3F6F4); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color lightSurface = Color(0xFFFFFFFF); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color darkBackground = Color(0xFF0B1410); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color darkSurface = Color(0xFF14241C); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color darkCard = Color(0xFF1B3025); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  // Semantic Colors
  static const Color success = Color(0xFF16A34A); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color error = Color(0xFFDC2626); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color info = Color(0xFF2563EB); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const Color warning = Color(0xFFD97706); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
} // Açık olan kod/bileşen bloğunu kapatır

class AppTheme { // AppTheme veri/yardımcı sınıfını tanımlar
  AppTheme._(); // İlgili kod satırını ve işlemi yürütür

  static ThemeData get light => buildLightTheme(); // İlgili kod satırını ve işlemi yürütür
  static ThemeData get dark => buildDarkTheme(); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

