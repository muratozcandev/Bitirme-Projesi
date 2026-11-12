import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/validators.dart';
import '../../../data/database/app_database.dart';
import '../../../data/seed/seed_data.dart';
import '../../../shared/models/user_model.dart';
import '../domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth? _firebaseAuth;
  final FirebaseFirestore? _firestore;
  final AppDatabase appDatabase;
  final SharedPreferences prefs;

  FirebaseAuthRepository({
    required FirebaseAuth? firebaseAuth,
    required FirebaseFirestore? firestore,
    required this.appDatabase,
    required this.prefs,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  FirebaseAuth get _auth {
    final instance = _firebaseAuth;
    if (instance == null) {
      throw const AppException(
        'Firebase Authentication servisi başlatılamadı. Lütfen bağlantınızı kontrol edin.',
      );
    }
    return instance;
  }

  FirebaseFirestore get _db {
    final instance = _firestore;
    if (instance == null) {
      throw const AppException(
        'Cloud Firestore servisi başlatılamadı. Lütfen bağlantınızı kontrol edin.',
      );
    }
    return instance;
  }

  /// Firebase Auth hatalarını anlaşılır Türkçe mesajlara dönüştürür
  AppException _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return const AppException(
          'Bu e-posta adresi başka bir hesapta zaten kayıtlı.',
          code: 'email-already-in-use',
        );
      case 'invalid-email':
        return const AppException(
          'Geçersiz e-posta adresi formatı.',
          code: 'invalid-email',
        );
      case 'weak-password':
        return const AppException(
          'Şifre çok zayıf. Lütfen en az 6 karakterli bir şifre belirleyin.',
          code: 'weak-password',
        );
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return const AppException(
          'E-posta adresi veya şifre hatalı. Lütfen bilgilerinizi kontrol edin.',
          code: 'invalid-credential',
        );
      case 'user-disabled':
        return const AppException(
          'Bu kullanıcı hesabı devre dışı bırakılmış.',
          code: 'user-disabled',
        );
      case 'too-many-requests':
        return const AppException(
          'Çok fazla başarısız deneme yapıldı. Lütfen biraz bekleyip tekrar deneyin.',
          code: 'too-many-requests',
        );
      case 'network-request-failed':
        return const AppException(
          'İnternet bağlantısı kurulamadı. Lütfen ağ bağlantınızı kontrol edin.',
          code: 'network-request-failed',
        );
      case 'operation-not-allowed':
        return const AppException(
          'E-posta/Şifre ile giriş yöntemi Firebase Console üzerinde etkinleştirilmemiş.',
          code: 'operation-not-allowed',
        );
      default:
        return AppException(
          e.message ??
              'Kimlik doğrulama işlemi sırasında bir hata oluştu (${e.code}).',
          code: e.code,
        );
    }
  }

  /// Yerel özelliklerin (Takım Kurma, Randevular, Sohbet, Bildirimler) kullanıcı adını
  /// ve profilini çözebilmesi için şifresiz profil önbelleğini SQLite ile senkronize eder.
  /// Mevcut SQLite kaydındaki telefon numarasını asla boş değerle ezmez ve kullanıcı ID'sini değiştirmez.
  Future<void> _syncProfileToLocalCache(UserModel user) async {
    final sqlite = await appDatabase.database;
    final existingRows = await sqlite.query(
      'users',
      where: 'id = ?',
      whereArgs: [user.id],
      limit: 1,
    );

    final existingRow = existingRows.isNotEmpty ? existingRows.first : null;
    final existingPhone = (existingRow?['phone'] as String?)?.trim() ?? '';
    final existingPasswordHash =
        (existingRow?['passwordHash'] as String?)?.trim() ?? '';

    final resolvedPhone =
        user.phone.trim().isNotEmpty ? user.phone.trim() : existingPhone;
    // SQLite `users.phone` sütunu UNIQUE olduğu için telefon bilgisi olmayan harici Auth
    // hesaplarının birbirini ezmemesi adına benzersiz yer tutucu kullanılır.
    final sqliteSafePhone =
        resolvedPhone.isNotEmpty ? resolvedPhone : 'UNSET_${user.id}';
    final resolvedPasswordHash = existingPasswordHash.isNotEmpty &&
            existingPasswordHash != 'FIREBASE_AUTH_MANAGED'
        ? existingPasswordHash
        : 'FIREBASE_AUTH_MANAGED';

    await sqlite.insert(
      'users',
      {
        'id': user.id,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'email': user.email.toLowerCase().trim(),
        'phone': sqliteSafePhone,
        'passwordHash': resolvedPasswordHash,
        'profileImage': user.profileImage ?? existingRow?['profileImage'],
        'themeMode': user.themeMode,
        'createdAt': user.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// SQLite `consents` tablosunda kullanıcının gerçek onay kaydı olup olmadığını denetler.
  /// Yalnızca gerçekten onay verilmişse (`accepted = 1`) true döndürür;
  /// eski test hesaplarında (`seed_user_1` .. `seed_user_10`) gerçek kullanıcı onayı yoksa false döner.
  Future<({bool termsAccepted, bool kvkkAccepted})> _getVerifiedLocalConsents(
    String userId,
  ) async {
    final sqlite = await appDatabase.database;
    final rows = await sqlite.query(
      'consents',
      where: 'userId = ? AND accepted = 1',
      whereArgs: [userId],
    );
    final hasTerms = rows.any((r) => r['documentType'] == 'user_agreement');
    final hasKvkk = rows.any((r) => r['documentType'] == 'kvkk');
    return (termsAccepted: hasTerms, kvkkAccepted: hasKvkk);
  }

  Future<UserModel?> _getLocalCachedUser(String userId) async {
    final sqlite = await appDatabase.database;
    final rows = await sqlite.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    final baseUser = UserModel.fromMap(rows.first);
    final sanitizedPhone =
        baseUser.phone.startsWith('UNSET_') ? '' : baseUser.phone;
    final consents = await _getVerifiedLocalConsents(userId);
    return baseUser.copyWith(
      phone: sanitizedPhone,
      termsAccepted: consents.termsAccepted,
      kvkkAccepted: consents.kvkkAccepted,
    );
  }

  /// Firestore `users/{uid}` belgesi henüz bulunmayan bir kullanıcı için
  /// önce SQLite `users` tablosundan, eğer UID `seed_user_1` .. `seed_user_10` arasındaysa
  /// `SeedData.predefinedUsers` içerisinden mevcut profil bilgilerini (ID eşleşmesini bozmadan) çözer.
  Future<UserModel?> _resolveLocalOrSeedProfile(String uid) async {
    final fromSqlite = await _getLocalCachedUser(uid);
    if (fromSqlite != null && fromSqlite.phone.trim().isNotEmpty) {
      return fromSqlite;
    }

    final seedMatch =
        SeedData.predefinedUsers.where((u) => u.id == uid).firstOrNull;
    if (seedMatch != null) {
      final consents = await _getVerifiedLocalConsents(uid);
      return seedMatch.copyWith(
        id: uid,
        firstName: fromSqlite?.firstName.isNotEmpty == true
            ? fromSqlite!.firstName
            : seedMatch.firstName,
        lastName: fromSqlite?.lastName.isNotEmpty == true
            ? fromSqlite!.lastName
            : seedMatch.lastName,
        email: fromSqlite?.email.isNotEmpty == true
            ? fromSqlite!.email
            : seedMatch.email,
        phone: (fromSqlite?.phone.trim().isNotEmpty == true)
            ? fromSqlite!.phone.trim()
            : seedMatch.phone,
        themeMode: fromSqlite?.themeMode ?? seedMatch.themeMode,
        createdAt: fromSqlite?.createdAt ?? seedMatch.createdAt,
        termsAccepted: consents.termsAccepted,
        kvkkAccepted: consents.kvkkAccepted,
      );
    }

    return fromSqlite;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final auth = _firebaseAuth;
    final firestore = _firestore;
    if (auth == null || firestore == null) {
      return null;
    }

    final firebaseUser = auth.currentUser;
    if (firebaseUser == null) {
      await prefs.remove(AppConstants.prefActiveUserIdKey);
      return null;
    }

    try {
      // Firestore kuralları gereği kullanıcı yalnızca kendi UID belgesini okuyabilir
      final doc =
          await firestore.collection('users').doc(firebaseUser.uid).get();
      if (doc.exists && doc.data() != null) {
        final userModel = UserModel.fromFirestore(
          doc.data()!,
          docId: firebaseUser.uid,
        );
        await _syncProfileToLocalCache(userModel);
        await prefs.setString(AppConstants.prefActiveUserIdKey, userModel.id);
        return userModel;
      }
    } catch (_) {
      // Çevrimdışı durumda yerel önbellekten profil bilgisini oku
    }

    final cached = await _getLocalCachedUser(firebaseUser.uid);
    if (cached != null) {
      await prefs.setString(AppConstants.prefActiveUserIdKey, cached.id);
      return cached;
    }
    return null;
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    final firestore = _firestore;
    final currentUid = _firebaseAuth?.currentUser?.uid;
    // Firestore `users/{uid}` güvenlik kuralı yalnızca kullanıcının kendi UID belgesini
    // okumasına (`allow get: if isOwner(uid)`) izin verir.
    if (firestore != null && currentUid != null && currentUid == userId) {
      try {
        final doc = await firestore.collection('users').doc(userId).get();
        if (doc.exists && doc.data() != null) {
          final user = UserModel.fromFirestore(doc.data()!, docId: userId);
          await _syncProfileToLocalCache(user);
          return user;
        }
      } catch (_) {
        // Yerel önbelleğe düş
      }
    }
    return _getLocalCachedUser(userId);
  }

  @override
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    final trimmed = identifier.trim();
    if (trimmed.isEmpty) {
      throw const AppException(
        'E-posta adresi boş bırakılamaz.',
      );
    }
    if (password.isEmpty) {
      throw const AppException('Şifre boş bırakılamaz.');
    }

    // Güvenli bir sunucu tarafı çözümü eklenene kadar telefon numarasıyla giriş devre dışıdır.
    if (!trimmed.contains('@') || Validators.isPhone(trimmed)) {
      throw const AppException(
        'Güvenlik nedeniyle telefon numarası ile giriş geçici olarak devre dışı bırakılmıştır. Lütfen e-posta adresiniz ve şifreniz ile giriş yapın.',
        code: 'phone-login-disabled',
      );
    }

    final emailErr = Validators.validateEmail(trimmed);
    if (emailErr != null) {
      throw AppException(emailErr, code: 'invalid-email');
    }
    final emailToSignIn = trimmed.toLowerCase();

    try {
      // 1. Şifre doğrulaması yalnızca Firebase Authentication sunucuları tarafından yapılır
      final credential = await _auth.signInWithEmailAndPassword(
        email: emailToSignIn,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AppException('Kullanıcı oturumu başlatılamadı.');
      }

      final uid = firebaseUser.uid;
      // 2. Oturum açıldığı için (`request.auth.uid == uid`) Firestore `isOwner(uid)` kuralı
      // kullanıcının kendi profil belgesini okumasına izin verir.
      final userDocRef = _db.collection('users').doc(uid);
      final userDoc = await userDocRef.get();

      final UserModel userModel;
      if (userDoc.exists && userDoc.data() != null) {
        // Firestore belgesi zaten mevcutsa tekrar oluşturulmaz; mevcut profil bilgileri korunur.
        final firestoreUser = UserModel.fromFirestore(
          userDoc.data()!,
          docId: uid,
        );
        if (firestoreUser.phone.trim().isEmpty) {
          final localFallback = await _resolveLocalOrSeedProfile(uid);
          userModel = (localFallback != null &&
                  localFallback.phone.trim().isNotEmpty)
              ? firestoreUser.copyWith(phone: localFallback.phone.trim())
              : firestoreUser;
        } else {
          userModel = firestoreUser;
        }
      } else {
        // 3. Firestore `users/{uid}` belgesi yoksa:
        // Önce SQLite veya SeedData (`seed_user_1` .. `seed_user_10`) içerisindeki mevcut
        // kullanıcı profilini bul; ID, firstName, lastName, email, phone, createdAt ve themeMode
        // bilgilerini koru; phone alanını kesinlikle boş değerle ezme.
        final localProfile = await _resolveLocalOrSeedProfile(uid);
        if (localProfile == null || localProfile.phone.trim().isEmpty) {
          throw const AppException(
            'Kullanıcıya ait geçerli bir profil veya telefon numarası bulunamadı.',
            code: 'profile-not-found',
          );
        }

        final normalizedPhone = Validators.normalizePhone(localProfile.phone);
        final phoneErr = Validators.validatePhone(normalizedPhone);
        if (phoneErr != null) {
          throw AppException(phoneErr, code: 'invalid-phone');
        }

        final profileToSync = UserModel(
          id: uid, // Kullanıcı ID'si ve SQLite eşleşmesi kesinlikle değiştirilmez
          firstName: localProfile.firstName.trim(),
          lastName: localProfile.lastName.trim(),
          email: localProfile.email.trim().isNotEmpty
              ? localProfile.email.trim().toLowerCase()
              : (firebaseUser.email ?? emailToSignIn).toLowerCase(),
          phone: normalizedPhone,
          passwordHash: localProfile.passwordHash,
          profileImage: localProfile.profileImage,
          themeMode: localProfile.themeMode,
          createdAt: localProfile.createdAt,
          // Yalnızca mevcut kayıt verisinde gerçekten onay varsa true yapılır
          termsAccepted: localProfile.termsAccepted,
          kvkkAccepted: localProfile.kvkkAccepted,
        );

        final phoneDocRef = _db.collection('phone_lookup').doc(normalizedPhone);

        // 4. Firestore'da `users/{uid}` ve `phone_lookup/{phone}` belgelerini atomik transaction ile oluştur
        userModel = await _db.runTransaction<UserModel>((transaction) async {
          final freshUserSnap = await transaction.get(userDocRef);
          if (freshUserSnap.exists && freshUserSnap.data() != null) {
            return UserModel.fromFirestore(freshUserSnap.data()!, docId: uid);
          }

          final phoneSnap = await transaction.get(phoneDocRef);
          if (phoneSnap.exists && phoneSnap.data() != null) {
            final existingOwnerUid = phoneSnap.data()!['uid'] as String?;
            if (existingOwnerUid != null && existingOwnerUid != uid) {
              throw const AppException(
                'Bu telefon numarası başka bir kullanıcı hesabı tarafından kullanılmaktadır.',
                code: 'phone-already-in-use',
              );
            }
          } else {
            transaction.set(phoneDocRef, {
              'uid': uid,
              'phone': normalizedPhone,
              'createdAt': Timestamp.fromDate(profileToSync.createdAt),
            });
          }

          transaction.set(userDocRef, profileToSync.toFirestoreMap());
          return profileToSync;
        });
      }

      await _syncProfileToLocalCache(userModel);
      await prefs.setString(AppConstants.prefActiveUserIdKey, userModel.id);
      return userModel;
    } on AppException {
      if (_firebaseAuth?.currentUser != null) {
        await _firebaseAuth!.signOut();
      }
      await prefs.remove(AppConstants.prefActiveUserIdKey);
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      if (_firebaseAuth?.currentUser != null) {
        await _firebaseAuth!.signOut();
      }
      await prefs.remove(AppConstants.prefActiveUserIdKey);
      throw AppException(
        e.message ?? 'Firestore bağlantı hatası oluştu (${e.code}).',
        code: e.code,
      );
    }
  }

  @override
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required bool acceptedUserAgreement,
    required bool acceptedKvkk,
  }) async {
    if (firstName.trim().isEmpty) {
      throw const AppException('Ad alanı zorunludur.');
    }
    if (lastName.trim().isEmpty) {
      throw const AppException('Soyad alanı zorunludur.');
    }
    final emailErr = Validators.validateEmail(email);
    if (emailErr != null) {
      throw AppException(emailErr);
    }
    final phoneErr = Validators.validatePhone(phone);
    if (phoneErr != null) {
      throw AppException(phoneErr);
    }
    if (password.isEmpty) {
      throw const AppException('Şifre alanı zorunludur.');
    }
    if (password.length < 6) {
      throw const AppException('Şifre en az 6 karakter olmalıdır.');
    }
    if (!acceptedUserAgreement) {
      throw const AppException(
        'Kayıt olabilmek için Kullanıcı Sözleşmesi\'ni onaylamalısınız.',
      );
    }
    if (!acceptedKvkk) {
      throw const AppException(
        'Kayıt olabilmek için KVKK Aydınlatma Metni\'ni onaylamalısınız.',
      );
    }

    final normalizedEmail = email.trim().toLowerCase();
    final normalizedPhone = Validators.normalizePhone(phone);

    UserCredential? credential;
    try {
      // 1. Önce Firebase Authentication üzerinde e-posta ve şifre ile kullanıcı oluştur.
      credential = await _auth.createUserWithEmailAndPassword(
        email: normalizedEmail,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw const AppException('Kullanıcı hesabı oluşturulamadı.');
      }

      final uid = firebaseUser.uid;
      final now = DateTime.now();

      final newUser = UserModel(
        id: uid,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        email: normalizedEmail,
        phone: normalizedPhone,
        passwordHash: '', // Şifre KESİNLİKLE Firestore'da tutulmaz
        themeMode: 'light',
        createdAt: now,
        termsAccepted: true,
        kvkkAccepted: true,
      );

      // 2. Atomik Firestore Transaction (Oturum Açmış Kullanıcı Bağlamında):
      final phoneDocRef = _db.collection('phone_lookup').doc(normalizedPhone);
      final userDocRef = _db.collection('users').doc(uid);

      await _db.runTransaction((transaction) async {
        final phoneSnapshot = await transaction.get(phoneDocRef);
        if (phoneSnapshot.exists) {
          throw const AppException(
            'Bu telefon numarası başka bir hesapta zaten kayıtlı.',
            code: 'phone-already-in-use',
          );
        }

        transaction.set(phoneDocRef, {
          'uid': uid,
          'phone': normalizedPhone,
          'createdAt': Timestamp.fromDate(now),
        });

        transaction.set(userDocRef, newUser.toFirestoreMap());
      });

      await firebaseUser.updateDisplayName(newUser.fullName);

      // 3. Yerel özelliklerle uyumluluk için şifresiz profil önbelleğini güncelle
      await _syncProfileToLocalCache(newUser);

      // 4. Kayıt başarılı olduğunda kullanıcının giriş ekranına yönlendirilmesi ve
      // kendi bilgileriyle giriş yapması için geçici kayıt oturumunu kapat
      await _auth.signOut();
      await prefs.remove(AppConstants.prefActiveUserIdKey);

      return newUser;
    } on AppException {
      if (credential?.user != null) {
        try {
          await credential!.user!.delete();
        } catch (_) {
          await _auth.signOut();
        }
      }
      rethrow;
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      if (credential?.user != null) {
        try {
          await credential!.user!.delete();
        } catch (_) {
          await _auth.signOut();
        }
      }
      if (e.code == 'permission-denied') {
        throw const AppException(
          'Bu telefon numarası başka bir hesapta zaten kayıtlı veya Firestore yazma izni reddedildi.',
          code: 'permission-denied',
        );
      }
      throw AppException(
        e.message ?? 'Kayıt bilgileri Firestore\'a kaydedilirken hata oluştu.',
        code: e.code,
      );
    }
  }

  @override
  Future<void> logout() async {
    if (_firebaseAuth != null) {
      await _firebaseAuth.signOut();
    }
    await prefs.remove(AppConstants.prefActiveUserIdKey);
  }

  @override
  Future<UserModel> updateThemeMode({
    required String userId,
    required String themeMode,
  }) async {
    final currentUid = _firebaseAuth?.currentUser?.uid;
    // Yalnızca oturum açmış kullanıcı kendi profil belgesini güncelleyebilir (`isOwner(uid)`)
    if (_firestore != null && currentUid != null && currentUid == userId) {
      try {
        await _firestore.collection('users').doc(userId).update({
          'themeMode': themeMode,
        });
      } catch (_) {
        // Çevrimdışı durumda yerel önbellek güncellenir
      }
    }

    final sqlite = await appDatabase.database;
    await sqlite.update(
      'users',
      {'themeMode': themeMode},
      where: 'id = ?',
      whereArgs: [userId],
    );

    final updated = await getUserById(userId);
    if (updated == null) {
      throw const AppException('Kullanıcı bulunamadı.');
    }
    return updated.copyWith(themeMode: themeMode);
  }

  @override
  Future<List<UserModel>> getSuggestedPlayers(String currentUserId) async {
    final byId = <String, UserModel>{};

    final sqlite = await appDatabase.database;
    final localRows = await sqlite.query(
      'users',
      where: 'id != ?',
      whereArgs: [currentUserId],
      orderBy: 'createdAt ASC',
    );
    for (final row in localRows) {
      final u = UserModel.fromMap(row);
      byId[u.id] = u;
    }

    return byId.values.toList();
  }
}
