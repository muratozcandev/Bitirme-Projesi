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

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
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
    redirect: (context, state) {
      final isAuthenticated = ref.read(authProvider).isAuthenticated;
      final path = state.uri.path;
      final isPublicRoute =
          path == '/login' || path == '/register' || path.startsWith('/legal');

      if (!isAuthenticated && !isPublicRoute) {
        return '/login';
      }
      if (isAuthenticated && (path == '/login' || path == '/register')) {
        return '/team-creation';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/legal/:type',
        builder: (context, state) {
          final type = state.pathParameters['type'] ?? 'user_agreement';
          return LegalDocumentScreen(documentType: type);
        },
      ),
      GoRoute(
        path: '/notifications',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/chat-room/:teamId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final teamId = state.pathParameters['teamId'] ?? '';
          return TeamChatRoomScreen(teamId: teamId);
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppBottomNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // 1. Takım Kur
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/team-creation',
                builder: (context, state) => const TeamCreationScreen(),
              ),
            ],
          ),
          // 2. Randevularım
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/appointments',
                builder: (context, state) => const AppointmentsScreen(),
              ),
            ],
          ),
          // 3. Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          // 4. Sohbet
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

