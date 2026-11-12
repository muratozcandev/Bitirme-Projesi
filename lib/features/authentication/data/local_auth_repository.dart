import 'package:shared_preferences/shared_preferences.dart'; // Yerel anahtar-değer (SharedPreferences) depolama paketini içe aktarır
import 'package:uuid/uuid.dart'; // Benzersiz kimlik (UUID) üretici paketi içe aktarır
import '../../../core/constants/app_constants.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../core/errors/app_exception.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../core/utils/password_hasher.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../core/utils/validators.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../data/database/app_database.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/consent_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/user_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../domain/auth_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class LocalAuthRepository implements AuthRepository { // LocalAuthRepository veri erişim (repository) sınıfını tanımlar
  final AppDatabase appDatabase; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final SharedPreferences prefs; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Uuid _uuid = const Uuid(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  LocalAuthRepository({ // İlgili kod satırını ve işlemi yürütür
    required this.appDatabase, // appDatabase parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.prefs, // prefs parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<UserModel?> getCurrentUser() async { // İlgili kod satırını ve işlemi yürütür
    final activeId = prefs.getString(AppConstants.prefActiveUserIdKey); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (activeId == null || activeId.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return getUserById(activeId); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<UserModel?> getUserById(String userId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (rows.isEmpty) return null; // Koşulun sağlanıp sağlanmadığını kontrol eder
    final baseUser = UserModel.fromMap(rows.first); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return _attachConsents(db, baseUser); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<UserModel> _attachConsents( // İlgili kod satırını ve işlemi yürütür
    dynamic db, // İlgili kod satırını ve işlemi yürütür
    UserModel user, // İlgili kod satırını ve işlemi yürütür
  ) async { // İlgili kod satırını ve işlemi yürütür
    final consentRows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'consents', // İlgili kod satırını ve işlemi yürütür
      where: 'userId = ? AND accepted = 1', // where özelliğini yapılandırır
      whereArgs: [user.id], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final hasTerms = // Sabit/final değişken veya nesne tanımını başlatır
        consentRows.any((r) => r['documentType'] == 'user_agreement'); // İlgili kod satırını ve işlemi yürütür
    final hasKvkk = consentRows.any((r) => r['documentType'] == 'kvkk'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return user.copyWith( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      termsAccepted: hasTerms, // termsAccepted özelliğini yapılandırır
      kvkkAccepted: hasKvkk, // kvkkAccepted özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<UserModel> login({ // İlgili kod satırını ve işlemi yürütür
    required String identifier, // İlgili kod satırını ve işlemi yürütür
    required String password, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final trimmed = identifier.trim(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (trimmed.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('E-posta veya telefon numarası boş bırakılamaz.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    if (password.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Şifre boş bırakılamaz.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    List<Map<String, Object?>> rows; // İlgili kod satırını ve işlemi yürütür

    if (trimmed.contains('@')) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'users', // İlgili kod satırını ve işlemi yürütür
        where: 'LOWER(email) = ?', // where özelliğini yapılandırır
        whereArgs: [trimmed.toLowerCase()], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
      final normalizedPhone = Validators.normalizePhone(trimmed); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
        'users', // İlgili kod satırını ve işlemi yürütür
        where: 'phone = ? OR phone = ?', // where özelliğini yapılandırır
        whereArgs: [normalizedPhone, trimmed], // whereArgs özelliğini yapılandırır
        limit: 1, // limit özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    if (rows.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Girdiğiniz bilgilere ait bir kullanıcı hesabı bulunamadı.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final baseUser = UserModel.fromMap(rows.first); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (!PasswordHasher.verify(password, baseUser.passwordHash)) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Hatalı şifre girdiniz. Lütfen tekrar deneyin.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final user = await _attachConsents(db, baseUser); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    await prefs.setString(AppConstants.prefActiveUserIdKey, user.id); // Asenkron işlemin tamamlanmasını bekler
    return user; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
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
    if (firstName.trim().isEmpty || lastName.trim().isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Ad ve soyad alanları zorunludur.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    final emailErr = Validators.validateEmail(email); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (emailErr != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw AppException(emailErr); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    final phoneErr = Validators.validatePhone(phone); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (phoneErr != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw AppException(phoneErr); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    final passErr = Validators.validatePassword(password); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (passErr != null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw AppException(passErr); // İlgili hata nesnesini (Exception) fırlatır
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

    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    final existingEmail = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'LOWER(email) = ?', // where özelliğini yapılandırır
      whereArgs: [normalizedEmail], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (existingEmail.isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Bu e-posta adresi başka bir hesapta zaten kayıtlı.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final existingPhone = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'phone = ?', // where özelliğini yapılandırır
      whereArgs: [normalizedPhone], // whereArgs özelliğini yapılandırır
      limit: 1, // limit özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (existingPhone.isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException( // İlgili hata nesnesini (Exception) fırlatır
        'Bu telefon numarası başka bir hesapta zaten kayıtlı.', // İlgili kod satırını ve işlemi yürütür
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    final now = DateTime.now(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final user = UserModel( // Sabit/final değişken veya nesne tanımını başlatır
      id: _uuid.v4(), // id özelliğini yapılandırır
      firstName: firstName.trim(), // firstName özelliğini yapılandırır
      lastName: lastName.trim(), // lastName özelliğini yapılandırır
      email: normalizedEmail, // email özelliğini yapılandırır
      phone: normalizedPhone, // phone özelliğini yapılandırır
      passwordHash: PasswordHasher.hash(password), // passwordHash özelliğini yapılandırır
      themeMode: 'light', // themeMode özelliğini yapılandırır
      createdAt: now, // createdAt özelliğini yapılandırır
      termsAccepted: true, // termsAccepted özelliğini yapılandırır
      kvkkAccepted: true, // kvkkAccepted özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır

    await db.transaction((txn) async { // Asenkron işlemin tamamlanmasını bekler
      await txn.insert('users', user.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler

      final userAgreementConsent = ConsentModel( // Sabit/final değişken veya nesne tanımını başlatır
        id: _uuid.v4(), // id özelliğini yapılandırır
        userId: user.id, // userId özelliğini yapılandırır
        documentType: 'user_agreement', // documentType özelliğini yapılandırır
        documentVersion: '1.0', // documentVersion özelliğini yapılandırır
        accepted: true, // accepted özelliğini yapılandırır
        acceptedAt: now, // acceptedAt özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır

      final kvkkConsent = ConsentModel( // Sabit/final değişken veya nesne tanımını başlatır
        id: _uuid.v4(), // id özelliğini yapılandırır
        userId: user.id, // userId özelliğini yapılandırır
        documentType: 'kvkk', // documentType özelliğini yapılandırır
        documentVersion: '1.0', // documentVersion özelliğini yapılandırır
        accepted: true, // accepted özelliğini yapılandırır
        acceptedAt: now, // acceptedAt özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır

      await txn.insert('consents', userAgreementConsent.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler
      await txn.insert('consents', kvkkConsent.toMap()); // SQLite veritabanı tablosuna yeni kayıt ekler
    }); // İlgili kod satırını ve işlemi yürütür

    return user; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<void> logout() async { // İlgili kod satırını ve işlemi yürütür
    await prefs.remove(AppConstants.prefActiveUserIdKey); // Asenkron işlemin tamamlanmasını bekler
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<UserModel> updateThemeMode({ // İlgili kod satırını ve işlemi yürütür
    required String userId, // İlgili kod satırını ve işlemi yürütür
    required String themeMode, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    await db.update( // Veritabanındaki mevcut kaydı günceller
      'users', // İlgili kod satırını ve işlemi yürütür
      {'themeMode': themeMode}, // {'themeMode' özelliğini yapılandırır
      where: 'id = ?', // where özelliğini yapılandırır
      whereArgs: [userId], // whereArgs özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    final updated = await getUserById(userId); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (updated == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      throw const AppException('Kullanıcı bulunamadı.'); // İlgili hata nesnesini (Exception) fırlatır
    } // Açık olan kod/bileşen bloğunu kapatır
    return updated; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Future<List<UserModel>> getSuggestedPlayers(String currentUserId) async { // İlgili kod satırını ve işlemi yürütür
    final db = await appDatabase.database; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final rows = await db.query( // SQLite veritabanı tablosundan koşullu veri sorgular
      'users', // İlgili kod satırını ve işlemi yürütür
      where: 'id != ?', // where özelliğini yapılandırır
      whereArgs: [currentUserId], // whereArgs özelliğini yapılandırır
      orderBy: 'createdAt ASC', // orderBy özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    return rows.map(UserModel.fromMap).toList(); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
