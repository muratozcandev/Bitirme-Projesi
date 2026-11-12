import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'password_hasher.dart';

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

/// 10 hazır test hesabını (`seed_user_1` .. `seed_user_10`) Firebase CLI `auth:import`
/// formatına (`--hash-algo=SHA256 --rounds=1 --hash-input-order=SALT_FIRST`) dönüştürür
/// ve mevcut `PasswordHasher.hash()` çıktılarıyla birebir uyumluluğunu doğrular.
class FirebaseAuthImportPreparer {
  FirebaseAuthImportPreparer._();

  static final DateTime _seedTime = DateTime.utc(2026, 1, 1, 12, 0);

  /// `PasswordHasher.hash()` içerisinde kullanılan `'$_salt:$plainPassword'` yapısındaki
  /// efektif salt değeri (iki nokta üst üste dahil 29 UTF-8 byte).
  static const String effectiveSaltRaw = '7v7_hali_saha_secure_salt_v1:';

  /// Efektif salt değerinin standart Base64 karşılığı: `N3Y3X2hhbGlfc2FoYV9zZWN1cmVfc2FsdF92MTo=`
  static String get effectiveSaltBase64 =>
      base64Encode(utf8.encode(effectiveSaltRaw));

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

  /// 64 karakterli onaltılık (Hex) SHA-256 özetini 32 ham byte'a çevirip Base64'e kodlar.
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

  /// Firebase CLI `--hash-algo=SHA256 --rounds=1 --hash-input-order=SALT_FIRST`
  /// davranışını birebir simüle ederek Base64 `passwordHash` üretir.
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

  /// 10 hazır kullanıcı için `seed_users_auth.json` içeriğini oluşturur.
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

  /// 10 hazır kullanıcının bilinen test şifreleriyle `PasswordHasher.hash()` ve
  /// Firebase CLI `SHA256` (`SALT_FIRST`, `rounds=1`) simülasyonunun %100 eşleştiğini doğrular.
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

  /// Mevcut Firebase Auth kullanıcı listesiyle (`auth:export` çıktısı) 10 hazır test hesabı
  /// arasında UID (`localId`) veya `email` çakışması olup olmadığını kontrol eder.
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
