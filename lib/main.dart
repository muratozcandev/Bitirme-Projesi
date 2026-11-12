// Uygulamanın giriş noktasıdır; Firebase, yerel veritabanı ve durum yönetimini başlatır.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'data/database/app_database.dart';
import 'firebase_options.dart';
import 'shared/providers/app_providers.dart';

Future<bool> _initializeAndVerifyFirebase() async {
  try {
    final FirebaseApp app;
    if (Firebase.apps.isEmpty) {
      app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      app = Firebase.app();
    }

    final auth = FirebaseAuth.instanceFor(app: app);
    final firestore = FirebaseFirestore.instanceFor(app: app);

    debugPrint(
      '[Firebase] Bağlantı doğrulandı — Proje ID: ${app.options.projectId}, '
      'Uygulama: ${app.name}, Auth: ${auth.app.name}, Firestore: ${firestore.app.name}',
    );
    return true;
  } catch (e) {
    debugPrint('[Firebase] Başlatma uyarısı (yerel mod devam ediyor): $e');
    return false;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isFirebaseReady = await _initializeAndVerifyFirebase();

  await AppDatabase.instance.database;

  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      firebaseInitializedProvider.overrideWithValue(isFirebaseReady),
    ],
  );

  await container.read(authProvider.notifier).initializeSession();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SevenVSevenApp(),
    ),
  );
}
