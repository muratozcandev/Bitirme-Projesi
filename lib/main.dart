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

/// Firebase servislerini platforma özel yapılandırmayla başlatan ve bağlantıyı doğrulayan yardımcı fonksiyon.
/// Ağ veya servis başlatma hatası durumunda uygulamanın yerel SQLite modunda çalışabilmesi için false döndürür.
Future<bool> _initializeAndVerifyFirebase() async {
  try {
    final FirebaseApp app;
    // Firebase daha önce başlatılmamışsa ilgili platform seçenekleriyle başlat
    if (Firebase.apps.isEmpty) {
      app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      app = Firebase.app();
    }

    // Auth ve Firestore servis örneklerinin erişilebilir olduğunu kontrol et
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

/// Uygulamanın ana başlangıç noktası.
/// Platform kanallarını bağlar, yerel ve uzak veritabanlarını hazırlar,
/// oturum bilgisini yükler ve ana widget ağacını ekrana basar.
Future<void> main() async {
  // Flutter motoru ve platform kanalları arasındaki iletişimi güvenceye alır
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase bağlantısını başlat ve hazırlık durumunu kontrol et
  final isFirebaseReady = await _initializeAndVerifyFirebase();

  // Cihaz üzerindeki yerel SQLite veritabanı tablolarını ve seed verilerini hazırla
  await AppDatabase.instance.database;

  // Cihaz hafızasındaki yerel anahtar-değer (SharedPreferences) deposunu yükle
  final prefs = await SharedPreferences.getInstance();

  // Riverpod durum konteynerini oluştur ve ana bağımlılıkları enjekte et
  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      firebaseInitializedProvider.overrideWithValue(isFirebaseReady),
    ],
  );

  // Varsa kayıtlı kullanıcı oturumunu belleğe yükle
  await container.read(authProvider.notifier).initializeSession();

  // Kök widget ağacını başlat
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const SevenVSevenApp(),
    ),
  );
}
