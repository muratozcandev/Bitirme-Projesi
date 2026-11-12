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

/// SharedPreferences provider (main.dart içinde override edilir)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// Firebase başlatılma durumu ve temel servis provider'ları
final firebaseInitializedProvider = Provider<bool>((ref) => false);

final firebaseAppProvider = Provider<FirebaseApp?>((ref) {
  final isReady = ref.watch(firebaseInitializedProvider);
  if (!isReady || Firebase.apps.isEmpty) return null;
  return Firebase.app();
});

final firebaseAuthInstanceProvider = Provider<FirebaseAuth?>((ref) {
  final app = ref.watch(firebaseAppProvider);
  if (app == null) return null;
  return FirebaseAuth.instanceFor(app: app);
});

final firestoreInstanceProvider = Provider<FirebaseFirestore?>((ref) {
  final app = ref.watch(firebaseAppProvider);
  if (app == null) return null;
  return FirebaseFirestore.instanceFor(app: app);
});

/// AppDatabase provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

/// Repository Providers
final localAuthRepositoryProvider = Provider<LocalAuthRepository>((ref) {
  return LocalAuthRepository(
    appDatabase: ref.watch(appDatabaseProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository(
    firebaseAuth: ref.watch(firebaseAuthInstanceProvider),
    firestore: ref.watch(firestoreInstanceProvider),
    appDatabase: ref.watch(appDatabaseProvider),
    prefs: ref.watch(sharedPreferencesProvider),
  );
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocalLocationRepository(
    appDatabase: ref.watch(appDatabaseProvider),
  );
});

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return LocalTeamRepository(
    appDatabase: ref.watch(appDatabaseProvider),
  );
});

final invitationRepositoryProvider = Provider<InvitationRepository>((ref) {
  return LocalInvitationRepository(
    appDatabase: ref.watch(appDatabaseProvider),
    teamRepository: ref.watch(teamRepositoryProvider),
  );
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return LocalNotificationRepository(
    appDatabase: ref.watch(appDatabaseProvider),
  );
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return LocalChatRepository(
    appDatabase: ref.watch(appDatabaseProvider),
    teamRepository: ref.watch(teamRepositoryProvider),
  );
});

/// Aktif Oturum Açmış Kullanıcı ve Profil State'i
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

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

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthNotifier(this._authRepository, this._ref) : super(const AuthState());

  Future<void> initializeSession() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final current = await _authRepository.getCurrentUser();
      state = AuthState(user: current, isLoading: false);
    } catch (e) {
      state = AuthState(user: null, isLoading: false, error: e.toString());
    }
  }

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
      // Yeni kullanıcı oturumu için takım kurma formunu sıfırla
      _ref.read(teamCreationProvider.notifier).resetForUser(user.fullName);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

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

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState(user: null, isLoading: false);
    _ref.read(teamCreationProvider.notifier).reset();
  }

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

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider), ref);
});

/// Kullanıcı Bazlı Tema Tercihi Provider'ı
final themeModeProvider = Provider<ThemeMode>((ref) {
  final user = ref.watch(authProvider).user;
  if (user == null) {
    return ThemeMode.light;
  }
  return user.themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
});

/// Takım Kurma Formu Merkezi State'i
class TeamCreationFormState {
  final String? selectedProvince;
  final String? selectedDistrict;
  final String? selectedVenue;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final Formation selectedFormation;
  final Map<String, String> lineup; // positionKey -> playerName
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

  /// Kaydetme (Yeşil Tik) aktiflik koşulu:
  /// İl, İlçe, Halı Saha, Tarih, Saat ve Diziliş seçilmiş olmalıdır.
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

