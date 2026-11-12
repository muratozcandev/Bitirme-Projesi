import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHasher {
  PasswordHasher._();

  static const String _salt = '7v7_hali_saha_secure_salt_v1';

  static String hash(String plainPassword) {
    final bytes = utf8.encode('$_salt:$plainPassword');
    return sha256.convert(bytes).toString();
  }

  static bool verify(String plainPassword, String passwordHash) {
    return hash(plainPassword) == passwordHash;
  }
}

