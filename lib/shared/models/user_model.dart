import 'package:cloud_firestore/cloud_firestore.dart'; // Cloud Firestore bulut veritabanı paketini içe aktarır

class UserModel { // UserModel veri/yardımcı sınıfını tanımlar
  final String id; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String firstName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String lastName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String email; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String phone; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String passwordHash; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? profileImage; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String themeMode; // 'light' | 'dark'
  final DateTime createdAt; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool termsAccepted; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool kvkkAccepted; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const UserModel({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.id, // id parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.firstName, // firstName parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.lastName, // lastName parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.email, // email parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.phone, // phone parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.passwordHash = '', // passwordHash = '' sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.profileImage, // profileImage sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.themeMode = 'light', // themeMode = 'light' sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.createdAt, // createdAt parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.termsAccepted = false, // termsAccepted = false sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.kvkkAccepted = false, // kvkkAccepted = false sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  String get uid => id; // İlgili kod satırını ve işlemi yürütür

  String get fullName => '$firstName $lastName'.trim(); // İlgili kod satırını ve işlemi yürütür

  String get initials { // İlgili kod satırını ve işlemi yürütür
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : ''; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : ''; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return '$f$l'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  UserModel copyWith({ // İlgili kod satırını ve işlemi yürütür
    String? id, // İlgili kod satırını ve işlemi yürütür
    String? firstName, // İlgili kod satırını ve işlemi yürütür
    String? lastName, // İlgili kod satırını ve işlemi yürütür
    String? email, // İlgili kod satırını ve işlemi yürütür
    String? phone, // İlgili kod satırını ve işlemi yürütür
    String? passwordHash, // İlgili kod satırını ve işlemi yürütür
    String? profileImage, // İlgili kod satırını ve işlemi yürütür
    String? themeMode, // İlgili kod satırını ve işlemi yürütür
    DateTime? createdAt, // İlgili kod satırını ve işlemi yürütür
    bool? termsAccepted, // İlgili kod satırını ve işlemi yürütür
    bool? kvkkAccepted, // İlgili kod satırını ve işlemi yürütür
  }) { // İlgili kod satırını ve işlemi yürütür
    return UserModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: id ?? this.id, // id özelliğini yapılandırır
      firstName: firstName ?? this.firstName, // firstName özelliğini yapılandırır
      lastName: lastName ?? this.lastName, // lastName özelliğini yapılandırır
      email: email ?? this.email, // email özelliğini yapılandırır
      phone: phone ?? this.phone, // phone özelliğini yapılandırır
      passwordHash: passwordHash ?? this.passwordHash, // passwordHash özelliğini yapılandırır
      profileImage: profileImage ?? this.profileImage, // profileImage özelliğini yapılandırır
      themeMode: themeMode ?? this.themeMode, // themeMode özelliğini yapılandırır
      createdAt: createdAt ?? this.createdAt, // createdAt özelliğini yapılandırır
      termsAccepted: termsAccepted ?? this.termsAccepted, // termsAccepted özelliğini yapılandırır
      kvkkAccepted: kvkkAccepted ?? this.kvkkAccepted, // kvkkAccepted özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  /// Yerel SQLite tablosu için harita (şifre yalnızca yerel seed hesaplarında kullanılır)
  Map<String, dynamic> toMap() { // İlgili kod satırını ve işlemi yürütür
    return { // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      'id': id, // 'id' özelliğini yapılandırır
      'firstName': firstName, // 'firstName' özelliğini yapılandırır
      'lastName': lastName, // 'lastName' özelliğini yapılandırır
      'email': email.toLowerCase().trim(), // 'email' özelliğini yapılandırır
      'phone': phone.trim(), // 'phone' özelliğini yapılandırır
      'passwordHash': passwordHash, // 'passwordHash' özelliğini yapılandırır
      'profileImage': profileImage, // 'profileImage' özelliğini yapılandırır
      'themeMode': themeMode, // 'themeMode' özelliğini yapılandırır
      'createdAt': createdAt.toIso8601String(), // 'createdAt' özelliğini yapılandırır
    }; // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  /// Cloud Firestore `users/{uid}` koleksiyonu için harita.
  /// Güvenlik kuralı gereği şifre veya passwordHash KESİNLİKLE Firestore'a kaydedilmez.
  Map<String, dynamic> toFirestoreMap() { // İlgili kod satırını ve işlemi yürütür
    return { // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      'uid': id, // 'uid' özelliğini yapılandırır
      'firstName': firstName.trim(), // 'firstName' özelliğini yapılandırır
      'lastName': lastName.trim(), // 'lastName' özelliğini yapılandırır
      'email': email.toLowerCase().trim(), // 'email' özelliğini yapılandırır
      'phone': phone.trim(), // 'phone' özelliğini yapılandırır
      'createdAt': Timestamp.fromDate(createdAt), // 'createdAt' özelliğini yapılandırır
      'termsAccepted': termsAccepted, // 'termsAccepted' özelliğini yapılandırır
      'kvkkAccepted': kvkkAccepted, // 'kvkkAccepted' özelliğini yapılandırır
      'themeMode': themeMode, // 'themeMode' özelliğini yapılandırır
      if (profileImage != null) 'profileImage': profileImage, // Koşulun sağlanıp sağlanmadığını kontrol eder
    }; // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  factory UserModel.fromMap(Map<String, dynamic> map) { // İlgili kod satırını ve işlemi yürütür
    return UserModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: (map['id'] ?? map['uid']) as String, // id özelliğini yapılandırır
      firstName: map['firstName'] as String? ?? '', // firstName özelliğini yapılandırır
      lastName: map['lastName'] as String? ?? '', // lastName özelliğini yapılandırır
      email: map['email'] as String? ?? '', // email özelliğini yapılandırır
      phone: map['phone'] as String? ?? '', // phone özelliğini yapılandırır
      passwordHash: map['passwordHash'] as String? ?? '', // passwordHash özelliğini yapılandırır
      profileImage: map['profileImage'] as String?, // profileImage özelliğini yapılandırır
      themeMode: (map['themeMode'] as String?) ?? 'light', // themeMode özelliğini yapılandırır
      createdAt: _parseDateTime(map['createdAt']), // createdAt özelliğini yapılandırır
      termsAccepted: _parseBool(map['termsAccepted'], defaultValue: false), // termsAccepted özelliğini yapılandırır
      kvkkAccepted: _parseBool(map['kvkkAccepted'], defaultValue: false), // kvkkAccepted özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  factory UserModel.fromFirestore( // İlgili kod satırını ve işlemi yürütür
    Map<String, dynamic> map, { // İlgili kod satırını ve işlemi yürütür
    required String docId, // İlgili kod satırını ve işlemi yürütür
  }) { // İlgili kod satırını ve işlemi yürütür
    return UserModel( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      id: (map['uid'] as String?)?.isNotEmpty == true // İlgili kod satırını ve işlemi yürütür
          ? map['uid'] as String // İlgili kod satırını ve işlemi yürütür
          : docId, //  özelliğini yapılandırır
      firstName: map['firstName'] as String? ?? '', // firstName özelliğini yapılandırır
      lastName: map['lastName'] as String? ?? '', // lastName özelliğini yapılandırır
      email: map['email'] as String? ?? '', // email özelliğini yapılandırır
      phone: map['phone'] as String? ?? '', // phone özelliğini yapılandırır
      passwordHash: '', // passwordHash özelliğini yapılandırır
      profileImage: map['profileImage'] as String?, // profileImage özelliğini yapılandırır
      themeMode: (map['themeMode'] as String?) ?? 'light', // themeMode özelliğini yapılandırır
      createdAt: _parseDateTime(map['createdAt']), // createdAt özelliğini yapılandırır
      termsAccepted: _parseBool(map['termsAccepted'], defaultValue: false), // termsAccepted özelliğini yapılandırır
      kvkkAccepted: _parseBool(map['kvkkAccepted'], defaultValue: false), // kvkkAccepted özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  static DateTime _parseDateTime(Object? raw) { // İlgili kod satırını ve işlemi yürütür
    if (raw is Timestamp) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return raw.toDate(); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    if (raw is String && raw.isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return DateTime.tryParse(raw) ?? DateTime.now(); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return DateTime.now(); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  static bool _parseBool(Object? raw, {bool defaultValue = false}) { // İlgili kod satırını ve işlemi yürütür
    if (raw is bool) return raw; // Koşulun sağlanıp sağlanmadığını kontrol eder
    if (raw is int) return raw == 1; // Koşulun sağlanıp sağlanmadığını kontrol eder
    return defaultValue; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
