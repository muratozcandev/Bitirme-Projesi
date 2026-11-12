import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

ThemeData buildDarkTheme() { // İlgili kod satırını ve işlemi yürütür
  const colorScheme = ColorScheme.dark( // Sabit/final değişken veya nesne tanımını başlatır
    primary: AppColors.pitchGreen, // primary özelliğini yapılandırır
    onPrimary: Color(0xFF052E16), // onPrimary özelliğini yapılandırır
    primaryContainer: Color(0xFF14532D), // primaryContainer özelliğini yapılandırır
    onPrimaryContainer: Color(0xFFDCFCE7), // onPrimaryContainer özelliğini yapılandırır
    secondary: AppColors.pitchLightGreen, // secondary özelliğini yapılandırır
    onSecondary: Color(0xFF052E16), // onSecondary özelliğini yapılandırır
    secondaryContainer: Color(0xFF1E3A2B), // secondaryContainer özelliğini yapılandırır
    onSecondaryContainer: Color(0xFFDCFCE7), // onSecondaryContainer özelliğini yapılandırır
    tertiary: Color(0xFF60A5FA), // tertiary özelliğini yapılandırır
    error: Color(0xFFF87171), // error özelliğini yapılandırır
    onError: Color(0xFF450A0A), // onError özelliğini yapılandırır
    surface: AppColors.darkSurface, // surface özelliğini yapılandırır
    onSurface: Color(0xFFF1F5F9), // onSurface özelliğini yapılandırır
    surfaceContainerHighest: AppColors.darkCard, // surfaceContainerHighest özelliğini yapılandırır
    onSurfaceVariant: Color(0xFF94A3B8), // onSurfaceVariant özelliğini yapılandırır
    outline: Color(0xFF2D4A3B), // outline özelliğini yapılandırır
  ); // Açık olan kod/bileşen bloğunu kapatır

  return ThemeData( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    useMaterial3: true, // useMaterial3 özelliğini yapılandırır
    brightness: Brightness.dark, // brightness özelliğini yapılandırır
    colorScheme: colorScheme, // colorScheme özelliğini yapılandırır
    scaffoldBackgroundColor: AppColors.darkBackground, // scaffoldBackgroundColor özelliğini yapılandırır
    appBarTheme: const AppBarTheme( // İlgili kod satırını ve işlemi yürütür
      backgroundColor: AppColors.darkSurface, // backgroundColor özelliğini yapılandırır
      foregroundColor: Colors.white, // foregroundColor özelliğini yapılandırır
      elevation: 0, // elevation özelliğini yapılandırır
      centerTitle: false, // centerTitle özelliğini yapılandırır
      titleTextStyle: TextStyle( // İlgili kod satırını ve işlemi yürütür
        color: Colors.white, // color özelliğini yapılandırır
        fontSize: 20, // fontSize özelliğini yapılandırır
        fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
        letterSpacing: 0.3, // letterSpacing özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ), // Açık olan kod/bileşen bloğunu kapatır
    cardTheme: CardThemeData( // İlgili kod satırını ve işlemi yürütür
      color: AppColors.darkSurface, // color özelliğini yapılandırır
      elevation: 2, // elevation özelliğini yapılandırır
      shadowColor: Colors.black.withValues(alpha: 0.4), // shadowColor özelliğini yapılandırır
      shape: RoundedRectangleBorder( // İlgili kod satırını ve işlemi yürütür
        borderRadius: BorderRadius.circular(16), // borderRadius özelliğini yapılandırır
        side: const BorderSide(color: Color(0xFF233B2E), width: 1), // side özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0), // margin özelliğini yapılandırır
    ), // Açık olan kod/bileşen bloğunu kapatır
    elevatedButtonTheme: ElevatedButtonThemeData( // Tıklanabilir aksiyon butonunu oluşturur
      style: ElevatedButton.styleFrom( // Tıklanabilir aksiyon butonunu oluşturur
        backgroundColor: AppColors.pitchGreen, // backgroundColor özelliğini yapılandırır
        foregroundColor: const Color(0xFF052E16), // foregroundColor özelliğini yapılandırır
        disabledBackgroundColor: const Color(0xFF1E293B), // disabledBackgroundColor özelliğini yapılandırır
        disabledForegroundColor: const Color(0xFF64748B), // disabledForegroundColor özelliğini yapılandırır
        elevation: 0, // elevation özelliğini yapılandırır
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14), // padding özelliğini yapılandırır
        shape: RoundedRectangleBorder( // İlgili kod satırını ve işlemi yürütür
          borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        textStyle: const TextStyle( // İlgili kod satırını ve işlemi yürütür
          fontSize: 15, // fontSize özelliğini yapılandırır
          fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ), // Açık olan kod/bileşen bloğunu kapatır
    outlinedButtonTheme: OutlinedButtonThemeData( // Tıklanabilir aksiyon butonunu oluşturur
      style: OutlinedButton.styleFrom( // Tıklanabilir aksiyon butonunu oluşturur
        foregroundColor: AppColors.pitchGreen, // foregroundColor özelliğini yapılandırır
        side: const BorderSide(color: AppColors.pitchGreen, width: 1.4), // side özelliğini yapılandırır
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13), // padding özelliğini yapılandırır
        shape: RoundedRectangleBorder( // İlgili kod satırını ve işlemi yürütür
          borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        textStyle: const TextStyle( // İlgili kod satırını ve işlemi yürütür
          fontSize: 14, // fontSize özelliğini yapılandırır
          fontWeight: FontWeight.w600, // fontWeight özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ), // Açık olan kod/bileşen bloğunu kapatır
    inputDecorationTheme: InputDecorationTheme( // İlgili kod satırını ve işlemi yürütür
      filled: true, // filled özelliğini yapılandırır
      fillColor: AppColors.darkCard, // fillColor özelliğini yapılandırır
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15), // contentPadding özelliğini yapılandırır
      border: OutlineInputBorder( // İlgili kod satırını ve işlemi yürütür
        borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
        borderSide: const BorderSide(color: Color(0xFF2D4A3B)), // borderSide özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      enabledBorder: OutlineInputBorder( // İlgili kod satırını ve işlemi yürütür
        borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
        borderSide: const BorderSide(color: Color(0xFF2D4A3B)), // borderSide özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      focusedBorder: OutlineInputBorder( // İlgili kod satırını ve işlemi yürütür
        borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
        borderSide: const BorderSide(color: AppColors.pitchGreen, width: 2), // borderSide özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      errorBorder: OutlineInputBorder( // İlgili kod satırını ve işlemi yürütür
        borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
        borderSide: const BorderSide(color: Color(0xFFF87171), width: 1.5), // borderSide özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      focusedErrorBorder: OutlineInputBorder( // İlgili kod satırını ve işlemi yürütür
        borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
        borderSide: const BorderSide(color: Color(0xFFF87171), width: 2), // borderSide özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ), // Açık olan kod/bileşen bloğunu kapatır
    navigationBarTheme: NavigationBarThemeData( // İlgili kod satırını ve işlemi yürütür
      backgroundColor: AppColors.darkSurface, // backgroundColor özelliğini yapılandırır
      indicatorColor: AppColors.pitchGreen.withValues(alpha: 0.22), // indicatorColor özelliğini yapılandırır
      labelTextStyle: WidgetStateProperty.resolveWith((states) { // labelTextStyle özelliğini yapılandırır
        if (states.contains(WidgetState.selected)) { // Koşulun sağlanıp sağlanmadığını kontrol eder
          return const TextStyle( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
            fontSize: 12, // fontSize özelliğini yapılandırır
            fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
            color: AppColors.pitchGreen, // color özelliğini yapılandırır
          ); // Açık olan kod/bileşen bloğunu kapatır
        } // Açık olan kod/bileşen bloğunu kapatır
        return const TextStyle( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          fontSize: 12, // fontSize özelliğini yapılandırır
          fontWeight: FontWeight.w500, // fontWeight özelliğini yapılandırır
          color: Color(0xFF94A3B8), // color özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      }), // İlgili kod satırını ve işlemi yürütür
      iconTheme: WidgetStateProperty.resolveWith((states) { // iconTheme özelliğini yapılandırır
        if (states.contains(WidgetState.selected)) { // Koşulun sağlanıp sağlanmadığını kontrol eder
          return const IconThemeData(color: AppColors.pitchGreen, size: 24); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
        } // Açık olan kod/bileşen bloğunu kapatır
        return const IconThemeData(color: Color(0xFF94A3B8), size: 23); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      }), // İlgili kod satırını ve işlemi yürütür
    ), // Açık olan kod/bileşen bloğunu kapatır
    snackBarTheme: SnackBarThemeData( // İlgili kod satırını ve işlemi yürütür
      behavior: SnackBarBehavior.floating, // behavior özelliğini yapılandırır
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // shape özelliğini yapılandırır
    ), // Açık olan kod/bileşen bloğunu kapatır
  ); // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

