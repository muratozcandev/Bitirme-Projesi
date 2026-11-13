// Yerel SQLite veritabanı tablolarının oluşturulmasını ve bağlantısını yönetir.

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../seed/seed_data.dart';

/// Cihaz yerelinde çalışan SQLite ilişkisel veritabanı singleton yöneticisi.
/// Kullanıcılar, onaylar, takımlar, kadrolar, randevular, mesajlar ve bildirimler için tabloları kurar.
class AppDatabase {
  static AppDatabase? _instance;
  Database? _db;
  final String? customPath;

  AppDatabase._({this.customPath});

  /// Uygulama genelinde paylaşılan tekil (singleton) veritabanı örneği
  static AppDatabase get instance {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  /// Birim testler için bellekte (in-memory) izole veritabanı oluşturan yapıcı
  factory AppDatabase.forTesting(String dbName) {
    return AppDatabase._(customPath: inMemoryDatabasePath);
  }

  /// Aktif veritabanı bağlantısını döndürür, kapalıysa veya yoksa başlatır
  Future<Database> get database async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

  /// Platform türüne göre (Masaüstü için FFI, Mobil için yerel sqflite) veritabanını ilklendirir
  Future<Database> _initDatabase() async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final String dbPath;
    if (customPath != null) {
      dbPath = customPath!;
    } else {
      final databasesPath = await getDatabasesPath();
      dbPath = p.join(databasesPath, 'hali_saha_7v7.db');
    }

    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        // Tabloları oluştur ve başlangıç futbolcu verilerini tohumla
        await _createTables(db);
        await _seedInitialUsers(db);
      },
      onOpen: (db) async {
        // Veritabanı her açıldığında eksik tohum verileri varsa tamamla
        await _seedInitialUsers(db);
      },
    );

    return db;
  }

  /// SQLite tablolarının DDL (Data Definition Language) şemalarını çalıştırır
  Future<void> _createTables(Database db) async {
    // 1. Kullanıcı hesapları tablosu
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
    ''');

    // 2. Kullanıcı Sözleşmesi ve KVKK onay kayıtları tablosu
    await db.execute('''
      CREATE TABLE consents (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        documentType TEXT NOT NULL,
        documentVersion TEXT NOT NULL,
        accepted INTEGER NOT NULL,
        acceptedAt TEXT NOT NULL
      )
    ''');

    // 3. 7v7 Maç takımları tablosu
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
    ''');

    // 4. Takım kadro mevkileri ve oyuncu eşleşmeleri tablosu
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
    ''');

    // 5. Maç organizasyon detayları tablosu
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
    ''');

    // 6. Oyuncu mevki davetleri tablosu
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
    ''');

    // 7. Takım içi anlık sohbet mesajları tablosu
    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        teamId TEXT NOT NULL,
        senderId TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // 8. Kullanıcı bildirimleri tablosu
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
    ''');

    // 9. Kullanıcının kendi listesinden sildiği maç randevuları tablosu
    await db.execute('''
      CREATE TABLE dismissed_appointments (
        userId TEXT NOT NULL,
        teamId TEXT NOT NULL,
        dismissedAt TEXT NOT NULL,
        PRIMARY KEY (userId, teamId)
      )
    ''');

    // 10. Önceden yüklenen halı saha mekan önbelleği tablosu
    await db.execute('''
      CREATE TABLE venues_cache (
        province TEXT NOT NULL,
        district TEXT NOT NULL,
        venueName TEXT NOT NULL,
        PRIMARY KEY (province, district, venueName)
      )
    ''');
  }

  /// Başlangıçta test için gerekli 10 örnek futbolcu kullanıcısını SQLite tablosuna ekler
  Future<void> _seedInitialUsers(Database db) async {
    final batch = db.batch();
    for (final user in SeedData.predefinedUsers) {
      batch.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    await batch.commit(noResult: true);
  }

  /// Veritabanı bağlantısını kapatır ve bellek referansını temizler
  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
      _db = null;
    }
  }
}
