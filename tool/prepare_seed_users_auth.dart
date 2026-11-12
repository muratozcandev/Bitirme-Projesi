import 'dart:convert';
import 'dart:io';
import 'package:hali_saha_7v7/core/utils/firebase_auth_import_preparer.dart';

void main(List<String> args) {
  final verified = FirebaseAuthImportPreparer.verifyAllTenSeedUsers();
  stdout.writeln(
    '✅ 10 hazır test hesabının SHA-256 (Hex -> Base64) ve SALT_FIRST (rounds=1) doğrulaması başarılı.',
  );

  for (final item in verified) {
    stdout.writeln(
      ' - ${item['localId']} | ${item['email']} | '
      'passwordHash(B64)=${item['passwordHashBase64']} | '
      'salt(B64)=${item['saltBase64']}',
    );
  }

  final payload = FirebaseAuthImportPreparer.buildImportJsonPayload();
  final outputFile = File('seed_users_auth.json');
  outputFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(payload),
  );
  stdout.writeln(
    '\n✅ "${outputFile.path}" dosyası başarıyla oluşturuldu (.gitignore korumalı).',
  );

  final backupFile = File('existing_firebase_users_backup.json');
  if (backupFile.existsSync()) {
    final raw = jsonDecode(backupFile.readAsStringSync()) as Map<String, dynamic>;
    final existingList = (raw['users'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    final collisions =
        FirebaseAuthImportPreparer.checkCollisionsWithExistingUsers(existingList);
    if (collisions.isEmpty) {
      stdout.writeln(
        '✅ Mevcut ${existingList.length} Firebase Auth kullanıcısı ile UID veya e-posta çakışması YOK.',
      );
    } else {
      stderr.writeln('⚠️ ÇAKIŞMA TESPİT EDİLDİ:');
      for (final c in collisions) {
        stderr.writeln('   * $c');
      }
      exitCode = 1;
    }
  } else {
    stdout.writeln(
      'ℹ️ "existing_firebase_users_backup.json" henüz oluşturulmadı. '
      'İçe aktarım öncesinde `firebase auth:export existing_firebase_users_backup.json --format=json --project=v7-app-341ae` komutuyla yedek alınabilir.',
    );
  }
}

