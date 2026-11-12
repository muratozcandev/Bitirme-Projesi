import 'package:cloud_firestore/cloud_firestore.dart'; // Cloud Firestore bulut veritabanı paketini içe aktarır
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication kimlik doğrulama paketini içe aktarır
import 'package:firebase_core/firebase_core.dart'; // Firebase temel başlatma (core) paketini içe aktarır
import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import 'package:shared_preferences/shared_preferences.dart'; // Yerel anahtar-değer (SharedPreferences) depolama paketini içe aktarır
import '../../data/database/app_database.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/authentication/data/firebase_auth_repository.dart'; // Firebase Authentication kimlik doğrulama paketini içe aktarır
import '../../features/authentication/data/local_auth_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/authentication/domain/auth_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/chat/data/local_chat_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/chat/domain/chat_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/notifications/data/local_invitation_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/notifications/data/local_notification_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/notifications/domain/invitation_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/notifications/domain/notification_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/team_creation/data/local_location_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/team_creation/data/local_team_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/team_creation/domain/location_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../features/team_creation/domain/team_repository.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/formation.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/invitation_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/message_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/notification_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/team_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/user_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

/// SharedPreferences provider (main.dart içinde override edilir)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  throw UnimplementedError('sharedPreferencesProvider must be overridden'); // İlgili hata nesnesini (Exception) fırlatır
}); // İlgili kod satırını ve işlemi yürütür

/// Firebase başlatılma durumu ve temel servis provider'ları
final firebaseInitializedProvider = Provider<bool>((ref) => false); // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar

final firebaseAppProvider = Provider<FirebaseApp?>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  final isReady = ref.watch(firebaseInitializedProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (!isReady || Firebase.apps.isEmpty) return null; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return Firebase.app(); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
}); // İlgili kod satırını ve işlemi yürütür

final firebaseAuthInstanceProvider = Provider<FirebaseAuth?>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  final app = ref.watch(firebaseAppProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (app == null) return null; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return FirebaseAuth.instanceFor(app: app); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
}); // İlgili kod satırını ve işlemi yürütür

final firestoreInstanceProvider = Provider<FirebaseFirestore?>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  final app = ref.watch(firebaseAppProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (app == null) return null; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return FirebaseFirestore.instanceFor(app: app); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
}); // İlgili kod satırını ve işlemi yürütür

/// AppDatabase provider
final appDatabaseProvider = Provider<AppDatabase>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return AppDatabase.instance; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
}); // İlgili kod satırını ve işlemi yürütür

/// Repository Providers
final localAuthRepositoryProvider = Provider<LocalAuthRepository>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return LocalAuthRepository( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    appDatabase: ref.watch(appDatabaseProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    prefs: ref.watch(sharedPreferencesProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  ); // Açık olan kod/bileşen bloğunu kapatır
}); // İlgili kod satırını ve işlemi yürütür

final authRepositoryProvider = Provider<AuthRepository>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return FirebaseAuthRepository( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    firebaseAuth: ref.watch(firebaseAuthInstanceProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    firestore: ref.watch(firestoreInstanceProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    appDatabase: ref.watch(appDatabaseProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    prefs: ref.watch(sharedPreferencesProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  ); // Açık olan kod/bileşen bloğunu kapatır
}); // İlgili kod satırını ve işlemi yürütür

final locationRepositoryProvider = Provider<LocationRepository>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return LocalLocationRepository( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    appDatabase: ref.watch(appDatabaseProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  ); // Açık olan kod/bileşen bloğunu kapatır
}); // İlgili kod satırını ve işlemi yürütür

final teamRepositoryProvider = Provider<TeamRepository>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return LocalTeamRepository( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    appDatabase: ref.watch(appDatabaseProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  ); // Açık olan kod/bileşen bloğunu kapatır
}); // İlgili kod satırını ve işlemi yürütür

final invitationRepositoryProvider = Provider<InvitationRepository>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return LocalInvitationRepository( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    appDatabase: ref.watch(appDatabaseProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    teamRepository: ref.watch(teamRepositoryProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  ); // Açık olan kod/bileşen bloğunu kapatır
}); // İlgili kod satırını ve işlemi yürütür

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return LocalNotificationRepository( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    appDatabase: ref.watch(appDatabaseProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  ); // Açık olan kod/bileşen bloğunu kapatır
}); // İlgili kod satırını ve işlemi yürütür

