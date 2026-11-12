import 'package:cloud_firestore/cloud_firestore.dart'; // Cloud Firestore bulut veritabanı paketini içe aktarır
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication kimlik doğrulama paketini içe aktarır
import 'package:firebase_core/firebase_core.dart'; // Firebase temel başlatma (core) paketini içe aktarır
import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import 'package:shared_preferences/shared_preferences.dart'; // Yerel anahtar-değer (SharedPreferences) depolama paketini içe aktarır

import 'app/app.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import 'data/database/app_database.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import 'firebase_options.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import 'shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

Future<bool> _initializeAndVerifyFirebase() async { // İlgili kod satırını ve işlemi yürütür
  try { // Hata yakalama (try) bloğunu başlatır
    final FirebaseApp app; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (Firebase.apps.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      app = await Firebase.initializeApp( // Platforma özel ayarlarla Firebase bağlantısını başlatır
        options: DefaultFirebaseOptions.currentPlatform, // options özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
      app = Firebase.app(); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    // Firebase Auth ve Cloud Firestore örneklerinin bağlı olduğunu doğrula
    final auth = FirebaseAuth.instanceFor(app: app); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final firestore = FirebaseFirestore.instanceFor(app: app); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    debugPrint( // İlgili kod satırını ve işlemi yürütür
      '[Firebase] Bağlantı doğrulandı — Proje ID: ${app.options.projectId}, ' // İlgili kod satırını ve işlemi yürütür
      'Uygulama: ${app.name}, Auth: ${auth.app.name}, Firestore: ${firestore.app.name}', // 'Uygulama özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    return true; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
    debugPrint('[Firebase] Başlatma uyarısı (yerel mod devam ediyor): $e'); // İlgili kod satırını ve işlemi yürütür
    return false; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

Future<void> main() async { // İlgili kod satırını ve işlemi yürütür
  WidgetsFlutterBinding.ensureInitialized(); // İlgili kod satırını ve işlemi yürütür

  // Firebase bağlantısını başlat ve doğrula
  final isFirebaseReady = await _initializeAndVerifyFirebase(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  // Mevcut yerel SQLite veritabanını hazırla
  await AppDatabase.instance.database; // Asenkron işlemin tamamlanmasını bekler

  final prefs = await SharedPreferences.getInstance(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  final container = ProviderContainer( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
    overrides: [ // İlgili kod satırını ve işlemi yürütür
      sharedPreferencesProvider.overrideWithValue(prefs), // İlgili kod satırını ve işlemi yürütür
      firebaseInitializedProvider.overrideWithValue(isFirebaseReady), // İlgili kod satırını ve işlemi yürütür
    ], // Açık olan kod/bileşen bloğunu kapatır
  ); // Açık olan kod/bileşen bloğunu kapatır

  // Mevcut oturum sistemini koru
  await container.read(authProvider.notifier).initializeSession(); // Asenkron işlemin tamamlanmasını bekler

  runApp( // İlgili kod satırını ve işlemi yürütür
    UncontrolledProviderScope( // İlgili kod satırını ve işlemi yürütür
      container: container, // container özelliğini yapılandırır
      child: const SevenVSevenApp(), // child özelliğini yapılandırır
    ), // Açık olan kod/bileşen bloğunu kapatır
  ); // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
