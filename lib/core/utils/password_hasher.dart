// Kullanıcı şifrelerini güvenli şekilde özetlemek (hash) ve doğrulamak için kullanılır.

import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Yerel veritabanında şifrelerin açık metin olarak tutulmasını engelleyen,
/// SHA-256 ve tuzlama (salt) algoritması kullanan parola şifreleme sınıfı.
class PasswordHasher {
  PasswordHasher._();

  // Şifre kırma saldırılarına karşı sabit güvenlik tuzu
  static const String _salt = '7v7_hali_saha_secure_salt_v1';

  /// Düz metin parolayı tuz ile birleştirip SHA-256 özetine dönüştürür
  static String hash(String plainPassword) {
    final bytes = utf8.encode('$_salt:$plainPassword');
    return sha256.convert(bytes).toString();
  }

  /// Girilen düz metin parolanın kayıtlı özet ile uyuşup uyuşmadığını denetler
  static bool verify(String plainPassword, String passwordHash) {
    return hash(plainPassword) == passwordHash;
  }
}
