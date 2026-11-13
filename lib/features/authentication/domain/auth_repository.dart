// Kimlik doğrulama ve kullanıcı oturum işlemleri için soyut arayüzü (interface) tanımlar.

import '../../../shared/models/user_model.dart';

/// Kimlik doğrulama, oturum yönetimi, kullanıcı kaydı ve profil
/// işlemlerini soyutlayan depo sözleşmesi (repository interface).
abstract class AuthRepository {
  /// Mevcut oturum açmış kullanıcıyı döndürür; oturum yoksa null döner.
  Future<UserModel?> getCurrentUser();

  /// E-posta veya telefon ile şifre doğrulaması yaparak giriş yapar.
  Future<UserModel> login({
    required String identifier,
    required String password,
  });

  /// Gerekli kişisel bilgiler ve yasal sözleşme onayları ile yeni kullanıcı kaydeder.
  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required bool acceptedUserAgreement,
    required bool acceptedKvkk,
  });

  /// Açık olan kullanıcı oturumunu sonlandırır.
  Future<void> logout();

  /// Kullanıcının açık veya koyu tema tercihini günceller ve güncel modeli döndürür.
  Future<UserModel> updateThemeMode({
    required String userId,
    required String themeMode,
  });

  /// Takıma davet edilebilecek diğer kayıtlı oyuncu listesini döndürür.
  Future<List<UserModel>> getSuggestedPlayers(String currentUserId);

  /// Belirtilen kimliğe sahip kullanıcı bilgilerini getirir.
  Future<UserModel?> getUserById(String userId);
}
