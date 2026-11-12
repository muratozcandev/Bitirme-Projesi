import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../seed/seed_data.dart';

class AppDatabase {
  static AppDatabase? _instance;
  Database? _db;
  final String? customPath;

  AppDatabase._({this.customPath});

  static AppDatabase get instance {
    _instance ??= AppDatabase._();
    return _instance!;
  }

  /// Birim ve entegrasyon testlerinde bağımsız bellek içi veritabanı oluşturmak için
  factory AppDatabase.forTesting(String dbName) {
    return AppDatabase._(customPath: inMemoryDatabasePath);
  }

  Future<Database> get database async {
    if (_db != null && _db!.isOpen) {
      return _db!;
    }
    _db = await _initDatabase();
    return _db!;
  }

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
        await _createTables(db);
        await _seedInitialUsers(db);
      },
      onOpen: (db) async {
        await _seedInitialUsers(db);
      },
    );

    return db;
  }

  Future<void> _createTables(Database db) async {
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

    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        teamId TEXT NOT NULL,
        senderId TEXT NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

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

    await db.execute('''
      CREATE TABLE dismissed_appointments (
        userId TEXT NOT NULL,
        teamId TEXT NOT NULL,
        dismissedAt TEXT NOT NULL,
        PRIMARY KEY (userId, teamId)
      )
    ''');

    await db.execute('''
      CREATE TABLE venues_cache (
        province TEXT NOT NULL,
        district TEXT NOT NULL,
        venueName TEXT NOT NULL,
        PRIMARY KEY (province, district, venueName)
      )
    ''');
  }

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

  Future<void> close() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
      _db = null;
    }
  }
}
