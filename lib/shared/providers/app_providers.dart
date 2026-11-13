// Uygulama genelindeki Riverpod durum sağlayıcılarını (provider) ve oturum yönetimini barındırır.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/database/app_database.dart';
import '../../features/authentication/data/firebase_auth_repository.dart';
import '../../features/authentication/data/local_auth_repository.dart';
import '../../features/authentication/domain/auth_repository.dart';
import '../../features/chat/data/local_chat_repository.dart';
import '../../features/chat/domain/chat_repository.dart';
import '../../features/notifications/data/local_invitation_repository.dart';
import '../../features/notifications/data/local_notification_repository.dart';
import '../../features/notifications/domain/invitation_repository.dart';
import '../../features/notifications/domain/notification_repository.dart';
import '../../features/team_creation/data/local_location_repository.dart';
import '../../features/team_creation/data/local_team_repository.dart';
import '../../features/team_creation/domain/location_repository.dart';
import '../../features/team_creation/domain/team_repository.dart';
import '../models/formation.dart';
import '../models/invitation_model.dart';
import '../models/message_model.dart';
import '../models/notification_model.dart';
import '../models/team_model.dart';
import '../models/user_model.dart';

// =============================================================================
// 1. TEMEL ALTYAPI VE VERİTABANI SAĞLAYICILARI
// =============================================================================

/// Cihaz yerel anahtar-değer deposu sağlayıcısı (main.dart içinde override edilir)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// Firebase bağlantısının hazır olup olmadığını tutan sağlayıcı
final firebaseInitializedProvider = Provider<bool>((ref) => false);

/// Firebase ana uygulama örneğini döndüren sağlayıcı
final firebaseAppProvider = Provider<FirebaseApp?>((ref) {
  final isReady = ref.watch(firebaseInitializedProvider);
  if (!isReady || Firebase.apps.isEmpty) return null;
  return Firebase.app();
});

/// Firebase Authentication servis örneğini sağlayan sağlayıcı
final firebaseAuthInstanceProvider = Provider<FirebaseAuth?>((ref) {
  final app = ref.watch(firebaseAppProvider);
  if (app == null) return null;
  return FirebaseAuth.instanceFor(app: app);
});

/// Cloud Firestore bulut veritabanı örneğini sağlayan sağlayıcı
final firestoreInstanceProvider = Provider<FirebaseFirestore?>((ref) {
  final app = ref.watch(firebaseAppProvider);
  if (app == null) return null;
  return FirebaseFirestore.instanceFor(app: app);
});

/// SQLite yerel veritabanı singleton örneğini sağlayan sağlayıcı
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

// =============================================================================
// 2. REPOSITORY (VERİ ERİŞİM KATMANI) SAĞLAYICILARI
// =============================================================================

/// Çevrimdışı yerel kimlik doğrulama deposu
final localAuthRepositoryProvider = Provider<LocalAuthRepository>((ref) {
  return LocalAuthRepository(
    appDatabase: ref.watch(appDatabaseProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

/// Hibrit (Firebase ve yerel SQLite yedeklemeli) kimlik doğrulama deposu
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    firebaseAuth: ref.watch(firebaseAuthInstanceProvider),
    firestore: ref.watch(firestoreInstanceProvider),
    appDatabase: ref.watch(appDatabaseProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

/// İl, ilçe ve halı saha konum verilerini sorgulayan depo
final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocalLocationRepository(
    appDatabase: ref.watch(appDatabaseProvider),
  );
});

/// Takım oluşturma, kadro ve maç randevularını yöneten depo
final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return LocalTeamRepository(
    appDatabase: ref.watch(appDatabaseProvider),
  );
});

/// Oyuncu maç davetlerini ve yanıtlarını yöneten depo
final invitationRepositoryProvider = Provider<InvitationRepository>((ref) {
  return LocalInvitationRepository(
    appDatabase: ref.watch(appDatabaseProvider),
    teamRepository: ref.watch(teamRepositoryProvider),
  );
});

/// Kullanıcı bildirimlerini yöneten depo
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return LocalNotificationRepository(
    appDatabase: ref.watch(appDatabaseProvider),
  );
});

/// Takım içi mesajlaşma ve sohbet odası deposu
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return LocalChatRepository(
    appDatabase: ref.watch(appDatabaseProvider),
    teamRepository: ref.watch(teamRepositoryProvider),
  );
});

