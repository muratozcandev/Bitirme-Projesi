import 'dart:convert'; // JSON ve UTF-8/Base64 dönüştürme kütüphanesini içe aktarır
import 'package:crypto/crypto.dart'; // SHA-256 şifreleme/hash kütüphanesini içe aktarır

class PasswordHasher { // PasswordHasher veri/yardımcı sınıfını tanımlar
  PasswordHasher._(); // İlgili kod satırını ve işlemi yürütür

  static const String _salt = '7v7_hali_saha_secure_salt_v1'; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  static String hash(String plainPassword) { // İlgili kod satırını ve işlemi yürütür
    final bytes = utf8.encode('$_salt:$plainPassword'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return sha256.convert(bytes).toString(); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  static bool verify(String plainPassword, String passwordHash) { // İlgili kod satırını ve işlemi yürütür
    return hash(plainPassword) == passwordHash; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

