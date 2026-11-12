import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'data/database/app_database.dart';
import 'shared/providers/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Yerel SQLite veritabanını ve 10 test hesabını hazırla
  await AppDatabase.instance.database;
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );

  // Daha önce açık olan oturumu yükle
  await container.read(authProvider.notifier).initializeSession();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SevenVSevenApp(),
    ),
  );
}