// =============================================================================
// 3. KİMLİK DOĞRULAMA VE OTURUM DURUM YÖNETİMİ (AUTH STATE & NOTIFIER)
// =============================================================================

/// Aktif oturum durumunu, kullanıcı modelini ve işlem hata/yüklenme bilgisini tutan durum sınıfı
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  /// Kullanıcının oturum açmış olup olmadığını belirtir
  bool get isAuthenticated => user != null;

  AuthState copyWith({
    UserModel? user,
    bool clearUser = false,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Oturum açma, kayıt olma, çıkış ve tema modu işlemlerini yöneten durum kontrolcüsü
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthNotifier(this._authRepository, this._ref) : super(const AuthState());

  /// Uygulama açılışında kayıtlı kullanıcı oturumunu yükler
  Future<void> initializeSession() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final current = await _authRepository.getCurrentUser();
      state = AuthState(user: current, isLoading: false);
    } catch (e) {
      state = AuthState(user: null, isLoading: false, error: e.toString());
    }
  }

  /// E-posta ve şifre ile sisteme giriş yapar
  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authRepository.login(
        identifier: identifier,
        password: password,
      );
      state = AuthState(user: user, isLoading: false);
      // Giriş yapan kullanıcının adını takım kurma ekranına kaptan olarak aktar
      _ref.read(teamCreationProvider.notifier).resetForUser(user.fullName);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Yeni kullanıcı kaydı oluşturur
  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
    required bool acceptedUserAgreement,
    required bool acceptedKvkk,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _authRepository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        password: password,
        acceptedUserAgreement: acceptedUserAgreement,
        acceptedKvkk: acceptedKvkk,
      );
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Aktif kullanıcı oturumunu kapatır
  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState(user: null, isLoading: false);
    _ref.read(teamCreationProvider.notifier).reset();
  }

  /// Kullanıcının Açık/Koyu tema tercihini değiştirir ve günceller
  Future<void> toggleThemeMode(bool isDark) async {
    final currentUser = state.user;
    if (currentUser == null) return;
    final newMode = isDark ? 'dark' : 'light';
    final updated = await _authRepository.updateThemeMode(
      userId: currentUser.id,
      themeMode: newMode,
    );
    state = state.copyWith(user: updated);
  }
}

/// Uygulama genelinde oturum durumunu yöneten StateNotifierProvider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider), ref);
});

/// Kullanıcının seçtiği açık/koyu tema modunu döndüren sağlayıcı
final themeModeProvider = Provider<ThemeMode>((ref) {
  final user = ref.watch(authProvider).user;
  if (user == null) {
    return ThemeMode.light;
  }
  return user.themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
});

// =============================================================================
// 4. TAKIM KURMA VE KADRO FORMU MERKEZİ DURUMU (TEAM CREATION STATE & NOTIFIER)
// =============================================================================

/// Takım oluşturma ekranında seçilen il, ilçe, saha, tarih, saat, formasyon ve kadro bilgilerini tutan durum
class TeamCreationFormState {
  final String? selectedProvince;
  final String? selectedDistrict;
  final String? selectedVenue;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final Formation selectedFormation;
  final Map<String, String> lineup;
  final String captainPositionKey;
  final bool isSubmitting;

  const TeamCreationFormState({
    this.selectedProvince,
    this.selectedDistrict,
    this.selectedVenue,
    this.selectedDate,
    this.selectedTimeSlot,
    this.selectedFormation = Formation.threeTwoOne,
    this.lineup = const {},
    this.captainPositionKey = 'GK_1',
    this.isSubmitting = false,
  });

  /// Takımı kaydetme (Yeşil Tik) aktiflik koşulu
  bool get isReadyToSubmit =>
      selectedProvince != null &&
      selectedProvince!.isNotEmpty &&
      selectedDistrict != null &&
      selectedDistrict!.isNotEmpty &&
      selectedVenue != null &&
      selectedVenue!.isNotEmpty &&
      selectedDate != null &&
      selectedTimeSlot != null &&
      selectedTimeSlot!.isNotEmpty &&
      !isSubmitting;

