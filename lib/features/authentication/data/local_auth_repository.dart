import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/password_hasher.dart';
import '../../../core/utils/validators.dart';
import '../../../data/database/app_database.dart';
import '../../../shared/models/consent_model.dart';
import '../../../shared/models/user_model.dart';
import '../domain/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  final AppDatabase appDatabase;
  final SharedPreferences prefs;
  final Uuid _uuid = const Uuid();

  LocalAuthRepository({
    required this.appDatabase,
    required this.prefs,
  });

  @override
  Future<UserModel?> getCurrentUser() async {
    final activeId = prefs.getString(AppConstants.prefActiveUserIdKey);
    if (activeId == null || activeId.isEmpty) {
      return null;
    }
    return getUserById(activeId);
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserModel.fromMap(rows.first);
  }

  @override
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    final trimmed = identifier.trim();
    if (trimmed.isEmpty) {
      throw const AppException('E-posta veya telefon numarası boş bırakılamaz.');
    }
    if (password.isEmpty) {
      throw const AppException('Şifre boş bırakılamaz.');
    }

    final db = await appDatabase.database;
    List<Map<String, Object?>> rows;

    if (trimmed.contains('@')) {
      rows = await db.query(
        'users',
        where: 'LOWER(email) = ?',
        whereArgs: [trimmed.toLowerCase()],
        limit: 1,
      );
    } else {
      final normalizedPhone = Validators.normalizePhone(trimmed);
      rows = await db.query(
        'users',
        where: 'phone = ? OR phone = ?',
        whereArgs: [normalizedPhone, trimmed],
        limit: 1,
      );
    }

    if (rows.isEmpty) {
      throw const AppException(
        'Girdiğiniz bilgilere ait bir kullanıcı hesabı bulunamadı.',
      );
    }

    final user = UserModel.fromMap(rows.first);
    if (!PasswordHasher.verify(password, user.passwordHash)) {
      throw const AppException('Hatalı şifre girdiniz. Lütfen tekrar deneyin.');
    }

    await prefs.setString(AppConstants.prefActiveUserIdKey, user.id);
    return user;
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
    if (firstName.trim().isEmpty || lastName.trim().isEmpty) {
      throw const AppException('Ad ve soyad alanları zorunludur.');
    }
    final emailErr = Validators.validateEmail(email);
    if (emailErr != null) {
      throw AppException(emailErr);
    }
    final phoneErr = Validators.validatePhone(phone);
    if (phoneErr != null) {
      throw AppException(phoneErr);
    }
    final passErr = Validators.validatePassword(password);
    if (passErr != null) {
      throw AppException(passErr);
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

    final db = await appDatabase.database;

    final existingEmail = await db.query(
      'users',
      where: 'LOWER(email) = ?',
      whereArgs: [normalizedEmail],
      limit: 1,
    );
    if (existingEmail.isNotEmpty) {
      throw const AppException(
        'Bu e-posta adresi başka bir hesapta zaten kayıtlı.',
      );
    }

    final existingPhone = await db.query(
      'users',
      where: 'phone = ?',
      whereArgs: [normalizedPhone],
      limit: 1,
    );
    if (existingPhone.isNotEmpty) {
      throw const AppException(
        'Bu telefon numarası başka bir hesapta zaten kayıtlı.',
      );
    }

    final now = DateTime.now();
    final user = UserModel(
      id: _uuid.v4(),
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      email: normalizedEmail,
      phone: normalizedPhone,
      passwordHash: PasswordHasher.hash(password),
      themeMode: 'light',
      createdAt: now,
    );

    await db.transaction((txn) async {
      await txn.insert('users', user.toMap());

      final userAgreementConsent = ConsentModel(
        id: _uuid.v4(),
        userId: user.id,
        documentType: 'user_agreement',
        documentVersion: '1.0',
        accepted: true,
        acceptedAt: now,
      );

      final kvkkConsent = ConsentModel(
        id: _uuid.v4(),
        userId: user.id,
        documentType: 'kvkk',
        documentVersion: '1.0',
        accepted: true,
        acceptedAt: now,
      );

      await txn.insert('consents', userAgreementConsent.toMap());
      await txn.insert('consents', kvkkConsent.toMap());
    });

    return user;
  }

  @override
  Future<void> logout() async {
    await prefs.remove(AppConstants.prefActiveUserIdKey);
  }

  @override
  Future<UserModel> updateThemeMode({
    required String userId,
    required String themeMode,
  }) async {
    final db = await appDatabase.database;
    await db.update(
      'users',
      {'themeMode': themeMode},
      where: 'id = ?',
      whereArgs: [userId],
    );
    final updated = await getUserById(userId);
    if (updated == null) {
      throw const AppException('Kullanıcı bulunamadı.');
    }
    return updated;
  }

  @override
  Future<List<UserModel>> getSuggestedPlayers(String currentUserId) async {
    final db = await appDatabase.database;
    final rows = await db.query(
      'users',
      where: 'id != ?',
      whereArgs: [currentUserId],
      orderBy: 'createdAt ASC',
    );
    return rows.map(UserModel.fromMap).toList();
  }
}