final chatRepositoryProvider = Provider<ChatRepository>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return LocalChatRepository( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    appDatabase: ref.watch(appDatabaseProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    teamRepository: ref.watch(teamRepositoryProvider), // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  ); // Açık olan kod/bileşen bloğunu kapatır
}); // İlgili kod satırını ve işlemi yürütür

/// Aktif Oturum Açmış Kullanıcı ve Profil State'i
class AuthState { // AuthState veri/yardımcı sınıfını tanımlar
  final UserModel? user; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool isLoading; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? error; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const AuthState({ // Sabit/final değişken veya nesne tanımını başlatır
    this.user, // user sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.isLoading = false, // isLoading = false sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.error, // error sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  bool get isAuthenticated => user != null; // İlgili kod satırını ve işlemi yürütür

  AuthState copyWith({ // İlgili kod satırını ve işlemi yürütür
    UserModel? user, // İlgili kod satırını ve işlemi yürütür
    bool clearUser = false, // İlgili kod satırını ve işlemi yürütür
    bool? isLoading, // İlgili kod satırını ve işlemi yürütür
    String? error, // İlgili kod satırını ve işlemi yürütür
    bool clearError = false, // İlgili kod satırını ve işlemi yürütür
  }) { // İlgili kod satırını ve işlemi yürütür
    return AuthState( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      user: clearUser ? null : (user ?? this.user), // user özelliğini yapılandırır
      isLoading: isLoading ?? this.isLoading, // isLoading özelliğini yapılandırır
      error: clearError ? null : (error ?? this.error), // error özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class AuthNotifier extends StateNotifier<AuthState> { // Durum değişikliklerini yöneten AuthNotifier StateNotifier sınıfını tanımlar
  final AuthRepository _authRepository; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Ref _ref; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  AuthNotifier(this._authRepository, this._ref) : super(const AuthState()); // İlgili kod satırını ve işlemi yürütür

  Future<void> initializeSession() async { // İlgili kod satırını ve işlemi yürütür
    state = state.copyWith(isLoading: true, clearError: true); // İlgili kod satırını ve işlemi yürütür
    try { // Hata yakalama (try) bloğunu başlatır
      final current = await _authRepository.getCurrentUser(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      state = AuthState(user: current, isLoading: false); // İlgili kod satırını ve işlemi yürütür
    } catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      state = AuthState(user: null, isLoading: false, error: e.toString()); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<bool> login({ // İlgili kod satırını ve işlemi yürütür
    required String identifier, // İlgili kod satırını ve işlemi yürütür
    required String password, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    state = state.copyWith(isLoading: true, clearError: true); // İlgili kod satırını ve işlemi yürütür
    try { // Hata yakalama (try) bloğunu başlatır
      final user = await _authRepository.login( // Sabit/final değişken veya nesne tanımını başlatır
        identifier: identifier, // identifier özelliğini yapılandırır
        password: password, // password özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      state = AuthState(user: user, isLoading: false); // İlgili kod satırını ve işlemi yürütür
      // Yeni kullanıcı oturumu için takım kurma formunu sıfırla
      _ref.read(teamCreationProvider.notifier).resetForUser(user.fullName); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      return true; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      state = state.copyWith(isLoading: false, error: e.toString()); // İlgili kod satırını ve işlemi yürütür
      return false; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<bool> register({ // İlgili kod satırını ve işlemi yürütür
    required String firstName, // İlgili kod satırını ve işlemi yürütür
    required String lastName, // İlgili kod satırını ve işlemi yürütür
    required String email, // İlgili kod satırını ve işlemi yürütür
    required String phone, // İlgili kod satırını ve işlemi yürütür
    required String password, // İlgili kod satırını ve işlemi yürütür
    required bool acceptedUserAgreement, // İlgili kod satırını ve işlemi yürütür
    required bool acceptedKvkk, // İlgili kod satırını ve işlemi yürütür
  }) async { // İlgili kod satırını ve işlemi yürütür
    state = state.copyWith(isLoading: true, clearError: true); // İlgili kod satırını ve işlemi yürütür
    try { // Hata yakalama (try) bloğunu başlatır
      await _authRepository.register( // Asenkron işlemin tamamlanmasını bekler
        firstName: firstName, // firstName özelliğini yapılandırır
        lastName: lastName, // lastName özelliğini yapılandırır
        email: email, // email özelliğini yapılandırır
        phone: phone, // phone özelliğini yapılandırır
        password: password, // password özelliğini yapılandırır
        acceptedUserAgreement: acceptedUserAgreement, // acceptedUserAgreement özelliğini yapılandırır
        acceptedKvkk: acceptedKvkk, // acceptedKvkk özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
      state = state.copyWith(isLoading: false, clearError: true); // İlgili kod satırını ve işlemi yürütür
      return true; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      state = state.copyWith(isLoading: false, error: e.toString()); // İlgili kod satırını ve işlemi yürütür
      return false; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> logout() async { // İlgili kod satırını ve işlemi yürütür
    await _authRepository.logout(); // Asenkron işlemin tamamlanmasını bekler
    state = const AuthState(user: null, isLoading: false); // İlgili kod satırını ve işlemi yürütür
    _ref.read(teamCreationProvider.notifier).reset(); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> toggleThemeMode(bool isDark) async { // İlgili kod satırını ve işlemi yürütür
    final currentUser = state.user; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (currentUser == null) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
    final newMode = isDark ? 'dark' : 'light'; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final updated = await _authRepository.updateThemeMode( // Sabit/final değişken veya nesne tanımını başlatır
      userId: currentUser.id, // userId özelliğini yapılandırır
      themeMode: newMode, // themeMode özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
    state = state.copyWith(user: updated); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return AuthNotifier(ref.watch(authRepositoryProvider), ref); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
}); // İlgili kod satırını ve işlemi yürütür

/// Kullanıcı Bazlı Tema Tercihi Provider'ı
final themeModeProvider = Provider<ThemeMode>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (user == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
    return ThemeMode.light; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
  return user.themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
}); // İlgili kod satırını ve işlemi yürütür

/// Takım Kurma Formu Merkezi State'i
class TeamCreationFormState { // TeamCreationFormState veri/yardımcı sınıfını tanımlar
  final String? selectedProvince; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? selectedDistrict; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? selectedVenue; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final DateTime? selectedDate; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? selectedTimeSlot; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Formation selectedFormation; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Map<String, String> lineup; // positionKey -> playerName
  final String captainPositionKey; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool isSubmitting; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const TeamCreationFormState({ // Sabit/final değişken veya nesne tanımını başlatır
    this.selectedProvince, // selectedProvince sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.selectedDistrict, // selectedDistrict sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.selectedVenue, // selectedVenue sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.selectedDate, // selectedDate sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.selectedTimeSlot, // selectedTimeSlot sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.selectedFormation = Formation.threeTwoOne, // selectedFormation = Formation.threeTwoOne sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.lineup = const {}, // lineup = const {} sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.captainPositionKey = 'GK_1', // captainPositionKey = 'GK_1' sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.isSubmitting = false, // isSubmitting = false sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  /// Kaydetme (Yeşil Tik) aktiflik koşulu:
  /// İl, İlçe, Halı Saha, Tarih, Saat ve Diziliş seçilmiş olmalıdır.
  bool get isReadyToSubmit => // İlgili kod satırını ve işlemi yürütür
      selectedProvince != null && // İlgili kod satırını ve işlemi yürütür
      selectedProvince!.isNotEmpty && // İlgili kod satırını ve işlemi yürütür
      selectedDistrict != null && // İlgili kod satırını ve işlemi yürütür
      selectedDistrict!.isNotEmpty && // İlgili kod satırını ve işlemi yürütür
      selectedVenue != null && // İlgili kod satırını ve işlemi yürütür
      selectedVenue!.isNotEmpty && // İlgili kod satırını ve işlemi yürütür
      selectedDate != null && // İlgili kod satırını ve işlemi yürütür
      selectedTimeSlot != null && // İlgili kod satırını ve işlemi yürütür
      selectedTimeSlot!.isNotEmpty && // İlgili kod satırını ve işlemi yürütür
      !isSubmitting; // İlgili kod satırını ve işlemi yürütür

  String get formattedDateKey { // İlgili kod satırını ve işlemi yürütür
    if (selectedDate == null) return ''; // Koşulun sağlanıp sağlanmadığını kontrol eder
    final y = selectedDate!.year.toString().padLeft(4, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final m = selectedDate!.month.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final d = selectedDate!.day.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return '$y-$m-$d'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  String get formattedDateDisplay { // İlgili kod satırını ve işlemi yürütür
    if (selectedDate == null) return 'Tarih Seç'; // Koşulun sağlanıp sağlanmadığını kontrol eder
    final d = selectedDate!.day.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final m = selectedDate!.month.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final y = selectedDate!.year; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return '$d.$m.$y'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  TeamCreationFormState copyWith({ // İlgili kod satırını ve işlemi yürütür
    String? selectedProvince, // İlgili kod satırını ve işlemi yürütür
    bool clearProvince = false, // İlgili kod satırını ve işlemi yürütür
    String? selectedDistrict, // İlgili kod satırını ve işlemi yürütür
    bool clearDistrict = false, // İlgili kod satırını ve işlemi yürütür
    String? selectedVenue, // İlgili kod satırını ve işlemi yürütür
    bool clearVenue = false, // İlgili kod satırını ve işlemi yürütür
    DateTime? selectedDate, // İlgili kod satırını ve işlemi yürütür
    bool clearDate = false, // İlgili kod satırını ve işlemi yürütür
    String? selectedTimeSlot, // İlgili kod satırını ve işlemi yürütür
    bool clearTimeSlot = false, // İlgili kod satırını ve işlemi yürütür
    Formation? selectedFormation, // İlgili kod satırını ve işlemi yürütür
    Map<String, String>? lineup, // İlgili kod satırını ve işlemi yürütür
    String? captainPositionKey, // İlgili kod satırını ve işlemi yürütür
    bool? isSubmitting, // İlgili kod satırını ve işlemi yürütür
  }) { // İlgili kod satırını ve işlemi yürütür
    return TeamCreationFormState( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      selectedProvince: // İlgili kod satırını ve işlemi yürütür
          clearProvince ? null : (selectedProvince ?? this.selectedProvince), // clearProvince ? null özelliğini yapılandırır
      selectedDistrict: // İlgili kod satırını ve işlemi yürütür
          clearDistrict ? null : (selectedDistrict ?? this.selectedDistrict), // clearDistrict ? null özelliğini yapılandırır
      selectedVenue: clearVenue ? null : (selectedVenue ?? this.selectedVenue), // selectedVenue özelliğini yapılandırır
      selectedDate: clearDate ? null : (selectedDate ?? this.selectedDate), // selectedDate özelliğini yapılandırır
      selectedTimeSlot: // İlgili kod satırını ve işlemi yürütür
          clearTimeSlot ? null : (selectedTimeSlot ?? this.selectedTimeSlot), // clearTimeSlot ? null özelliğini yapılandırır
      selectedFormation: selectedFormation ?? this.selectedFormation, // selectedFormation özelliğini yapılandırır
      lineup: lineup ?? this.lineup, // lineup özelliğini yapılandırır
      captainPositionKey: captainPositionKey ?? this.captainPositionKey, // captainPositionKey özelliğini yapılandırır
      isSubmitting: isSubmitting ?? this.isSubmitting, // isSubmitting özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class TeamCreationNotifier extends StateNotifier<TeamCreationFormState> { // Durum değişikliklerini yöneten TeamCreationNotifier StateNotifier sınıfını tanımlar
  TeamCreationNotifier() : super(const TeamCreationFormState()); // İlgili kod satırını ve işlemi yürütür

  void selectProvince(String province) { // İlgili kod satırını ve işlemi yürütür
    if (state.selectedProvince == province) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
    // İl değiştiğinde önceki ilçe ve halı saha seçimi sıfırlanır
    state = state.copyWith( // İlgili kod satırını ve işlemi yürütür
      selectedProvince: province, // selectedProvince özelliğini yapılandırır
      clearDistrict: true, // clearDistrict özelliğini yapılandırır
      clearVenue: true, // clearVenue özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  void selectDistrict(String district) { // İlgili kod satırını ve işlemi yürütür
    if (state.selectedDistrict == district) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
    // İlçe değiştiğinde halı saha seçimi sıfırlanır
    state = state.copyWith( // İlgili kod satırını ve işlemi yürütür
      selectedDistrict: district, // selectedDistrict özelliğini yapılandırır
      clearVenue: true, // clearVenue özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  void selectVenue(String venue) { // İlgili kod satırını ve işlemi yürütür
    state = state.copyWith(selectedVenue: venue); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır

  void selectDate(DateTime date) { // İlgili kod satırını ve işlemi yürütür
    final normalized = DateTime(date.year, date.month, date.day); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    state = state.copyWith(selectedDate: normalized); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır

  void selectTimeSlot(String slot) { // İlgili kod satırını ve işlemi yürütür
    state = state.copyWith(selectedTimeSlot: slot); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır

  void selectFormation(Formation formation) { // İlgili kod satırını ve işlemi yürütür
    if (state.selectedFormation == formation) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
    // Önceki dizilişteki oyuncu isimleri yeni dizilişte karşılığı varsa korunur,
    // karşılığı olmayan mevkiler sessizce başka mevkilere aktarılmaz.
    final migratedLineup = formation.migrateLineup(state.lineup); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final validKeys = formation.positions.map((p) => p.key).toSet(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final nextCaptainPos = validKeys.contains(state.captainPositionKey) // Sabit/final değişken veya nesne tanımını başlatır
        ? state.captainPositionKey // İlgili kod satırını ve işlemi yürütür
        : 'GK_1'; // İlgili kod satırını ve işlemi yürütür

    state = state.copyWith( // İlgili kod satırını ve işlemi yürütür
      selectedFormation: formation, // selectedFormation özelliğini yapılandırır
      lineup: migratedLineup, // lineup özelliğini yapılandırır
      captainPositionKey: nextCaptainPos, // captainPositionKey özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  void setPlayerName(String positionKey, String name) { // İlgili kod satırını ve işlemi yürütür
    final updated = Map<String, String>.from(state.lineup); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final trimmed = name.trim(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (trimmed.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      updated.remove(positionKey); // İlgili kod satırını ve işlemi yürütür
    } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
      updated[positionKey] = trimmed; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
    state = state.copyWith(lineup: updated); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır

  void setCaptainPosition(String positionKey, String captainName) { // İlgili kod satırını ve işlemi yürütür
    final updated = Map<String, String>.from(state.lineup); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (state.lineup[state.captainPositionKey] == captainName) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      updated.remove(state.captainPositionKey); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
    updated[positionKey] = captainName; // İlgili kod satırını ve işlemi yürütür
    state = state.copyWith( // İlgili kod satırını ve işlemi yürütür
      captainPositionKey: positionKey, // captainPositionKey özelliğini yapılandırır
      lineup: updated, // lineup özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  void setSubmitting(bool value) { // İlgili kod satırını ve işlemi yürütür
    state = state.copyWith(isSubmitting: value); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır

  void resetForUser(String captainName) { // İlgili kod satırını ve işlemi yürütür
    state = TeamCreationFormState( // İlgili kod satırını ve işlemi yürütür
      selectedFormation: Formation.threeTwoOne, // selectedFormation özelliğini yapılandırır
      lineup: {'GK_1': captainName}, // lineup özelliğini yapılandırır
      captainPositionKey: 'GK_1', // captainPositionKey özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  void reset() { // İlgili kod satırını ve işlemi yürütür
    state = const TeamCreationFormState(); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

final teamCreationProvider = // Sabit/final değişken veya nesne tanımını başlatır
    StateNotifierProvider<TeamCreationNotifier, TeamCreationFormState>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return TeamCreationNotifier(); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
}); // İlgili kod satırını ve işlemi yürütür

/// İl, İlçe ve Halı Saha Veri Provider'ları
final provincesProvider = FutureProvider<List<String>>((ref) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  return ref.watch(locationRepositoryProvider).getProvinces(); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
}); // İlgili kod satırını ve işlemi yürütür

final districtsProvider = // Sabit/final değişken veya nesne tanımını başlatır
    FutureProvider.family<List<String>, String>((ref, province) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  if (province.isEmpty) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref.watch(locationRepositoryProvider).getDistricts(province); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
}); // İlgili kod satırını ve işlemi yürütür

final venuesProvider = FutureProvider.family<List<String>, // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
    ({String province, String district})>((ref, params) async { // İlgili kod satırını ve işlemi yürütür
  if (params.province.isEmpty || params.district.isEmpty) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref.watch(locationRepositoryProvider).getVenues( // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
        province: params.province, // province özelliğini yapılandırır
        district: params.district, // district özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
}); // İlgili kod satırını ve işlemi yürütür

/// Veri yenileme tetikleyicisi (Randevular, Bildirimler, Davetler, Sohbetler)
final dataRefreshTriggerProvider = StateProvider<int>((ref) => 0); // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar

void triggerGlobalRefresh(WidgetRef ref) { // İlgili kod satırını ve işlemi yürütür
  ref.read(dataRefreshTriggerProvider.notifier).state++; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
} // Açık olan kod/bileşen bloğunu kapatır

/// Kullanıcının Randevuları Provider'ı
final userAppointmentsProvider = FutureProvider<List<TeamModel>>((ref) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  ref.watch(dataRefreshTriggerProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (user == null) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref.watch(teamRepositoryProvider).getUserAppointments(user.id); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
}); // İlgili kod satırını ve işlemi yürütür

/// Kaptanın Davet Gönderebileceği Takımları Provider'ı
final captainTeamsProvider = FutureProvider<List<TeamModel>>((ref) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  ref.watch(dataRefreshTriggerProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (user == null) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref.watch(teamRepositoryProvider).getCaptainTeams(user.id); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
}); // İlgili kod satırını ve işlemi yürütür

/// Kullanıcının Sohbet Edebileceği Üyesi Olduğu Takımlar Provider'ı
final userChatTeamsProvider = FutureProvider<List<TeamModel>>((ref) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  ref.watch(dataRefreshTriggerProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (user == null) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref.watch(teamRepositoryProvider).getUserChatTeams(user.id); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
}); // İlgili kod satırını ve işlemi yürütür

/// Oyuncu Önerileri Provider'ı (Aktif kullanıcı hariç diğer tüm kullanıcılar)
final suggestedPlayersProvider = FutureProvider<List<UserModel>>((ref) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  ref.watch(dataRefreshTriggerProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (user == null) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref.watch(authRepositoryProvider).getSuggestedPlayers(user.id); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
}); // İlgili kod satırını ve işlemi yürütür

/// Kullanıcının Bildirimleri Provider'ı
final userNotificationsProvider = // Sabit/final değişken veya nesne tanımını başlatır
    FutureProvider<List<NotificationModel>>((ref) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  ref.watch(dataRefreshTriggerProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (user == null) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref.watch(notificationRepositoryProvider).getUserNotifications(user.id); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
}); // İlgili kod satırını ve işlemi yürütür

/// Okunmamış Bildirim Sayısı Provider'ı
final unreadNotificationCountProvider = FutureProvider<int>((ref) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  ref.watch(dataRefreshTriggerProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (user == null) return 0; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref.watch(notificationRepositoryProvider).getUnreadCount(user.id); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
}); // İlgili kod satırını ve işlemi yürütür

/// Gelen ve Giden Davetler Provider'ları
final incomingInvitationsProvider = // Sabit/final değişken veya nesne tanımını başlatır
    FutureProvider<List<InvitationModel>>((ref) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  ref.watch(dataRefreshTriggerProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (user == null) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      .watch(invitationRepositoryProvider) // İlgili kod satırını ve işlemi yürütür
      .getIncomingInvitations(user.id); // İlgili kod satırını ve işlemi yürütür
}); // İlgili kod satırını ve işlemi yürütür

final outgoingInvitationsProvider = // Sabit/final değişken veya nesne tanımını başlatır
    FutureProvider<List<InvitationModel>>((ref) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  ref.watch(dataRefreshTriggerProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (user == null) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      .watch(invitationRepositoryProvider) // İlgili kod satırını ve işlemi yürütür
      .getOutgoingInvitations(user.id); // İlgili kod satırını ve işlemi yürütür
}); // İlgili kod satırını ve işlemi yürütür

/// Belirli Bir Takımın Sohbet Mesajları Provider'ı
final teamMessagesProvider = // Sabit/final değişken veya nesne tanımını başlatır
    FutureProvider.family<List<MessageModel>, String>((ref, teamId) async { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  ref.watch(dataRefreshTriggerProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
  if (user == null) return []; // Koşulun sağlanıp sağlanmadığını kontrol eder
  return ref.watch(chatRepositoryProvider).getTeamMessages( // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
        teamId: teamId, // teamId özelliğini yapılandırır
        requesterId: user.id, // requesterId özelliğini yapılandırır
      ); // Açık olan kod/bileşen bloğunu kapatır
}); // İlgili kod satırını ve işlemi yürütür

