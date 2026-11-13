// Uygulama içi sayfa yönlendirmelerini (GoRouter) ve oturum kontrolünü yönetir.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/appointments/presentation/appointments_screen.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/authentication/presentation/register_screen.dart';
import '../features/chat/presentation/chat_hub_screen.dart';
import '../features/chat/presentation/team_chat_room_screen.dart';
import '../features/legal/presentation/legal_document_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/team_creation/presentation/team_creation_screen.dart';
import '../shared/providers/app_providers.dart';
import '../shared/widgets/app_bottom_navigation.dart';

// Modal ve üst seviye rotaların ana pencerede açılması için kök anahtar
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Uygulamanın deklaratif sayfa yönlendirme sağlayıcısı (GoRouter).
/// Kullanıcının giriş durumunu dinler, oturumsuz kullanıcıları giriş ekranına,
/// oturumu açık olanları ise doğrudan ana ekrana yönlendirir.
final routerProvider = Provider<GoRouter>((ref) {
  // Oturum durumu değiştiğinde GoRouter'ın yönlendirme kuralını (redirect) tetikleyen dinleyici
  final authNotifier = ValueNotifier<bool>(
    ref.read(authProvider).isAuthenticated,
  );

  ref.listen<AuthState>(authProvider, (_, next) {
    authNotifier.value = next.isAuthenticated;
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/team-creation',
    refreshListenable: authNotifier,

    // Sayfa erişim ve yetki kontrolü (Route Guards)
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final path = state.uri.path;
      final isPublicRoute =
          path == '/login' || path == '/register' || path.startsWith('/legal');

      // Giriş yapmamış kullanıcıyı halka açık olmayan rotalardan giriş ekranına yönlendir
      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }
      // Zaten oturum açmış kullanıcı giriş/kayıt sayfasına gitmek isterse ana ekrana yönlendir
      if (isAuthenticated && (path == '/login' || path == '/register')) {
        return '/team-creation';
      }
      return null;
    },

    routes: [
      // 1. Giriş Yap Ekranı
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // 2. Yeni Hesap Oluşturma Ekranı
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // 3. Yasal Metinler (Kullanıcı Sözleşmesi ve KVKK) Görüntüleme Ekranı
      GoRoute(
        path: '/legal/:type',
        builder: (context, state) {
          final type = state.pathParameters['type'] ?? 'user_agreement';
          return LegalDocumentScreen(documentType: type);
        },
      ),

      // 4. Bildirimler ve Takım Davetleri Ekranı
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),

      // 5. Takım İçi Mesajlaşma Odası Ekranı
      GoRoute(
        path: '/chat-room/:teamId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final teamId = state.pathParameters['teamId'] ?? '';
          return TeamChatRoomScreen(teamId: teamId);
        },
      ),

      // 6. Alt Gezinme Çubuğu (Bottom Navigation Bar) Dalları ve Kalıcı Sekmeler
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppBottomNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // Sekme 1: Takım Kur Ekranı
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/team-creation',
                builder: (context, state) => const TeamCreationScreen(),
              ),
            ],
          ),

          // Sekme 2: Randevularım Ekranı
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/appointments',
                builder: (context, state) => const AppointmentsScreen(),
              ),
            ],
          ),

          // Sekme 3: Profil Ekranı
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),

          // Sekme 4: Sohbetler (Chat Hub) Ekranı
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const ChatHubScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