  String get formattedDateKey {
    if (selectedDate == null) return '';
    final y = selectedDate!.year.toString().padLeft(4, '0');
    final m = selectedDate!.month.toString().padLeft(2, '0');
    final d = selectedDate!.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

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

class TeamCreationNotifier extends StateNotifier<TeamCreationFormState> {
  TeamCreationNotifier() : super(const TeamCreationFormState());

  void selectProvince(String province) {
    if (state.selectedProvince == province) return;
    // İl değiştiğinde önceki ilçe ve halı saha seçimi sıfırlanır
    state = state.copyWith(
      selectedProvince: province,
      clearDistrict: true,
      clearVenue: true,
    );
  }

  void selectDistrict(String district) {
    if (state.selectedDistrict == district) return;
    // İlçe değiştiğinde halı saha seçimi sıfırlanır
    state = state.copyWith(
      selectedDistrict: district,
      clearVenue: true,
    );
  }

  void selectVenue(String venue) {
    state = state.copyWith(selectedVenue: venue);
  }

  void selectDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    state = state.copyWith(selectedDate: normalized);
  }

  void selectTimeSlot(String slot) {
    state = state.copyWith(selectedTimeSlot: slot);
  }

  void selectFormation(Formation formation) {
    if (state.selectedFormation == formation) return;
    // Önceki dizilişteki oyuncu isimleri yeni dizilişte karşılığı varsa korunur,
    // karşılığı olmayan mevkiler sessizce başka mevkilere aktarılmaz.
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

  void setSubmitting(bool value) {
    state = state.copyWith(isSubmitting: value);
  }

  void resetForUser(String captainName) {
    state = TeamCreationFormState(
      selectedFormation: Formation.threeTwoOne,
      lineup: {'GK_1': captainName},
      captainPositionKey: 'GK_1',
    );
  }

  void reset() {
    state = const TeamCreationFormState();
  }
}

final teamCreationProvider =
    StateNotifierProvider<TeamCreationNotifier, TeamCreationFormState>((ref) {
  return TeamCreationNotifier();
});

/// İl, İlçe ve Halı Saha Veri Provider'ları
final provincesProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(locationRepositoryProvider).getProvinces();
});

final districtsProvider =
    FutureProvider.family<List<String>, String>((ref, province) async {
  if (province.isEmpty) return [];
  return ref.watch(locationRepositoryProvider).getDistricts(province);
});

final venuesProvider = FutureProvider.family<List<String>,
    ({String province, String district})>((ref, params) async {
  if (params.province.isEmpty || params.district.isEmpty) return [];
  return ref.watch(locationRepositoryProvider).getVenues(
        province: params.province,
        district: params.district,
      );
});

/// Veri yenileme tetikleyicisi (Randevular, Bildirimler, Davetler, Sohbetler)
final dataRefreshTriggerProvider = StateProvider<int>((ref) => 0);

void triggerGlobalRefresh(WidgetRef ref) {
  ref.read(dataRefreshTriggerProvider.notifier).state++;
}

/// Kullanıcının Randevuları Provider'ı
final userAppointmentsProvider = FutureProvider<List<TeamModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(teamRepositoryProvider).getUserAppointments(user.id);
});

/// Kaptanın Davet Gönderebileceği Takımları Provider'ı
final captainTeamsProvider = FutureProvider<List<TeamModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(teamRepositoryProvider).getCaptainTeams(user.id);
});

/// Kullanıcının Sohbet Edebileceği Üyesi Olduğu Takımlar Provider'ı
final userChatTeamsProvider = FutureProvider<List<TeamModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(teamRepositoryProvider).getUserChatTeams(user.id);
});

/// Oyuncu Önerileri Provider'ı (Aktif kullanıcı hariç diğer tüm kullanıcılar)
final suggestedPlayersProvider = FutureProvider<List<UserModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(authRepositoryProvider).getSuggestedPlayers(user.id);
});

/// Kullanıcının Bildirimleri Provider'ı
final userNotificationsProvider =
    FutureProvider<List<NotificationModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref.watch(notificationRepositoryProvider).getUserNotifications(user.id);
});

/// Okunmamış Bildirim Sayısı Provider'ı
final unreadNotificationCountProvider = FutureProvider<int>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return 0;
  return ref.watch(notificationRepositoryProvider).getUnreadCount(user.id);
});

/// Gelen ve Giden Davetler Provider'ları
final incomingInvitationsProvider =
    FutureProvider<List<InvitationModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref
      .watch(invitationRepositoryProvider)
      .getIncomingInvitations(user.id);
});

final outgoingInvitationsProvider =
    FutureProvider<List<InvitationModel>>((ref) async {
  ref.watch(dataRefreshTriggerProvider);
  final user = ref.watch(authProvider).user;
  if (user == null) return [];
  return ref
      .watch(invitationRepositoryProvider)
      .getOutgoingInvitations(user.id);
});

/// Belirli Bir Takımın Sohbet Mesajları Provider'ı
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

