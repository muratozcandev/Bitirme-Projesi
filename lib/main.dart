
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'app/app.dart';
import 'data/database/app_database.dart';
import 'shared/providers/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase bağlantısını başlat
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Mevcut yerel SQLite veritabanını hazırla
  await AppDatabase.instance.database;

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );

  // Mevcut oturum sistemini koru
  await container.read(authProvider.notifier).initializeSession();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SevenVSevenApp(),
    ),
  );
}