  /// Veritabanı formatında tarih anahtarı ('YYYY-MM-DD')
  String get formattedDateKey {
    if (selectedDate == null) return '';
    final y = selectedDate!.year.toString().padLeft(4, '0');
    final m = selectedDate!.month.toString().padLeft(2, '0');
    final d = selectedDate!.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Kullanıcı arayüzünde gösterilecek Türkçe tarih formatı ('DD.MM.YYYY')
  String get formattedDateDisplay {
    if (selectedDate == null) return 'Tarih Seç';
    final d = selectedDate!.day.toString().padLeft(2, '0');
    final m = selectedDate!.month.toString().padLeft(2, '0');
    final y = selectedDate!.year;
    return '$d.$m.$y';
  }

  TeamCreationFormState copyWith({
    String? selectedProvince,
    bool clearProvince = false,
    String? selectedDistrict,
    bool clearDistrict = false,
    String? selectedVenue,
    bool clearVenue = false,
    DateTime? selectedDate,
    bool clearDate = false,
    String? selectedTimeSlot,
    bool clearTimeSlot = false,
    Formation? selectedFormation,
    Map<String, String>? lineup,
    String? captainPositionKey,
    bool? isSubmitting,
  }) {
    return TeamCreationFormState(
      selectedProvince:
          clearProvince ? null : (selectedProvince ?? this.selectedProvince),
      selectedDistrict:
          clearDistrict ? null : (selectedDistrict ?? this.selectedDistrict),
      selectedVenue: clearVenue ? null : (selectedVenue ?? this.selectedVenue),
      selectedDate: clearDate ? null : (selectedDate ?? this.selectedDate),
      selectedTimeSlot:
          clearTimeSlot ? null : (selectedTimeSlot ?? this.selectedTimeSlot),
      selectedFormation: selectedFormation ?? this.selectedFormation,
      lineup: lineup ?? this.lineup,
      captainPositionKey: captainPositionKey ?? this.captainPositionKey,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

/// Takım oluşturma formundaki kullanıcı seçimlerini yöneten kontrolcü
class TeamCreationNotifier extends StateNotifier<TeamCreationFormState> {
  TeamCreationNotifier() : super(const TeamCreationFormState());

  /// İl seçildiğinde önceki ilçe ve halı saha seçimlerini sıfırlar
  void selectProvince(String province) {
    if (state.selectedProvince == province) return;
    state = state.copyWith(
      selectedProvince: province,
      clearDistrict: true,
      clearVenue: true,
    );
  }

  /// İlçe seçildiğinde önceki halı saha seçimini sıfırlar
  void selectDistrict(String district) {
    if (state.selectedDistrict == district) return;
    state = state.copyWith(
      selectedDistrict: district,
      clearVenue: true,
    );
  }

  /// Halı saha tesisini seçer
  void selectVenue(String venue) {
    state = state.copyWith(selectedVenue: venue);
  }

  /// Maç tarihini seçer
  void selectDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    state = state.copyWith(selectedDate: normalized);
  }

  /// Maç saat aralığını seçer
  void selectTimeSlot(String slot) {
    state = state.copyWith(selectedTimeSlot: slot);
  }

  /// Saha dizilişini (Formasyon) değiştirir ve önceki kadroyu yeni dizilişe uyarlar
  void selectFormation(Formation formation) {
    if (state.selectedFormation == formation) return;
    final migratedLineup = formation.migrateLineup(state.lineup);
    final validKeys = formation.positions.map((p) => p.key).toSet();
    final nextCaptainPos = validKeys.contains(state.captainPositionKey)
        ? state.captainPositionKey
        : 'GK_1';

    state = state.copyWith(
      selectedFormation: formation,
      lineup: migratedLineup,
      captainPositionKey: nextCaptainPos,
    );
  }

  /// Belirli bir mevkiye oyuncu ismi atar veya kaldırır
  void setPlayerName(String positionKey, String name) {
    final updated = Map<String, String>.from(state.lineup);
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      updated.remove(positionKey);
    } else {
      updated[positionKey] = trimmed;
    }
    state = state.copyWith(lineup: updated);
  }

  /// Takım kaptanının sahadaki mevkisini belirler
  void setCaptainPosition(String positionKey, String captainName) {
    final updated = Map<String, String>.from(state.lineup);
    if (state.lineup[state.captainPositionKey] == captainName) {
      updated.remove(state.captainPositionKey);
    }
    updated[positionKey] = captainName;
    state = state.copyWith(
      captainPositionKey: positionKey,
      lineup: updated,
    );
  }

  /// Kaydetme işlemi sırasındaki yüklenme durumunu ayarlar
  void setSubmitting(bool value) {
    state = state.copyWith(isSubmitting: value);
  }

  /// Formu oturum açan kullanıcı için sıfırlar ve kaptan olarak ilk mevkiye ekler
  void resetForUser(String captainName) {
    state = TeamCreationFormState(
      selectedFormation: Formation.threeTwoOne,
      lineup: {'GK_1': captainName},
      captainPositionKey: 'GK_1',
    );
  }

  /// Formu tamamen başlangıç durumuna sıfırlar
  void reset() {
    state = const TeamCreationFormState();
  }
}

/// Takım kurma durumunu yöneten StateNotifierProvider
final teamCreationProvider =
    StateNotifierProvider<TeamCreationNotifier, TeamCreationFormState>((ref) {
  return TeamCreationNotifier();
});

// =============================================================================
// 5. KONUM, RANDEVU, BİLDİRİM VE SOHBET VERİ SAĞLAYICILARI (FUTURE PROVIDERS)
// =============================================================================

/// 81 ilin listesini asenkron getiren sağlayıcı
final provincesProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(locationRepositoryProvider).getProvinces();
});

