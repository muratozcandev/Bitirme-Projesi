import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hali_saha_7v7/app/app.dart';
import 'package:hali_saha_7v7/features/team_creation/presentation/team_creation_screen.dart';
import 'package:hali_saha_7v7/shared/providers/app_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
      '7v7 Giriş ekranı bileşenleri ve Hesap Oluştur navigasyonu çalışmalı',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const SevenVSevenApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Giriş ekranı uygulama adı ve bileşenleri
    expect(find.text('7v7'), findsWidgets);
    expect(find.byKey(const Key('login_identifier_field')), findsOneWidget);
    expect(find.byKey(const Key('login_password_field')), findsOneWidget);
    expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
    expect(find.byKey(const Key('go_to_register_button')), findsOneWidget);

    // Hesap oluştur ekranına geçiş
    final registerBtn = find.byKey(const Key('go_to_register_button'));
    await tester.ensureVisible(registerBtn);
    await tester.pumpAndSettle();
    await tester.tap(registerBtn);
    await tester.pumpAndSettle();

    expect(find.text('Yeni Oyuncu Kaydı'), findsOneWidget);
    expect(find.byKey(const Key('checkbox_user_agreement')), findsOneWidget);
    expect(find.byKey(const Key('checkbox_kvkk')), findsOneWidget);
  });

  testWidgets(
      'Takım Kur ekranında Diziliş seçim penceresi taşma (overflow) olmadan açılmalı',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MaterialApp(
          home: TeamCreationScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final formationBtn = find.byKey(const Key('btn_select_formation'));
    expect(formationBtn, findsOneWidget);

    await tester.tap(formationBtn);
    await tester.pumpAndSettle();

    expect(find.text('7v7 Saha Dizilişi Seçiniz'), findsOneWidget);
    expect(find.byKey(const Key('formation_option_3-3')), findsOneWidget);
    expect(find.byKey(const Key('formation_option_2-2-2')), findsOneWidget);
  });
}
