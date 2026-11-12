import 'package:cloud_firestore/cloud_firestore.dart'; // Cloud Firestore bulut veritabanı paketini içe aktarır
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication kimlik doğrulama paketini içe aktarır
import 'package:shared_preferences/shared_preferences.dart'; // Yerel anahtar-değer (SharedPreferences) depolama paketini içe aktarır
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // SQLite yerel veritabanı sürücüsünü içe aktarır
import '../../../core/constants/app_constants.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../core/errors/app_exception.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../core/utils/validators.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../data/database/app_database.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../data/seed/seed_data.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/user_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../domain/auth_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class FirebaseAuthRepository implements AuthRepository { // FirebaseAuthRepository veri erişim (repository) sınıfını tanımlar
  final FirebaseAuth? _firebaseAuth; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final FirebaseFirestore? _firestore; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final AppDatabase appDatabase; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final SharedPreferences prefs; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  FirebaseAuthRepository({ // İlgili kod satırını ve işlemi yürütür
    required FirebaseAuth? firebaseAuth, // İlgili kod satırını ve işlemi yürütür
    required FirebaseFirestore? firestore, // İlgili kod satırını ve işlemi yürütür
    required this.appDatabase, // appDatabase parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.prefs, // prefs parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  })  : _firebaseAuth = firebaseAuth, // }) özelliğini yapılandırır
        _firestore = firestore; // İlgili kod satırını ve işlemi yürütür

  FirebaseAuth get _auth { // İlgili kod satırını ve işlemi yürütür
    final instance = _firebaseAuth; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (instance == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Firebase Authentication servisi başlatılamadı. Lütfen bağlantınızı kontrol edin.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    return instance; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  FirebaseFirestore get _db { // İlgili kod satırını ve işlemi yürütür
    final instance = _firestore; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (instance == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Cloud Firestore servisi başlatılamadı. Lütfen bağlantınızı kontrol edin.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    return instance; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  /// Firebase Auth hatalarını anlaşılır Türkçe mesajlara dönüştürür
  AppException _mapFirebaseAuthException(FirebaseAuthException e) { // İlgili kod satırını ve işlemi yürütür
    switch (e.code) { // Değere göre çoklu durum kontrolü (switch) başlatır
      case 'email-already-in-use': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        return const AppException( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          'Bu e-posta adresi başka bir hesapta zaten kayıtlı.', // İlgili kod satırını ve işlemi yürütür
          code: 'email-already-in-use', // code özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      case 'invalid-email': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        return const AppException( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          'Geçersiz e-posta adresi formatı.', // İlgili kod satırını ve işlemi yürütür
          code: 'invalid-email', // code özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      case 'weak-password': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        return const AppException( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          'Şifre çok zayıf. Lütfen en az 6 karakterli bir şifre belirleyin.', // İlgili kod satırını ve işlemi yürütür
          code: 'weak-password', // code özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      case 'user-not-found': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
      case 'wrong-password': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
      case 'invalid-credential': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        return const AppException( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          'E-posta adresi veya şifre hatalı. Lütfen bilgilerinizi kontrol edin.', // İlgili kod satırını ve işlemi yürütür
          code: 'invalid-credential', // code özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      case 'user-disabled': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        return const AppException( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          'Bu kullanıcı hesabı devre dışı bırakılmış.', // İlgili kod satırını ve işlemi yürütür
          code: 'user-disabled', // code özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      case 'too-many-requests': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        return const AppException( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          'Çok fazla başarısız deneme yapıldı. Lütfen biraz bekleyip tekrar deneyin.', // İlgili kod satırını ve işlemi yürütür
          code: 'too-many-requests', // code özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      case 'network-request-failed': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        return const AppException( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          'İnternet bağlantısı kurulamadı. Lütfen ağ bağlantınızı kontrol edin.', // İlgili kod satırını ve işlemi yürütür
          code: 'network-request-failed', // code özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      case 'operation-not-allowed': // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
        return const AppException( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          'E-posta/Şifre ile giriş yöntemi Firebase Console üzerinde etkinleştirilmemiş.', // İlgili kod satırını ve işlemi yürütür
          code: 'operation-not-allowed', // code özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      default: // Hiçbir durum eşleşmediğinde çalışacak varsayılan dalı tanımlar
        return AppException( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          e.message ?? // İlgili kod satırını ve işlemi yürütür
              'Kimlik doğrulama işlemi sırasında bir hata oluştu (${e.code}).', // İlgili kod satırını ve işlemi yürütür
          code: e.code, // code özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  /// Yerel özelliklerin (Takım Kurma, Randevular, Sohbet, Bildirimler) kullanıcı adını
  /// ve profilini çözebilmesi için şifresiz profil önbelleğini SQLite ile senkronize eder.
  /// Mevcut SQLite kaydındaki telefon numarasını asla boş değerle ezmez ve kullanıcı ID'sini değiştirmez.
  Future<void> _syncProfileToLocalCache(UserModel user) async { // İlgili kod satırını ve işlemi yürütür
    final sqlite = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final existingRows = await sqlite.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [user.id], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final existingRow = existingRows.isNotEmpty ? existingRows.first : null; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final existingPhone = (existingRow?['phone'] as String?)?.trim() ?? ''; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final existingPasswordHash = // Sabit/final değişken veya nesne tanımını başlatır
        (existingRow?['passwordHash'] as String?)?.trim() ?? ''; // İlgili kod satırını ve işlemi yürütür

    final resolvedPhone = // Sabit/final değişken veya nesne tanımını başlatır
        user.phone.trim().isNotEmpty ? user.phone.trim() : existingPhone; // İlgili kod satırını ve işlemi yürütür
    // SQLite `users.phone` sütunu UNIQUE olduğu için telefon bilgisi olmayan harici Auth
    // hesaplarının birbirini ezmemesi adına benzersiz yer tutucu kullanılır.
    final sqliteSafePhone = // Sabit/final değişken veya nesne tanımını başlatır
        resolvedPhone.isNotEmpty ? resolvedPhone : 'UNSET_${user.id}'; // İlgili kod satırını ve işlemi yürütür
    final resolvedPasswordHash = existingPasswordHash.isNotEmpty && // Sabit/final değişken veya nesne tanımını başlatır
            existingPasswordHash != 'FIREBASE_AUTH_MANAGED' // İlgili kod satırını ve işlemi yürütür
        ? existingPasswordHash // İlgili kod satırını ve işlemi yürütür
        : 'FIREBASE_AUTH_MANAGED'; // İlgili kod satırını ve işlemi yürütür

    await sqlite.insert( // SQLite veritabanı tablosuna yeni kayıt ekler
      'users', // İlgili kod satırını ve işlemi yürütür
      { // İlgili kod satırını ve işlemi yürütür
        'id': user.id, // 'id' özelliğini yapılandırır
        'firstName': user.firstName, // 'firstName' özelliğini yapılandırır
        'lastName': user.lastName, // 'lastName' özelliğini yapılandırır
        'email': user.email.toLowerCase().trim(), // 'email' özelliğini yapılandırır
        'phone': sqliteSafePhone, // 'phone' özelliğini yapılandırır
        'passwordHash': resolvedPasswordHash, // 'passwordHash' özelliğini yapılandırır
        'profileImage': user.profileImage ?? existingRow?['profileImage'], // 'profileImage' özelliğini yapılandırır
        'themeMode': user.themeMode, // 'themeMode' özelliğini yapılandırır
        'createdAt': user.createdAt.toIso8601String(), // 'createdAt' özelliğini yapılandırır
      }, // Açık olan kod/bileşen bloğunu kapatır
      conflictAlgorithm: ConflictAlgorithm.replace, // conflictAlgorithm özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  /// SQLite `consents` tablosunda kullanıcının gerçek onay kaydı olup olmadığını denetler.
  /// Yalnızca gerçekten onay verilmişse (`accepted = 1`) true döndürür;
  /// eski test hesaplarında (`seed_user_1` .. `seed_user_10`) gerçek kullanıcı onayı yoksa false döner.
  Future<({bool termsAccepted, bool kvkkAccepted})> _getVerifiedLocalConsents( // İlgili kod satırını ve işlemi yürütür
    String userId, // İlgili kod satırını ve işlemi yürütür
  ) async { // İlgili kod satırını ve işlemi yürütür
    final sqlite = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await sqlite.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'consents', // İlgili kod satırını ve işlemi yürütür
      where: 'userId = ? AND accepted = 1', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final hasTerms = rows.any((r) => r['documentType'] == 'user_agreement'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final hasKvkk = rows.any((r) => r['documentType'] == 'kvkk'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return (termsAccepted: hasTerms, kvkkAccepted: hasKvkk); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<UserModel?> _getLocalCachedUser(String userId) async { // İlgili kod satırını ve işlemi yürütür
    final sqlite = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await sqlite.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (rows.isEmpty) return null; // Koşulun sağlanıp sağlanmadığını kontrol eder
    final baseUser = UserModel.fromMap(rows.first); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final sanitizedPhone = // Sabit/final değişken veya nesne tanımını başlatır
        baseUser.phone.startsWith('UNSET_') ? '' : baseUser.phone; // İlgili kod satırını ve işlemi yürütür
    final consents = await _getVerifiedLocalConsents(userId); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return baseUser.copyWith( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      phone: sanitizedPhone, // phone özelliğini yapılandırır
      termsAccepted: consents.termsAccepted, // termsAccepted özelliğini yapılandırır
      kvkkAccepted: consents.kvkkAccepted, // kvkkAccepted özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  /// Firestore `users/{uid}` belgesi henüz bulunmayan bir kullanıcı için
  /// önce SQLite `users` tablosundan, eğer UID `seed_user_1` .. `seed_user_10` arasındaysa
  /// `SeedData.predefinedUsers` içerisinden mevcut profil bilgilerini (ID eşleşmesini bozmadan) çözer.
  Future<UserModel?> _resolveLocalOrSeedProfile(String uid) async { // İlgili kod satırını ve işlemi yürütür
    final fromSqlite = await _getLocalCachedUser(uid); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (fromSqlite != null && fromSqlite.phone.trim().isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return fromSqlite; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır

    final seedMatch = // Sabit/final değişken veya nesne tanımını başlatır
        SeedData.predefinedUsers.where((u) => u.id == uid).firstOrNull; // İlgili kod satırını ve işlemi yürütür
    if (seedMatch != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      final consents = await _getVerifiedLocalConsents(uid); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      return seedMatch.copyWith( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
        id: uid, // id özelliğini yapılandırır
        firstName: fromSqlite?.firstName.isNotEmpty == true // İlgili kod satırını ve işlemi yürütür
            ? fromSqlite!.firstName // İlgili kod satırını ve işlemi yürütür
            : seedMatch.firstName, //  özelliğini yapılandırır
        lastName: fromSqlite?.lastName.isNotEmpty == true // İlgili kod satırını ve işlemi yürütür
            ? fromSqlite!.lastName // İlgili kod satırını ve işlemi yürütür
            : seedMatch.lastName, //  özelliğini yapılandırır
        email: fromSqlite?.email.isNotEmpty == true // İlgili kod satırını ve işlemi yürütür
            ? fromSqlite!.email // İlgili kod satırını ve işlemi yürütür
            : seedMatch.email, //  özelliğini yapılandırır
        phone: (fromSqlite?.phone.trim().isNotEmpty == true) // İlgili kod satırını ve işlemi yürütür
            ? fromSqlite!.phone.trim() // İlgili kod satırını ve işlemi yürütür
            : seedMatch.phone, //  özelliğini yapılandırır
        themeMode: fromSqlite?.themeMode ?? seedMatch.themeMode, // themeMode özelliğini yapılandırır
        createdAt: fromSqlite?.createdAt ?? seedMatch.createdAt, // createdAt özelliğini yapılandırır
        termsAccepted: consents.termsAccepted, // termsAccepted özelliğini yapılandırır
        kvkkAccepted: consents.kvkkAccepted, // kvkkAccepted özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    return fromSqlite; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<UserModel?> getCurrentUser() async { // İlgili kod satırını ve işlemi yürütür
    final auth = _firebaseAuth; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final firestore = _firestore; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (auth == null || firestore == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır

    final firebaseUser = auth.currentUser; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (firebaseUser == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      await prefs.remove(AppConstants.prefActiveUserIdKey); // Asenkron işlemin tamamlanmasını bekler
      return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır

    try { // Hata yakalama (try) bloğunu başlatır
      // Firestore kuralları gereği kullanıcı yalnızca kendi UID belgesini okuyabilir
      final doc = // Sabit/final değişken veya nesne tanımını başlatır
          await firestore.collection('users').doc(firebaseUser.uid).get(); // Firestore üzerindeki ilgili koleksiyona/belgeye referans alır
      if (doc.exists && doc.data() != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        final userModel = UserModel.fromFirestore( // Sabit/final değişken veya nesne tanımını başlatır
          doc.data()!, // İlgili kod satırını ve işlemi yürütür
          docId: firebaseUser.uid, // docId özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
        await _syncProfileToLocalCache(userModel); // Asenkron işlemin tamamlanmasını bekler
        await prefs.setString(AppConstants.prefActiveUserIdKey, userModel.id); // Asenkron işlemin tamamlanmasını bekler
        return userModel; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      } // Açık olan kod/bileşen bloğunu kapatır
    } catch (_) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      // Çevrimdışı durumda yerel önbellekten profil bilgisini oku
    } // Açık olan kod/bileşen bloğunu kapatır

    final cached = await _getLocalCachedUser(firebaseUser.uid); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (cached != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      await prefs.setString(AppConstants.prefActiveUserIdKey, cached.id); // Asenkron işlemin tamamlanmasını bekler
      return cached; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<UserModel?> getUserById(String userId) async { // İlgili kod satırını ve işlemi yürütür
    final firestore = _firestore; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final currentUid = _firebaseAuth?.currentUser?.uid; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    // Firestore `users/{uid}` güvenlik kuralı yalnızca kullanıcının kendi UID belgesini
    // okumasına (`allow get: if isOwner(uid)`) izin verir.
    if (firestore != null && currentUid != null && currentUid == userId) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      try { // Hata yakalama (try) bloğunu başlatır
        final doc = await firestore.collection('users').doc(userId).get(); // Firestore üzerindeki ilgili koleksiyona/belgeye referans alır
        if (doc.exists && doc.data() != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
          final user = UserModel.fromFirestore(doc.data()!, docId: userId); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
          await _syncProfileToLocalCache(user); // Asenkron işlemin tamamlanmasını bekler
          return user; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
        } // Açık olan kod/bileşen bloğunu kapatır
      } catch (_) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
        // Yerel önbelleğe düş
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    return _getLocalCachedUser(userId); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<UserModel> login({ // İlgili kod satırını ve işlemi yürütür
    required String identifier, // İlgili kod satırını ve işlemi yürütür
    required String password, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final trimmed = identifier.trim(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (trimmed.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'E-posta adresi boş bırakılamaz.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    if (password.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Şifre boş bırakılamaz.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır

    // Güvenli bir sunucu tarafı çözümü eklenene kadar telefon numarasıyla giriş devre dışıdır.
    if (!trimmed.contains('@') || Validators.isPhone(trimmed)) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Güvenlik nedeniyle telefon numarası ile giriş geçici olarak devre dışı bırakılmıştır. Lütfen e-posta adresiniz ve şifreniz ile giriş yapın.', // İlgili kod satırını ve işlemi yürütür
        code: 'phone-login-disabled', // code özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final emailErr = Validators.validateEmail(trimmed); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (emailErr != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw AppException(emailErr, code: 'invalid-email'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    final emailToSignIn = trimmed.toLowerCase(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    try { // Hata yakalama (try) bloğunu başlatır
      // 1. Şifre doğrulaması yalnızca Firebase Authentication sunucuları tarafından yapılır
      final credential = await _auth.signInWithEmailAndPassword( // Firebase Authentication üzerinden e-posta ve şifre ile oturum açar
        email: emailToSignIn, // email özelliğini yapılandırır
        password: password, // password özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır

      final firebaseUser = credential.user; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      if (firebaseUser == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException('Kullanıcı oturumu başlatılamadı.'); // İlgili hata nesnesini (Exception) fırlatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final uid = firebaseUser.uid; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      // 2. Oturum açıldığı için (`request.auth.uid == uid`) Firestore `isOwner(uid)` kuralı
      // kullanıcının kendi profil belgesini okumasına izin verir.
      final userDocRef = _db.collection('users').doc(uid); // Firestore üzerindeki ilgili koleksiyona/belgeye referans alır
      final userDoc = await userDocRef.get(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

      final UserModel userModel; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      if (userDoc.exists && userDoc.data() != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        // Firestore belgesi zaten mevcutsa tekrar oluşturulmaz; mevcut profil bilgileri korunur.
        final firestoreUser = UserModel.fromFirestore( // Sabit/final değişken veya nesne tanımını başlatır
          userDoc.data()!, // İlgili kod satırını ve işlemi yürütür
          docId: uid, // docId özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
        if (firestoreUser.phone.trim().isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
          final localFallback = await _resolveLocalOrSeedProfile(uid); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
          userModel = (localFallback != null && // İlgili kod satırını ve işlemi yürütür
                  localFallback.phone.trim().isNotEmpty) // İlgili kod satırını ve işlemi yürütür
              ? firestoreUser.copyWith(phone: localFallback.phone.trim()) // İlgili kod satırını ve işlemi yürütür
              : firestoreUser; // İlgili kod satırını ve işlemi yürütür
        } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
          userModel = firestoreUser; // İlgili kod satırını ve işlemi yürütür
        } // Açık olan kod/bileşen bloğunu kapatır
      } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
        // 3. Firestore `users/{uid}` belgesi yoksa:
        // Önce SQLite veya SeedData (`seed_user_1` .. `seed_user_10`) içerisindeki mevcut
        // kullanıcı profilini bul; ID, firstName, lastName, email, phone, createdAt ve themeMode
        // bilgilerini koru; phone alanını kesinlikle boş değerle ezme.
        final localProfile = await _resolveLocalOrSeedProfile(uid); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
        if (localProfile == null || localProfile.phone.trim().isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
          throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
            'Kullanıcıya ait geçerli bir profil veya telefon numarası bulunamadı.', // İlgili kod satırını ve işlemi yürütür
            code: 'profile-not-found', // code özelliğini yapılandırır
          ); // Açık olan kod/bileşen bloğunu kapatır
        } // Açık olan kod/bileşen bloğunu kapatır

        final normalizedPhone = Validators.normalizePhone(localProfile.phone); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
        final phoneErr = Validators.validatePhone(normalizedPhone); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
        if (phoneErr != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
          throw AppException(phoneErr, code: 'invalid-phone'); // İlgili hata nesnesini (Exception) fırlatır
        } // Açık olan kod/bileşen bloğunu kapatır

        final profileToSync = UserModel( // Sabit/final değişken veya nesne tanımını başlatır
          id: uid, // Kullanıcı ID'si ve SQLite eşleşmesi kesinlikle değiştirilmez
          firstName: localProfile.firstName.trim(), // firstName özelliğini yapılandırır
          lastName: localProfile.lastName.trim(), // lastName özelliğini yapılandırır
          email: localProfile.email.trim().isNotEmpty // İlgili kod satırını ve işlemi yürütür
              ? localProfile.email.trim().toLowerCase() // İlgili kod satırını ve işlemi yürütür
              : (firebaseUser.email ?? emailToSignIn).toLowerCase(), //  özelliğini yapılandırır
          phone: normalizedPhone, // phone özelliğini yapılandırır
          passwordHash: localProfile.passwordHash, // passwordHash özelliğini yapılandırır
          profileImage: localProfile.profileImage, // profileImage özelliğini yapılandırır
          themeMode: localProfile.themeMode, // themeMode özelliğini yapılandırır
          createdAt: localProfile.createdAt, // createdAt özelliğini yapılandırır
          // Yalnızca mevcut kayıt verisinde gerçekten onay varsa true yapılır
          termsAccepted: localProfile.termsAccepted, // termsAccepted özelliğini yapılandırır
          kvkkAccepted: localProfile.kvkkAccepted, // kvkkAccepted özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır

        final phoneDocRef = _db.collection('phone_lookup').doc(normalizedPhone); // Firestore üzerindeki ilgili koleksiyona/belgeye referans alır

        // 4. Firestore'da `users/{uid}` ve `phone_lookup/{phone}` belgelerini atomik transaction ile oluştur
        userModel = await _db.runTransaction<UserModel>((transaction) async { // Firestore üzerinde atomik (ya hep ya hiç) veritabanı işlemini başlatır
          final freshUserSnap = await transaction.get(userDocRef); // Atomik transaction içinde hedef Firestore belgesini okur
          if (freshUserSnap.exists && freshUserSnap.data() != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
            return UserModel.fromFirestore(freshUserSnap.data()!, docId: uid); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
          } // Açık olan kod/bileşen bloğunu kapatır

          final phoneSnap = await transaction.get(phoneDocRef); // Atomik transaction içinde hedef Firestore belgesini okur
          if (phoneSnap.exists && phoneSnap.data() != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
            final existingOwnerUid = phoneSnap.data()!['uid'] as String?; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
            if (existingOwnerUid != null && existingOwnerUid != uid) { // Koşulun sağlanıp sağlanmadığını kontrol eder
              throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
                'Bu telefon numarası başka bir kullanıcı hesabı tarafından kullanılmaktadır.', // İlgili kod satırını ve işlemi yürütür
                code: 'phone-already-in-use', // code özelliğini yapılandırır
              ); // Açık olan kod/bileşen bloğunu kapatır
            } // Açık olan kod/bileşen bloğunu kapatır
          } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
            transaction.set(phoneDocRef, { // Atomik transaction içinde hedef Firestore belgesine veri yazar
              'uid': uid, // 'uid' özelliğini yapılandırır
              'phone': normalizedPhone, // 'phone' özelliğini yapılandırır
              'createdAt': Timestamp.fromDate(profileToSync.createdAt), // 'createdAt' özelliğini yapılandırır
            }); // İlgili kod satırını ve işlemi yürütür
          } // Açık olan kod/bileşen bloğunu kapatır

          transaction.set(userDocRef, profileToSync.toFirestoreMap()); // Atomik transaction içinde hedef Firestore belgesine veri yazar
          return profileToSync; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
        }); // İlgili kod satırını ve işlemi yürütür
      } // Açık olan kod/bileşen bloğunu kapatır

      await _syncProfileToLocalCache(userModel); // Asenkron işlemin tamamlanmasını bekler
      await prefs.setString(AppConstants.prefActiveUserIdKey, userModel.id); // Asenkron işlemin tamamlanmasını bekler
      return userModel; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } on AppException { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      if (_firebaseAuth?.currentUser != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        await _firebaseAuth!.signOut(); // Aktif Firebase Authentication kullanıcı oturumunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
      await prefs.remove(AppConstants.prefActiveUserIdKey); // Asenkron işlemin tamamlanmasını bekler
      rethrow; // Yakalanan hatayı üst katmana yeniden fırlatır
    } on FirebaseAuthException catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      throw _mapFirebaseAuthException(e); // İlgili hata nesnesini (Exception) fırlatır
    } on FirebaseException catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      if (_firebaseAuth?.currentUser != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        await _firebaseAuth!.signOut(); // Aktif Firebase Authentication kullanıcı oturumunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
      await prefs.remove(AppConstants.prefActiveUserIdKey); // Asenkron işlemin tamamlanmasını bekler
      throw AppException( // İlgili hata nesnesini (Exception) fırlatır
        e.message ?? 'Firestore bağlantı hatası oluştu (${e.code}).', // İlgili kod satırını ve işlemi yürütür
        code: e.code, // code özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<UserModel> register({ // İlgili kod satırını ve işlemi yürütür
    required String firstName, // İlgili kod satırını ve işlemi yürütür
    required String lastName, // İlgili kod satırını ve işlemi yürütür
    required String email, // İlgili kod satırını ve işlemi yürütür
    required String phone, // İlgili kod satırını ve işlemi yürütür
    required String password, // İlgili kod satırını ve işlemi yürütür
    required bool acceptedUserAgreement, // İlgili kod satırını ve işlemi yürütür
    required bool acceptedKvkk, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    if (firstName.trim().isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Ad alanı zorunludur.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    if (lastName.trim().isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Soyad alanı zorunludur.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    final emailErr = Validators.validateEmail(email); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (emailErr != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw AppException(emailErr); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    final phoneErr = Validators.validatePhone(phone); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (phoneErr != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw AppException(phoneErr); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    if (password.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Şifre alanı zorunludur.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    if (password.length < 6) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Şifre en az 6 karakter olmalıdır.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    if (!acceptedUserAgreement) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Kayıt olabilmek için Kullanıcı Sözleşmesi\'ni onaylamalısınız.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    if (!acceptedKvkk) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Kayıt olabilmek için KVKK Aydınlatma Metni\'ni onaylamalısınız.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final normalizedEmail = email.trim().toLowerCase(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final normalizedPhone = Validators.normalizePhone(phone); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    UserCredential? credential; // İlgili kod satırını ve işlemi yürütür
    try { // Hata yakalama (try) bloğunu başlatır
      // 1. Önce Firebase Authentication üzerinde e-posta ve şifre ile kullanıcı oluştur.
      credential = await _auth.createUserWithEmailAndPassword( // Firebase Authentication üzerinde yeni e-posta ve şifre ile hesap oluşturur
        email: normalizedEmail, // email özelliğini yapılandırır
        password: password, // password özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır

      final firebaseUser = credential.user; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      if (firebaseUser == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException('Kullanıcı hesabı oluşturulamadı.'); // İlgili hata nesnesini (Exception) fırlatır
      } // Açık olan kod/bileşen bloğunu kapatır

      final uid = firebaseUser.uid; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final now = DateTime.now(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

      final newUser = UserModel( // Sabit/final değişken veya nesne tanımını başlatır
        id: uid, // id özelliğini yapılandırır
        firstName: firstName.trim(), // firstName özelliğini yapılandırır
        lastName: lastName.trim(), // lastName özelliğini yapılandırır
        email: normalizedEmail, // email özelliğini yapılandırır
        phone: normalizedPhone, // phone özelliğini yapılandırır
        passwordHash: '', // Şifre KESİNLİKLE Firestore'da tutulmaz
        themeMode: 'light', // themeMode özelliğini yapılandırır
        createdAt: now, // createdAt özelliğini yapılandırır
        termsAccepted: true, // termsAccepted özelliğini yapılandırır
        kvkkAccepted: true, // kvkkAccepted özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır

      // 2. Atomik Firestore Transaction (Oturum Açmış Kullanıcı Bağlamında):
      final phoneDocRef = _db.collection('phone_lookup').doc(normalizedPhone); // Firestore üzerindeki ilgili koleksiyona/belgeye referans alır
      final userDocRef = _db.collection('users').doc(uid); // Firestore üzerindeki ilgili koleksiyona/belgeye referans alır

      await _db.runTransaction((transaction) async { // Firestore üzerinde atomik (ya hep ya hiç) veritabanı işlemini başlatır
        final phoneSnapshot = await transaction.get(phoneDocRef); // Atomik transaction içinde hedef Firestore belgesini okur
        if (phoneSnapshot.exists) { // Koşulun sağlanıp sağlanmadığını kontrol eder
          throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
            'Bu telefon numarası başka bir hesapta zaten kayıtlı.', // İlgili kod satırını ve işlemi yürütür
            code: 'phone-already-in-use', // code özelliğini yapılandırır
          ); // Açık olan kod/bileşen bloğunu kapatır
        } // Açık olan kod/bileşen bloğunu kapatır

        transaction.set(phoneDocRef, { // Atomik transaction içinde hedef Firestore belgesine veri yazar
          'uid': uid, // 'uid' özelliğini yapılandırır
          'phone': normalizedPhone, // 'phone' özelliğini yapılandırır
          'createdAt': Timestamp.fromDate(now), // 'createdAt' özelliğini yapılandırır
        }); // İlgili kod satırını ve işlemi yürütür

        transaction.set(userDocRef, newUser.toFirestoreMap()); // Atomik transaction içinde hedef Firestore belgesine veri yazar
      }); // İlgili kod satırını ve işlemi yürütür

      await firebaseUser.updateDisplayName(newUser.fullName); // Asenkron işlemin tamamlanmasını bekler

      // 3. Yerel özelliklerle uyumluluk için şifresiz profil önbelleğini güncelle
      await _syncProfileToLocalCache(newUser); // Asenkron işlemin tamamlanmasını bekler

      // 4. Kayıt başarılı olduğunda kullanıcının giriş ekranına yönlendirilmesi ve
      // kendi bilgileriyle giriş yapması için geçici kayıt oturumunu kapat
      await _auth.signOut(); // Aktif Firebase Authentication kullanıcı oturumunu kapatır
      await prefs.remove(AppConstants.prefActiveUserIdKey); // Asenkron işlemin tamamlanmasını bekler

      return newUser; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } on AppException { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      if (credential?.user != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        try { // Hata yakalama (try) bloğunu başlatır
          await credential!.user!.delete(); // Veritabanındaki kaydı veya hesabı siler
        } catch (_) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
          await _auth.signOut(); // Aktif Firebase Authentication kullanıcı oturumunu kapatır
        } // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
      rethrow; // Yakalanan hatayı üst katmana yeniden fırlatır
    } on FirebaseAuthException catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      throw _mapFirebaseAuthException(e); // İlgili hata nesnesini (Exception) fırlatır
    } on FirebaseException catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      if (credential?.user != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        try { // Hata yakalama (try) bloğunu başlatır
          await credential!.user!.delete(); // Veritabanındaki kaydı veya hesabı siler
        } catch (_) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
          await _auth.signOut(); // Aktif Firebase Authentication kullanıcı oturumunu kapatır
        } // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
      if (e.code == 'permission-denied') { // Koşulun sağlanıp sağlanmadığını kontrol eder
        throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
          'Bu telefon numarası başka bir hesapta zaten kayıtlı veya Firestore yazma izni reddedildi.', // İlgili kod satırını ve işlemi yürütür
          code: 'permission-denied', // code özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
      throw AppException( // İlgili hata nesnesini (Exception) fırlatır
        e.message ?? 'Kayıt bilgileri Firestore\'a kaydedilirken hata oluştu.', // İlgili kod satırını ve işlemi yürütür
        code: e.code, // code özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<void> logout() async { // İlgili kod satırını ve işlemi yürütür
    if (_firebaseAuth != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      await _firebaseAuth.signOut(); // Aktif Firebase Authentication kullanıcı oturumunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    await prefs.remove(AppConstants.prefActiveUserIdKey); // Asenkron işlemin tamamlanmasını bekler
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<UserModel> updateThemeMode({ // İlgili kod satırını ve işlemi yürütür
    required String userId, // İlgili kod satırını ve işlemi yürütür
    required String themeMode, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final currentUid = _firebaseAuth?.currentUser?.uid; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    // Yalnızca oturum açmış kullanıcı kendi profil belgesini güncelleyebilir (`isOwner(uid)`)
    if (_firestore != null && currentUid != null && currentUid == userId) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      try { // Hata yakalama (try) bloğunu başlatır
        await _firestore.collection('users').doc(userId).update({ // Firestore üzerindeki ilgili koleksiyona/belgeye referans alır
          'themeMode': themeMode, // 'themeMode' özelliğini yapılandırır
        }); // İlgili kod satırını ve işlemi yürütür
      } catch (_) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
        // Çevrimdışı durumda yerel önbellek güncellenir
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final sqlite = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    await sqlite.update( // Veritabanındaki mevcut kaydı günceller
      'users', // İlgili kod satırını ve işlemi yürütür
      {'themeMode': themeMode}, // {'themeMode' özelliğini yapılandırır
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    final updated = await getUserById(userId); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (updated == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Kullanıcı bulunamadı.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    return updated.copyWith(themeMode: themeMode); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<List<UserModel>> getSuggestedPlayers(String currentUserId) async { // İlgili kod satırını ve işlemi yürütür
    final byId = <String, UserModel>{}; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    final sqlite = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final localRows = await sqlite.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id != ?', // where özelliğini yapılandırır
      whereArgs: [currentUserId], // whereArgs özelliğini yapılandırır
      orderBy: 'createdAt ASC', // orderBy özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    for (final row in localRows) { // Koleksiyon veya aralık üzerinde döngü başlatır
      final u = UserModel.fromMap(row); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      byId[u.id] = u; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    return byId.values.toList(); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
