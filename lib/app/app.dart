// Uygulamanın ana MaterialApp yapılandırmasını, tema ve dil ayarlarını tanımlar.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../shared/providers/app_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// 7v7 uygulamasının ana görsel kökü.
/// Tema modu değişikliklerini (Açık/Koyu) ve GoRouter yönlendiricisini dinler;
/// Türkçe dil desteği ve Cupertino/Material yerelleştirmesini sağlar.
class SevenVSevenApp extends ConsumerWidget {
  const SevenVSevenApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sayfa rotalarını ve giriş kontrollerini yöneten GoRouter örneğini izle
    final router = ref.watch(routerProvider);

    // Aktif kullanıcının açık/koyu tema tercihini izle
    final themeMode = ref.watch(themeModeProvider);

    // Ana uygulama çatısı
    return MaterialApp.router(
      title: '7v7',
      debugShowCheckedModeBanner: false,

      // Açık ve koyu tema stilleri
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // GoRouter yönlendirme konfigürasyonu
      routerConfig: router,

      // Yerelleştirme ve çoklu dil delegeleri (Türkçe öncelikli)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('tr', 'TR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('tr', 'TR'),
    );
  }
}