/// Seçilen ile bağlı ilçelerin listesini getiren sağlayıcı
final districtsProvider =
    FutureProvider.family<List<String>, String>((ref, province) async {
  if (province.isEmpty) return [];
  return ref.watch(locationRepositoryProvider).getDistricts(province);
});

/// Seçilen il ve ilçedeki halı sahaların listesini getiren sağlayıcı
final venuesProvider = FutureProvider.family<List<String>,
    ({String province, String district})>((ref, params) async {
  if (params.province.isEmpty || params.district.isEmpty) return [];
  return ref.watch(locationRepositoryProvider).getVenues(
        province: params.province,
        district: params.district,
      );
});

/// Veri listelerini (Randevular, Bildirimler vb.) yenilemek için kullanılan sayaç sağlayıcı
final dataRefreshTriggerProvider = StateProvider<int>((ref) => 0);

/// Tüm bağlı sağlayıcıların verilerini tazeleyen tetikleyici yardımcı fonksiyon
void triggerGlobalRefresh(WidgetRef ref) {
  ref.read(dataRefreshTriggerProvider.notifier).state++;
}

/// Kullanıcının kaptan olduğu veya oyuncu olarak katıldığı maç randevularını getiren sağlayıcı
final userAppointmentsProvider = FutureProvider<List<TeamModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(teamRepositoryProvider).getUserAppointments(user.id);
});

/// Kaptanın oyuncu daveti gönderebileceği aktif takımlarını getiren sağlayıcı
final captainTeamsProvider = FutureProvider<List<TeamModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(teamRepositoryProvider).getCaptainTeams(user.id);
});

/// Kullanıcının üyesi olduğu ve sohbet edebileceği takımları getiren sağlayıcı
final userChatTeamsProvider = FutureProvider<List<TeamModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(teamRepositoryProvider).getUserChatTeams(user.id);
});

/// Takıma davet edilebilecek diğer oyuncuların listesini getiren sağlayıcı
final suggestedPlayersProvider = FutureProvider<List<UserModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(authRepositoryProvider).getSuggestedPlayers(user.id);
});

/// Kullanıcıya gelen bildirimlerin listesini getiren sağlayıcı
final userNotificationsProvider =
    FutureProvider<List<NotificationModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(notificationRepositoryProvider).getUserNotifications(user.id);
});

/// Okunmamış bildirim adedini hesaplayan sağlayıcı
final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return 0;
  return ref.watch(notificationRepositoryProvider).getUnreadCount(user.id);
});

/// Kullanıcıya gelen maç davetlerini getiren sağlayıcı
final incomingInvitationsProvider =
    FutureProvider<List<InvitationModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref
      .watch(invitationRepositoryProvider)
      .getIncomingInvitations(user.id);
});

/// Kullanıcının diğer oyunculara gönderdiği davetleri getiren sağlayıcı
final outgoingInvitationsProvider =
    FutureProvider<List<InvitationModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref
      .watch(invitationRepositoryProvider)
      .getOutgoingInvitations(user.id);
});

/// Belirli bir takımın sohbet mesajlarını getiren sağlayıcı
final teamMessagesProvider =
    FutureProvider.family<List<MessageModel>, String>((ref, teamId) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(chatRepositoryProvider).getTeamMessages(
        teamId: teamId,
        requesterId: user.id,
      );
});
