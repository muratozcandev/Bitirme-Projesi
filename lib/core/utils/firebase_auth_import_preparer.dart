import 'dart:convert'; // JSON ve UTF-8/Base64 dönüştürme kütüphanesini içe aktarır
import 'package:crypto/crypto.dart'; // SHA-256 şifreleme/hash kütüphanesini içe aktarır
import 'password_hasher.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class SeedAuthUserSpec { // SeedAuthUserSpec veri/yardımcı sınıfını tanımlar
  final String id; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String firstName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String lastName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String email; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String phone; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String plainPasswordForVerification; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String passwordHashHex; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final DateTime createdAt; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const SeedAuthUserSpec({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.id, // id parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.firstName, // firstName parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.lastName, // lastName parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.email, // email parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.phone, // phone parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.plainPasswordForVerification, // plainPasswordForVerification parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.passwordHashHex, // passwordHashHex parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.createdAt, // createdAt parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  String get fullName => '$firstName $lastName'.trim(); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

/// 10 hazır test hesabını (`seed_user_1` .. `seed_user_10`) Firebase CLI `auth:import`
/// formatına (`--hash-algo=SHA256 --rounds=1 --hash-input-order=SALT_FIRST`) dönüştürür
/// ve mevcut `PasswordHasher.hash()` çıktılarıyla birebir uyumluluğunu doğrular.
class FirebaseAuthImportPreparer { // FirebaseAuthImportPreparer veri/yardımcı sınıfını tanımlar
  FirebaseAuthImportPreparer._(); // İlgili kod satırını ve işlemi yürütür

  static final DateTime _seedTime = DateTime.utc(2026, 1, 1, 12, 0); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  /// `PasswordHasher.hash()` içerisinde kullanılan `'$_salt:$plainPassword'` yapısındaki
  /// efektif salt değeri (iki nokta üst üste dahil 29 UTF-8 byte).
  static const String effectiveSaltRaw = '7v7_hali_saha_secure_salt_v1:'; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  /// Efektif salt değerinin standart Base64 karşılığı: `N3Y3X2hhbGlfc2FoYV9zZWN1cmVfc2FsdF92MTo=`
  static String get effectiveSaltBase64 => // İlgili kod satırını ve işlemi yürütür
      base64Encode(utf8.encode(effectiveSaltRaw)); // İlgili kod satırını ve işlemi yürütür

  static List<SeedAuthUserSpec> get seedUserSpecs => [ // İlgili kod satırını ve işlemi yürütür
        SeedAuthUserSpec( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_1', // id özelliğini yapılandırır
          firstName: 'cristiano', // firstName özelliğini yapılandırır
          lastName: 'Ronaldo', // lastName özelliğini yapılandırır
          email: 'cr7@gmail.com', // email özelliğini yapılandırır
          phone: '05111111111', // phone özelliğini yapılandırır
          plainPasswordForVerification: 'cris7', // plainPasswordForVerification özelliğini yapılandırır
          passwordHashHex: PasswordHasher.hash('cris7'), // passwordHashHex özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        SeedAuthUserSpec( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_2', // id özelliğini yapılandırır
          firstName: 'lionel', // firstName özelliğini yapılandırır
          lastName: 'messi', // lastName özelliğini yapılandırır
          email: 'm10@gmail.com', // email özelliğini yapılandırır
          phone: '05222222222', // phone özelliğini yapılandırır
          plainPasswordForVerification: 'messi10', // plainPasswordForVerification özelliğini yapılandırır
          passwordHashHex: PasswordHasher.hash('messi10'), // passwordHashHex özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        SeedAuthUserSpec( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_3', // id özelliğini yapılandırır
          firstName: 'Manuel', // firstName özelliğini yapılandırır
          lastName: 'neur', // lastName özelliğini yapılandırır
          email: 'neur1@gmail.com', // email özelliğini yapılandırır
          phone: '05333333333', // phone özelliğini yapılandırır
          plainPasswordForVerification: 'neur1', // plainPasswordForVerification özelliğini yapılandırır
          passwordHashHex: PasswordHasher.hash('neur1'), // passwordHashHex özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        SeedAuthUserSpec( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_4', // id özelliğini yapılandırır
          firstName: 'Sergio', // firstName özelliğini yapılandırır
          lastName: 'Ramos', // lastName özelliğini yapılandırır
          email: 'ramos4@gmail.com', // email özelliğini yapılandırır
          phone: '05444444444', // phone özelliğini yapılandırır
          plainPasswordForVerification: 'ramos4', // plainPasswordForVerification özelliğini yapılandırır
          passwordHashHex: PasswordHasher.hash('ramos4'), // passwordHashHex özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        SeedAuthUserSpec( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_5', // id özelliğini yapılandırır
          firstName: 'lamine', // firstName özelliğini yapılandırır
          lastName: 'yamal', // lastName özelliğini yapılandırır
          email: 'lamine@gmail.com', // email özelliğini yapılandırır
          phone: '05555555555', // phone özelliğini yapılandırır
          plainPasswordForVerification: 'yamal10', // plainPasswordForVerification özelliğini yapılandırır
          passwordHashHex: PasswordHasher.hash('yamal10'), // passwordHashHex özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        SeedAuthUserSpec( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_6', // id özelliğini yapılandırır
          firstName: 'kylian', // firstName özelliğini yapılandırır
          lastName: 'mbappe', // lastName özelliğini yapılandırır
          email: 'mbappe@gmail.com', // email özelliğini yapılandırır
          phone: '05666666666', // phone özelliğini yapılandırır
          plainPasswordForVerification: 'mbappe10', // plainPasswordForVerification özelliğini yapılandırır
          passwordHashHex: PasswordHasher.hash('mbappe10'), // passwordHashHex özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        SeedAuthUserSpec( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_7', // id özelliğini yapılandırır
          firstName: 'hary', // firstName özelliğini yapılandırır
          lastName: 'kane', // lastName özelliğini yapılandırır
          email: 'kane@gmail.com', // email özelliğini yapılandırır
          phone: '05777777777', // phone özelliğini yapılandırır
          plainPasswordForVerification: 'kane9', // plainPasswordForVerification özelliğini yapılandırır
          passwordHashHex: PasswordHasher.hash('kane9'), // passwordHashHex özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        SeedAuthUserSpec( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_8', // id özelliğini yapılandırır
          firstName: 'erling', // firstName özelliğini yapılandırır
          lastName: 'Haaland', // lastName özelliğini yapılandırır
          email: 'haaland@gmail.com', // email özelliğini yapılandırır
          phone: '05888888888', // phone özelliğini yapılandırır
          plainPasswordForVerification: 'haaland9', // plainPasswordForVerification özelliğini yapılandırır
          passwordHashHex: PasswordHasher.hash('haaland9'), // passwordHashHex özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        SeedAuthUserSpec( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_9', // id özelliğini yapılandırır
          firstName: 'ronaldinho', // firstName özelliğini yapılandırır
          lastName: 'gaucho', // lastName özelliğini yapılandırır
          email: 'r10@gmail.com', // email özelliğini yapılandırır
          phone: '05999999999', // phone özelliğini yapılandırır
          plainPasswordForVerification: 'ronaldinho10', // plainPasswordForVerification özelliğini yapılandırır
          passwordHashHex: PasswordHasher.hash('ronaldinho10'), // passwordHashHex özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        SeedAuthUserSpec( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_10', // id özelliğini yapılandırır
          firstName: 'arjen', // firstName özelliğini yapılandırır
          lastName: 'Robben', // lastName özelliğini yapılandırır
          email: 'robben@gmail.com', // email özelliğini yapılandırır
          phone: '05000000000', // phone özelliğini yapılandırır
          plainPasswordForVerification: 'robben10', // plainPasswordForVerification özelliğini yapılandırır
          passwordHashHex: PasswordHasher.hash('robben10'), // passwordHashHex özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ]; // Açık olan kod/bileşen bloğunu kapatır

  /// 64 karakterli onaltılık (Hex) SHA-256 özetini 32 ham byte'a çevirip Base64'e kodlar.
  static String hexSha256ToBase64(String hexHash) { // İlgili kod satırını ve işlemi yürütür
    final normalized = hexHash.trim().toLowerCase(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (normalized.length != 64) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw ArgumentError( // İlgili hata nesnesini (Exception) fırlatır
        'Geçersiz SHA-256 hex uzunluğu (${normalized.length}). 64 karakter bekleniyordu.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    final bytes = <int>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (var i = 0; i < normalized.length; i += 2) { // Koleksiyon veya aralık üzerinde döngü başlatır
      bytes.add(int.parse(normalized.substring(i, i + 2), radix: 16)); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
    return base64Encode(bytes); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  /// Firebase CLI `--hash-algo=SHA256 --rounds=1 --hash-input-order=SALT_FIRST`
  /// davranışını birebir simüle ederek Base64 `passwordHash` üretir.
  static String simulateFirebaseCliSha256({ // İlgili kod satırını ve işlemi yürütür
    required String plainPassword, // İlgili kod satırını ve işlemi yürütür
    required String saltBase64, // İlgili kod satırını ve işlemi yürütür
  }) { // İlgili kod satırını ve işlemi yürütür
    final saltBytes = base64Decode(saltBase64); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final passwordBytes = utf8.encode(plainPassword); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final combined = <int>[...saltBytes, ...passwordBytes]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final digest = sha256.convert(combined); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return base64Encode(digest.bytes); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  /// 10 hazır kullanıcı için `seed_users_auth.json` içeriğini oluşturur.
  static Map<String, dynamic> buildImportJsonPayload() { // İlgili kod satırını ve işlemi yürütür
    final saltB64 = effectiveSaltBase64; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    final userEntries = seedUserSpecs.map((user) { // Sabit/final değişken veya nesne tanımını başlatır
      final passwordHashB64 = hexSha256ToBase64(user.passwordHashHex); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      return <String, dynamic>{ // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
        'localId': user.id, // 'localId' özelliğini yapılandırır
        'email': user.email.toLowerCase().trim(), // 'email' özelliğini yapılandırır
        'emailVerified': false, // 'emailVerified' özelliğini yapılandırır
        'displayName': user.fullName, // 'displayName' özelliğini yapılandırır
        'passwordHash': passwordHashB64, // 'passwordHash' özelliğini yapılandırır
        'salt': saltB64, // 'salt' özelliğini yapılandırır
        'createdAt': user.createdAt.millisecondsSinceEpoch.toString(), // 'createdAt' özelliğini yapılandırır
      }; // Açık olan kod/bileşen bloğunu kapatır
    }).toList(); // İlgili kod satırını ve işlemi yürütür

    return <String, dynamic>{ // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      'users': userEntries, // 'users' özelliğini yapılandırır
    }; // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  /// 10 hazır kullanıcının bilinen test şifreleriyle `PasswordHasher.hash()` ve
  /// Firebase CLI `SHA256` (`SALT_FIRST`, `rounds=1`) simülasyonunun %100 eşleştiğini doğrular.
  static List<Map<String, String>> verifyAllTenSeedUsers() { // İlgili kod satırını ve işlemi yürütür
    final saltB64 = effectiveSaltBase64; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final results = <Map<String, String>>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    for (final user in seedUserSpecs) { // Koleksiyon veya aralık üzerinde döngü başlatır
      final expectedHex = // Sabit/final değişken veya nesne tanımını başlatır
          PasswordHasher.hash(user.plainPasswordForVerification); // İlgili kod satırını ve işlemi yürütür
      if (user.passwordHashHex != expectedHex) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw StateError('${user.id} SQLite hex hash uyuşmazlığı!'); // İlgili hata nesnesini (Exception) fırlatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final fromHexB64 = hexSha256ToBase64(user.passwordHashHex); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final simulatedFirebaseB64 = simulateFirebaseCliSha256( // Sabit/final değişken veya nesne tanımını başlatır
        plainPassword: user.plainPasswordForVerification, // plainPassword özelliğini yapılandırır
        saltBase64: saltB64, // saltBase64 özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır

      if (fromHexB64 != simulatedFirebaseB64) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw StateError( // İlgili hata nesnesini (Exception) fırlatır
          '${user.id} için Firebase CLI SHA256 Base64 çıktısı uyuşmadı!', // İlgili kod satırını ve işlemi yürütür
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır

      results.add({ // İlgili kod satırını ve işlemi yürütür
        'localId': user.id, // 'localId' özelliğini yapılandırır
        'email': user.email, // 'email' özelliğini yapılandırır
        'phone': user.phone, // 'phone' özelliğini yapılandırır
        'displayName': user.fullName, // 'displayName' özelliğini yapılandırır
        'hexSha256': expectedHex, // 'hexSha256' özelliğini yapılandırır
        'passwordHashBase64': fromHexB64, // 'passwordHashBase64' özelliğini yapılandırır
        'saltBase64': saltB64, // 'saltBase64' özelliğini yapılandırır
      }); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    return results; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  /// Mevcut Firebase Auth kullanıcı listesiyle (`auth:export` çıktısı) 10 hazır test hesabı
  /// arasında UID (`localId`) veya `email` çakışması olup olmadığını kontrol eder.
  static List<String> checkCollisionsWithExistingUsers( // İlgili kod satırını ve işlemi yürütür
    List<Map<String, dynamic>> existingFirebaseUsers, // İlgili kod satırını ve işlemi yürütür
  ) { // İlgili kod satırını ve işlemi yürütür
    final seedIds = seedUserSpecs.map((u) => u.id).toSet(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final seedEmails = // Sabit/final değişken veya nesne tanımını başlatır
        seedUserSpecs.map((u) => u.email.toLowerCase().trim()).toSet(); // İlgili kod satırını ve işlemi yürütür

    final collisions = <String>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (final existing in existingFirebaseUsers) { // Koleksiyon veya aralık üzerinde döngü başlatır
      final uid = (existing['localId'] as String?)?.trim() ?? ''; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final email = (existing['email'] as String?)?.toLowerCase().trim() ?? ''; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

      if (seedIds.contains(uid)) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        collisions.add('UID çakışması: "$uid" Firebase Auth\'ta zaten mevcut.'); // İlgili kod satırını ve işlemi yürütür
      } // Açık olan kod/bileşen bloğunu kapatır
      if (seedEmails.contains(email)) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        collisions.add( // İlgili kod satırını ve işlemi yürütür
          'E-posta çakışması: "$email" Firebase Auth\'ta (UID: $uid) zaten mevcut.', // 'E-posta çakışması özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    return collisions; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
