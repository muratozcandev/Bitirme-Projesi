// Kimlik doğrulama ve kullanıcı oturum işlemleri için soyut arayüzü (interface) tanımlar.

import '../../../shared/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();

  Future<UserModel> login({
    required String identifier,
    required String password,
  });

  Future<UserModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required bool acceptedUserAgreement,
    required bool acceptedKvkk,
  });

  Future<void> logout();

  Future<UserModel> updateThemeMode({
    required String userId,
    required String themeMode,
  });

  Future<List<UserModel>> getSuggestedPlayers(String currentUserId);

  Future<UserModel?> getUserById(String userId);
}
