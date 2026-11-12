import 'dart:io'; // İşletim sistemi ve dosya işlemleri kütüphanesini içe aktarır
import 'package:flutter/foundation.dart'; // Flutter temel platform ve debug yardımcılarını içe aktarır
import 'package:path/path.dart' as p; // İlgili proje modülünü veya bağımlılığını içe aktarır
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // SQLite yerel veritabanı sürücüsünü içe aktarır
import '../seed/seed_data.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class AppDatabase { // AppDatabase veri/yardımcı sınıfını tanımlar
  static AppDatabase? _instance; // İlgili kod satırını ve işlemi yürütür
  Database? _db; // İlgili kod satırını ve işlemi yürütür
  final String? customPath; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  AppDatabase._({this.customPath}); // İlgili kod satırını ve işlemi yürütür

  static AppDatabase get instance { // İlgili kod satırını ve işlemi yürütür
    _instance ??= AppDatabase._(); // İlgili kod satırını ve işlemi yürütür
    return _instance!; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  /// Birim ve entegrasyon testlerinde bağımsız bellek içi veritabanı oluşturmak için
  factory AppDatabase.forTesting(String dbName) { // İlgili kod satırını ve işlemi yürütür
    return AppDatabase._(customPath: inMemoryDatabasePath); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<Database> get database async { // İlgili kod satırını ve işlemi yürütür
    if (_db != null && _db!.isOpen) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return _db!; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    _db = await _initDatabase(); // İlgili kod satırını ve işlemi yürütür
    return _db!; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<Database> _initDatabase() async { // İlgili kod satırını ve işlemi yürütür
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      sqfliteFfiInit(); // İlgili kod satırını ve işlemi yürütür
      databaseFactory = databaseFactoryFfi; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    final String dbPath; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (customPath != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      dbPath = customPath!; // İlgili kod satırını ve işlemi yürütür
    } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
      final databasesPath = await getDatabasesPath(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      dbPath = p.join(databasesPath, 'hali_saha_7v7.db'); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    final db = await openDatabase( // SQLite veritabanı dosyasını açar ve ilk kurulum kancalarını tanımlar
      dbPath, // İlgili kod satırını ve işlemi yürütür
      version: 1, // version özelliğini yapılandırır
      onCreate: (db, version) async { // onCreate özelliğini yapılandırır
        await _createTables(db); // Asenkron işlemin tamamlanmasını bekler
        await _seedInitialUsers(db); // Asenkron işlemin tamamlanmasını bekler
      }, // Açık olan kod/bileşen bloğunu kapatır
      onOpen: (db) async { // onOpen özelliğini yapılandırır
        await _seedInitialUsers(db); // Asenkron işlemin tamamlanmasını bekler
      }, // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır

    return db; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _createTables(Database db) async { // İlgili kod satırını ve işlemi yürütür
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL UNIQUE,
        passwordHash TEXT NOT NULL,
        profileImage TEXT,
        themeMode TEXT NOT NULL DEFAULT 'light',
        createdAt TEXT NOT NULL
      )
    '''); // Çok satırlı metin/SQL bloğunu kapatır

    await db.execute('''
      CREATE TABLE consents (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        documentType TEXT NOT NULL,
        documentVersion TEXT NOT NULL,
        accepted INTEGER NOT NULL,
        acceptedAt TEXT NOT NULL
      )
    '''); // Çok satırlı metin/SQL bloğunu kapatır

    await db.execute('''
      CREATE TABLE teams (
        id TEXT PRIMARY KEY,
        captainId TEXT NOT NULL,
        formation TEXT NOT NULL,
        province TEXT NOT NULL,
        district TEXT NOT NULL,
        venueName TEXT NOT NULL,
        matchDate TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'active'
      )
    '''); // Çok satırlı metin/SQL bloğunu kapatır

    await db.execute('''
      CREATE TABLE team_members (
        id TEXT PRIMARY KEY,
        teamId TEXT NOT NULL,
        userId TEXT,
        position TEXT NOT NULL,
        displayName TEXT NOT NULL,
        role TEXT NOT NULL,
        joinedAt TEXT NOT NULL
      )
    '''); // Çok satırlı metin/SQL bloğunu kapatır

    await db.execute('''
      CREATE TABLE matches (
        id TEXT PRIMARY KEY,
        teamId TEXT NOT NULL,
        venueName TEXT NOT NULL,
        province TEXT NOT NULL,
        district TEXT NOT NULL,
        matchDate TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL
      )
    '''); // Çok satırlı metin/SQL bloğunu kapatır

    await db.execute('''
      CREATE TABLE invitations (
        id TEXT PRIMARY KEY,
        teamId TEXT NOT NULL,
        senderId TEXT NOT NULL,
        receiverId TEXT NOT NULL,
        position TEXT NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        respondedAt TEXT
      )
    '''); // Çok satırlı metin/SQL bloğunu kapatır

    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        teamId TEXT NOT NULL,
        senderId TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    '''); // Çok satırlı metin/SQL bloğunu kapatır

    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        receiverId TEXT NOT NULL,
        senderId TEXT NOT NULL,
        type TEXT NOT NULL,
        relatedTeamId TEXT,
        relatedInvitationId TEXT,
        title TEXT NOT NULL,
        body TEXT NOT NULL,
        isRead INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    '''); // Çok satırlı metin/SQL bloğunu kapatır

    await db.execute('''
      CREATE TABLE dismissed_appointments (
        userId TEXT NOT NULL,
        teamId TEXT NOT NULL,
        dismissedAt TEXT NOT NULL,
        PRIMARY KEY (userId, teamId)
      )
    '''); // Çok satırlı metin/SQL bloğunu kapatır

    await db.execute('''
      CREATE TABLE venues_cache (
        province TEXT NOT NULL,
        district TEXT NOT NULL,
        venueName TEXT NOT NULL,
        PRIMARY KEY (province, district, venueName)
      )
    '''); // Çok satırlı metin/SQL bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _seedInitialUsers(Database db) async { // İlgili kod satırını ve işlemi yürütür
    final batch = db.batch(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (final user in SeedData.predefinedUsers) { // Koleksiyon veya aralık üzerinde döngü başlatır
      batch.insert( // SQLite veritabanı tablosuna yeni kayıt ekler
        'users', // İlgili kod satırını ve işlemi yürütür
        user.toMap(), // İlgili kod satırını ve işlemi yürütür
        conflictAlgorithm: ConflictAlgorithm.ignore, // conflictAlgorithm özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    await batch.commit(noResult: true); // Asenkron işlemin tamamlanmasını bekler
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> close() async { // İlgili kod satırını ve işlemi yürütür
    if (_db != null && _db!.isOpen) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      await _db!.close(); // Asenkron işlemin tamamlanmasını bekler
      _db = null; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
