import '../../../shared/models/user_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

abstract class AuthRepository { // AuthRepository soyut arayüz (interface) sınıfını tanımlar
  Future<UserModel?> getCurrentUser(); // İlgili kod satırını ve işlemi yürütür

  Future<UserModel> login({ // İlgili kod satırını ve işlemi yürütür
    required String identifier, // İlgili kod satırını ve işlemi yürütür
    required String password, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür

  Future<UserModel> register({ // İlgili kod satırını ve işlemi yürütür
    required String firstName, // İlgili kod satırını ve işlemi yürütür
    required String lastName, // İlgili kod satırını ve işlemi yürütür
    required String email, // İlgili kod satırını ve işlemi yürütür
    required String phone, // İlgili kod satırını ve işlemi yürütür
    required String password, // İlgili kod satırını ve işlemi yürütür
    required bool acceptedUserAgreement, // İlgili kod satırını ve işlemi yürütür
    required bool acceptedKvkk, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür

  Future<void> logout(); // İlgili kod satırını ve işlemi yürütür

  Future<UserModel> updateThemeMode({ // İlgili kod satırını ve işlemi yürütür
    required String userId, // İlgili kod satırını ve işlemi yürütür
    required String themeMode, // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür

  Future<List<UserModel>> getSuggestedPlayers(String currentUserId); // İlgili kod satırını ve işlemi yürütür

  Future<UserModel?> getUserById(String userId); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

