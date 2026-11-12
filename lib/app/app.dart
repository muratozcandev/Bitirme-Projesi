import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_localizations/flutter_localizations.dart'; // Çoklu dil ve Türkçe yerelleştirme desteğini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import '../shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import 'router.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import 'theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class SevenVSevenApp extends ConsumerWidget { // Riverpod sağlayıcılarını dinleyebilen SevenVSevenApp görsel bileşenini tanımlar
  const SevenVSevenApp({super.key}); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context, WidgetRef ref) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final router = ref.watch(routerProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final themeMode = ref.watch(themeModeProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer

    return MaterialApp.router( // GoRouter ve tema destekli ana Material uygulama kökünü oluşturur
      title: '7v7', // title özelliğini yapılandırır
      debugShowCheckedModeBanner: false, // debugShowCheckedModeBanner özelliğini yapılandırır
      theme: AppTheme.light, // theme özelliğini yapılandırır
      darkTheme: AppTheme.dark, // darkTheme özelliğini yapılandırır
      themeMode: themeMode, // themeMode özelliğini yapılandırır
      routerConfig: router, // routerConfig özelliğini yapılandırır
      localizationsDelegates: const [ // İlgili kod satırını ve işlemi yürütür
        GlobalMaterialLocalizations.delegate, // İlgili kod satırını ve işlemi yürütür
        GlobalWidgetsLocalizations.delegate, // İlgili kod satırını ve işlemi yürütür
        GlobalCupertinoLocalizations.delegate, // İlgili kod satırını ve işlemi yürütür
      ], // Açık olan kod/bileşen bloğunu kapatır
      supportedLocales: const [ // İlgili kod satırını ve işlemi yürütür
        Locale('tr', 'TR'), // İlgili kod satırını ve işlemi yürütür
        Locale('en', 'US'), // İlgili kod satırını ve işlemi yürütür
      ], // Açık olan kod/bileşen bloğunu kapatır
      locale: const Locale('tr', 'TR'), // locale özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

