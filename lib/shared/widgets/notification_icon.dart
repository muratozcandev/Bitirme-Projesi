// Okunmamış bildirim sayısını rozet (badge) ile gösteren üst çubuk ikon bileşenidir.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/app_providers.dart';

/// AppBar üzerinde yer alan, okunmamış bildirim sayısını kırmızı bir
/// sayaç rozeti (badge) olarak gösteren ve tıklandığında bildirimler
/// ekranına yönlendiren ikon bileşeni.
class NotificationIcon extends ConsumerWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadAsync = ref.watch(unreadNotificationCountProvider);
    final unreadCount = unreadAsync.valueOrNull ?? 0;

    return IconButton(
      tooltip: 'Bildirimler',
      onPressed: () {
        context.push('/notifications');
      },
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications_outlined, size: 26),
          // Okunmamış bildirim varsa kırmızı sayaç rozeti çizilir
          if (unreadCount > 0)
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 1.4),
                ),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                alignment: Alignment.center,
                child: Text(
                  unreadCount > 9 ? '9+' : '$unreadCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
