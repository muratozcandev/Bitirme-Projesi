// Hazır test kullanıcılarının Firebase Authentication sistemine aktarımı için veri hazırlar.

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'password_hasher.dart';

/// Test amaçlı tanımlanan futbolcu profillerinin kimlik ve parola özelliklerini temsil eden model.
class SeedAuthUserSpec {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String plainPasswordForVerification;
  final String passwordHashHex;
  final DateTime createdAt;

  const SeedAuthUserSpec({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.plainPasswordForVerification,
    required this.passwordHashHex,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName'.trim();
}

/// Firebase CLI `auth:import` aracı ile sisteme aktarılacak 10 hazır test kullanıcısının
/// parola özetlerini, Base64 dönüşümlerini ve çakışma kontrollerini gerçekleştiren yardımcı sınıf.
class FirebaseAuthImportPreparer {
  FirebaseAuthImportPreparer._();

  // Test hesapları için standart başlangıç oluşturulma tarihi
  static final DateTime _seedTime = DateTime.utc(2026, 1, 1, 12, 0);

  // Parola tuzlama sabit değeri
  static const String effectiveSaltRaw = '7v7_hali_saha_secure_salt_v1:';

  /// Firebase Authentication tarafından kabul edilen Base64 formatındaki tuz değeri
  static String get effectiveSaltBase64 =>
      base64Encode(utf8.encode(effectiveSaltRaw));

  /// Sistemde önceden tanımlı 10 efsanevi futbolcu test hesabının listesi
  static List<SeedAuthUserSpec> get seedUserSpecs => [
        SeedAuthUserSpec(
          id: 'seed_user_1',
          firstName: 'cristiano',
          lastName: 'Ronaldo',
          email: 'cr7@gmail.com',
          phone: '05111111111',
          plainPasswordForVerification: 'cris7',
          passwordHashHex: PasswordHasher.hash('cris7'),
          createdAt: _seedTime,
        ),
        SeedAuthUserSpec(
          id: 'seed_user_2',
          firstName: 'lionel',
          lastName: 'messi',
          email: 'm10@gmail.com',
          phone: '05222222222',
          plainPasswordForVerification: 'messi10',
          passwordHashHex: PasswordHasher.hash('messi10'),
          createdAt: _seedTime,
        ),
        SeedAuthUserSpec(
          id: 'seed_user_3',
          firstName: 'Manuel',
          lastName: 'neur',
          email: 'neur1@gmail.com',
          phone: '05333333333',
          plainPasswordForVerification: 'neur1',
          passwordHashHex: PasswordHasher.hash('neur1'),
          createdAt: _seedTime,
        ),
        SeedAuthUserSpec(
          id: 'seed_user_4',
          firstName: 'Sergio',
          lastName: 'Ramos',
          email: 'ramos4@gmail.com',
          phone: '05444444444',
          plainPasswordForVerification: 'ramos4',
          passwordHashHex: PasswordHasher.hash('ramos4'),
          createdAt: _seedTime,
        ),
        SeedAuthUserSpec(
          id: 'seed_user_5',
          firstName: 'lamine',
          lastName: 'yamal',
          email: 'lamine@gmail.com',
          phone: '05555555555',
          plainPasswordForVerification: 'yamal10',
          passwordHashHex: PasswordHasher.hash('yamal10'),
          createdAt: _seedTime,
        ),
        SeedAuthUserSpec(
          id: 'seed_user_6',
          firstName: 'kylian',
          lastName: 'mbappe',
          email: 'mbappe@gmail.com',
          phone: '05666666666',
          plainPasswordForVerification: 'mbappe10',
          passwordHashHex: PasswordHasher.hash('mbappe10'),
          createdAt: _seedTime,
        ),
        SeedAuthUserSpec(
          id: 'seed_user_7',
          firstName: 'hary',
          lastName: 'kane',
          email: 'kane@gmail.com',
          phone: '05777777777',
          plainPasswordForVerification: 'kane9',
          passwordHashHex: PasswordHasher.hash('kane9'),
          createdAt: _seedTime,
        ),
        SeedAuthUserSpec(
          id: 'seed_user_8',
          firstName: 'erling',
          lastName: 'Haaland',
          email: 'haaland@gmail.com',
          phone: '05888888888',
          plainPasswordForVerification: 'haaland9',
          passwordHashHex: PasswordHasher.hash('haaland9'),
          createdAt: _seedTime,
        ),
        SeedAuthUserSpec(
          id: 'seed_user_9',
          firstName: 'ronaldinho',
          lastName: 'gaucho',
          email: 'r10@gmail.com',
          phone: '05999999999',
          plainPasswordForVerification: 'ronaldinho10',
          passwordHashHex: PasswordHasher.hash('ronaldinho10'),
          createdAt: _seedTime,
        ),
        SeedAuthUserSpec(
          id: 'seed_user_10',
          firstName: 'arjen',
          lastName: 'Robben',
          email: 'robben@gmail.com',
          phone: '05000000000',
          plainPasswordForVerification: 'robben10',
          passwordHashHex: PasswordHasher.hash('robben10'),
          createdAt: _seedTime,
        ),
      ];

  /// Hexadecimal formatındaki SHA-256 özetini Base64 bayt dizisine dönüştürür
  static String hexSha256ToBase64(String hexHash) {
    final normalized = hexHash.trim().toLowerCase();
    if (normalized.length != 64) {
      throw ArgumentError(
        'Geçersiz SHA-256 hex uzunluğu (${normalized.length}). 64 karakter bekleniyordu.',
      );
    }
    final bytes = <int>[];
    for (var i = 0; i < normalized.length; i += 2) {
      bytes.add(int.parse(normalized.substring(i, i + 2), radix: 16));
    }
    return base64Encode(bytes);
  }

  /// Firebase CLI'ın içsel SHA-256 hash mekanizmasını birebir simüle eder
  static String simulateFirebaseCliSha256({
    required String plainPassword,
    required String saltBase64,
  }) {
    final saltBytes = base64Decode(saltBase64);
    final passwordBytes = utf8.encode(plainPassword);
    final combined = <int>[...saltBytes, ...passwordBytes];
    final digest = sha256.convert(combined);
    return base64Encode(digest.bytes);
  }

  /// Firebase CLI içe aktarma formatına uygun JSON veri yükünü (payload) derler
  static Map<String, dynamic> buildImportJsonPayload() {
    final saltB64 = effectiveSaltBase64;

    final userEntries = seedUserSpecs.map((user) {
      final passwordHashB64 = hexSha256ToBase64(user.passwordHashHex);
      return <String, dynamic>{
        'localId': user.id,
        'email': user.email.toLowerCase().trim(),
        'emailVerified': false,
        'displayName': user.fullName,
        'passwordHash': passwordHashB64,
        'salt': saltB64,
        'createdAt': user.createdAt.millisecondsSinceEpoch.toString(),
      };
    }).toList();

    return <String, dynamic>{
      'users': userEntries,
    };
  }

  /// 10 hazır test kullanıcısının şifre ve hash bütünlüğünü doğrular
  static List<Map<String, String>> verifyAllTenSeedUsers() {
    final saltB64 = effectiveSaltBase64;
    final results = <Map<String, String>>[];

    for (final user in seedUserSpecs) {
      final expectedHex =
          PasswordHasher.hash(user.plainPasswordForVerification);
      if (user.passwordHashHex != expectedHex) {
        throw StateError('${user.id} SQLite hex hash uyuşmazlığı!');
      }

      final fromHexB64 = hexSha256ToBase64(user.passwordHashHex);
      final simulatedFirebaseB64 = simulateFirebaseCliSha256(
        plainPassword: user.plainPasswordForVerification,
        saltBase64: saltB64,
      );

      if (fromHexB64 != simulatedFirebaseB64) {
        throw StateError(
          '${user.id} için Firebase CLI SHA256 Base64 çıktısı uyuşmadı!',
        );
      }

      results.add({
        'localId': user.id,
        'email': user.email,
        'phone': user.phone,
        'displayName': user.fullName,
        'hexSha256': expectedHex,
        'passwordHashBase64': fromHexB64,
        'saltBase64': saltB64,
      });
    }

    return results;
  }

  /// Mevcut kullanıcılar ile tohumlanacak test kullanıcıları arasında UID veya e-posta çakışması olup olmadığını denetler
  static List<String> checkCollisionsWithExistingUsers(
    List<Map<String, dynamic>> existingFirebaseUsers,
  ) {
    final seedIds = seedUserSpecs.map((u) => u.id).toSet();
    final seedEmails =
        seedUserSpecs.map((u) => u.email.toLowerCase().trim()).toSet();

    final collisions = <String>[];
    for (final existing in existingFirebaseUsers) {
      final uid = (existing['localId'] as String?)?.trim() ?? '';
      final email = (existing['email'] as String?)?.toLowerCase().trim() ?? '';

      if (seedIds.contains(uid)) {
        collisions.add('UID çakışması: "$uid" Firebase Auth\'ta zaten mevcut.');
      }
      if (seedEmails.contains(email)) {
        collisions.add(
          'E-posta çakışması: "$email" Firebase Auth\'ta (UID: $uid) zaten mevcut.',
        );
      }
    }
    return collisions;
  }
}
