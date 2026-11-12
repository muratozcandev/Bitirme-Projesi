import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import 'package:go_router/go_router.dart'; // GoRouter sayfa yönlendirme paketini içe aktarır
import '../features/appointments/presentation/appointments_screen.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../features/authentication/presentation/login_screen.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../features/authentication/presentation/register_screen.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../features/chat/presentation/chat_hub_screen.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../features/chat/presentation/team_chat_room_screen.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../features/legal/presentation/legal_document_screen.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../features/notifications/presentation/notifications_screen.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../features/profile/presentation/profile_screen.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../features/team_creation/presentation/team_creation_screen.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../shared/widgets/app_bottom_navigation.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

final _rootNavigatorKey = GlobalKey<NavigatorState>(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

final routerProvider = Provider<GoRouter>((ref) { // Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar
  final authNotifier = ValueNotifier<bool>( // Sabit/final değişken veya nesne tanımını başlatır
    ref.read(authProvider).isAuthenticated, // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
  ); // Açık olan kod/bileşen bloğunu kapatır

  ref.listen<AuthState>(authProvider, (_, next) { // Durum değişikliklerini dinleyerek yan etkileri (yönlendirme vb.) tetikler
    authNotifier.value = next.isAuthenticated; // İlgili kod satırını ve işlemi yürütür
  }); // İlgili kod satırını ve işlemi yürütür

  return GoRouter( // Uygulamanın sayfa yönlendirme (GoRouter) yapılandırmasını oluşturur
    navigatorKey: _rootNavigatorKey, // navigatorKey özelliğini yapılandırır
    initialLocation: '/team-creation', // initialLocation özelliğini yapılandırır
    refreshListenable: authNotifier, // refreshListenable özelliğini yapılandırır
    redirect: (context, state) { // redirect özelliğini yapılandırır
      final isAuthenticated = ref.read(authProvider).isAuthenticated; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      final path = state.uri.path; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final isPublicRoute = // Sabit/final değişken veya nesne tanımını başlatır
          path == '/login' || path == '/register' || path.startsWith('/legal'); // İlgili kod satırını ve işlemi yürütür

      if (!isAuthenticated && !isPublicRoute) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        return '/login'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      } // Açık olan kod/bileşen bloğunu kapatır
      if (isAuthenticated && (path == '/login' || path == '/register')) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        return '/team-creation'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      } // Açık olan kod/bileşen bloğunu kapatır
      return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    }, // Açık olan kod/bileşen bloğunu kapatır
    routes: [ // İlgili kod satırını ve işlemi yürütür
      GoRoute( // Belirli bir URL yolu (path) için ekran rotası tanımlar
        path: '/login', // path özelliğini yapılandırır
        builder: (context, state) => const LoginScreen(), // builder özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      GoRoute( // Belirli bir URL yolu (path) için ekran rotası tanımlar
        path: '/register', // path özelliğini yapılandırır
        builder: (context, state) => const RegisterScreen(), // builder özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      GoRoute( // Belirli bir URL yolu (path) için ekran rotası tanımlar
        path: '/legal/:type', // path özelliğini yapılandırır
        builder: (context, state) { // builder özelliğini yapılandırır
          final type = state.pathParameters['type'] ?? 'user_agreement'; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
          return LegalDocumentScreen(documentType: type); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
        }, // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
      GoRoute( // Belirli bir URL yolu (path) için ekran rotası tanımlar
        path: '/notifications', // path özelliğini yapılandırır
        parentNavigatorKey: _rootNavigatorKey, // parentNavigatorKey özelliğini yapılandırır
        builder: (context, state) => const NotificationsScreen(), // builder özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      GoRoute( // Belirli bir URL yolu (path) için ekran rotası tanımlar
        path: '/chat-room/:teamId', // path özelliğini yapılandırır
        parentNavigatorKey: _rootNavigatorKey, // parentNavigatorKey özelliğini yapılandırır
        builder: (context, state) { // builder özelliğini yapılandırır
          final teamId = state.pathParameters['teamId'] ?? ''; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
          return TeamChatRoomScreen(teamId: teamId); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
        }, // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
      StatefulShellRoute.indexedStack( // Alt gezinme çubuğu (BottomNavigationBar) sekmelerinin durumunu koruyan kabuk rotayı tanımlar
        builder: (context, state, navigationShell) { // builder özelliğini yapılandırır
          return AppBottomNavigationShell(navigationShell: navigationShell); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
        }, // Açık olan kod/bileşen bloğunu kapatır
        branches: [ // İlgili kod satırını ve işlemi yürütür
          // 1. Takım Kur
          StatefulShellBranch( // Alt gezinme çubuğundaki her bir sekme dalını tanımlar
            routes: [ // İlgili kod satırını ve işlemi yürütür
              GoRoute( // Belirli bir URL yolu (path) için ekran rotası tanımlar
                path: '/team-creation', // path özelliğini yapılandırır
                builder: (context, state) => const TeamCreationScreen(), // builder özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
          // 2. Randevularım
          StatefulShellBranch( // Alt gezinme çubuğundaki her bir sekme dalını tanımlar
            routes: [ // İlgili kod satırını ve işlemi yürütür
              GoRoute( // Belirli bir URL yolu (path) için ekran rotası tanımlar
                path: '/appointments', // path özelliğini yapılandırır
                builder: (context, state) => const AppointmentsScreen(), // builder özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
          // 3. Profil
          StatefulShellBranch( // Alt gezinme çubuğundaki her bir sekme dalını tanımlar
            routes: [ // İlgili kod satırını ve işlemi yürütür
              GoRoute( // Belirli bir URL yolu (path) için ekran rotası tanımlar
                path: '/profile', // path özelliğini yapılandırır
                builder: (context, state) => const ProfileScreen(), // builder özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
          // 4. Sohbet
          StatefulShellBranch( // Alt gezinme çubuğundaki her bir sekme dalını tanımlar
            routes: [ // İlgili kod satırını ve işlemi yürütür
              GoRoute( // Belirli bir URL yolu (path) için ekran rotası tanımlar
                path: '/chat', // path özelliğini yapılandırır
                builder: (context, state) => const ChatHubScreen(), // builder özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ], // Açık olan kod/bileşen bloğunu kapatır
  ); // Açık olan kod/bileşen bloğunu kapatır
}); // İlgili kod satırını ve işlemi yürütür

