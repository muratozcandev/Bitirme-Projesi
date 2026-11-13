// Kullanıcı profil ve hesap bilgilerini temsil eden veri modelidir.

import 'package:cloud_firestore/cloud_firestore.dart';

/// Sistemdeki bir oyuncunun profil, kimlik, iletişim, tema ve yasal onay bilgilerini tutan temel model.
/// Hem SQLite hem de Cloud Firestore ile çift yönlü serileştirme desteği sunar.
class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String passwordHash;
  final String? profileImage;
  final String themeMode;
  final DateTime createdAt;
  final bool termsAccepted;
  final bool kvkkAccepted;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.passwordHash = '',
    this.profileImage,
    this.themeMode = 'light',
    required this.createdAt,
    this.termsAccepted = false,
    this.kvkkAccepted = false,
  });

  /// Firebase Auth UID ile uyumluluk takma adı
  String get uid => id;

  /// Ad ve soyadı birleştirilmiş tam isim olarak döndürür
  String get fullName => '$firstName $lastName'.trim();

  /// Profil avatarı için isim ve soyismin ilk harflerini (Örn: 'CR') döndürür
  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l';
  }

  /// Mevcut modelin belirli alanlarını güncelleyerek yeni bir kopyasını üretir
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? passwordHash,
    String? profileImage,
    String? themeMode,
    DateTime? createdAt,
    bool? termsAccepted,
    bool? kvkkAccepted,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      passwordHash: passwordHash ?? this.passwordHash,
      profileImage: profileImage ?? this.profileImage,
      themeMode: themeMode ?? this.themeMode,
      createdAt: createdAt ?? this.createdAt,
      termsAccepted: termsAccepted ?? this.termsAccepted,
      kvkkAccepted: kvkkAccepted ?? this.kvkkAccepted,
    );
  }

  /// Modeli yerel SQLite veritabanı formatına (Map) dönüştürür
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email.toLowerCase().trim(),
      'phone': phone.trim(),
      'passwordHash': passwordHash,
      'profileImage': profileImage,
      'themeMode': themeMode,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Modeli Cloud Firestore belgesine uygun formata dönüştürür (Şifre ASLA Firestore'a gönderilmez)
  Map<String, dynamic> toFirestoreMap() {
    return {
      'uid': id,
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'email': email.toLowerCase().trim(),
      'phone': phone.trim(),
      'createdAt': Timestamp.fromDate(createdAt),
      'termsAccepted': termsAccepted,
      'kvkkAccepted': kvkkAccepted,
      'themeMode': themeMode,
      if (profileImage != null) 'profileImage': profileImage,
    };
  }

  /// SQLite sorgu sonucundan (Map) model örneği oluşturur
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: (map['id'] ?? map['uid']) as String,
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      passwordHash: map['passwordHash'] as String? ?? '',
      profileImage: map['profileImage'] as String?,
      themeMode: (map['themeMode'] as String?) ?? 'light',
      createdAt: _parseDateTime(map['createdAt']),
      termsAccepted: _parseBool(map['termsAccepted'], defaultValue: false),
      kvkkAccepted: _parseBool(map['kvkkAccepted'], defaultValue: false),
    );
  }

  /// Cloud Firestore belgesinden model örneği oluşturur
  factory UserModel.fromFirestore(
    Map<String, dynamic> map, {
    required String docId,
  }) {
    return UserModel(
      id: (map['uid'] as String?)?.isNotEmpty == true
          ? map['uid'] as String
          : docId,
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      passwordHash: '',
      profileImage: map['profileImage'] as String?,
      themeMode: (map['themeMode'] as String?) ?? 'light',
      createdAt: _parseDateTime(map['createdAt']),
      termsAccepted: _parseBool(map['termsAccepted'], defaultValue: false),
      kvkkAccepted: _parseBool(map['kvkkAccepted'], defaultValue: false),
    );
  }

  /// Farklı veri tiplerinden (Timestamp, String) DateTime dönüşümü yapan yardımcı metot
  static DateTime _parseDateTime(Object? raw) {
    if (raw is Timestamp) {
      return raw.toDate();
    }
    if (raw is String && raw.isNotEmpty) {
      return DateTime.tryParse(raw) ?? DateTime.now();
    }
    return DateTime.now();
  }

  /// Boolean veya SQLite integer (0/1) değerini bool tipine dönüştürür
  static bool _parseBool(Object? raw, {bool defaultValue = false}) {
    if (raw is bool) return raw;
    if (raw is int) return raw == 1;
    return defaultValue;
  }
}
