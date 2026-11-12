// Kullanıcıya gelen davetleri ve sistem bildirimlerini gösteren ekrandır.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/models/notification_model.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/invitation_card.dart';
import '../../../shared/widgets/state_widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _handleAcceptInvitation(
    BuildContext context,
    WidgetRef ref,
    String invitationId,
  ) async {
    final user = ref.read(authProvider).user;
    if (user == null) return;
    try {
      await ref.read(invitationRepositoryProvider).acceptInvitation(
            invitationId: invitationId,
            currentUserId: user.id,
          );
      triggerGlobalRefresh(ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Daveti kabul ettiniz! Maç randevularınıza eklendi ve takım sohbetine erişiminiz açıldı.',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleRejectInvitation(
    BuildContext context,
    WidgetRef ref,
    String invitationId,
  ) async {
    final user = ref.read(authProvider).user;
    if (user == null) return;
    try {
      await ref.read(invitationRepositoryProvider).rejectInvitation(
            invitationId: invitationId,
            currentUserId: user.id,
          );
      triggerGlobalRefresh(ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Davet reddedildi.'),
            backgroundColor: AppColors.info,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invitationsAsync = ref.watch(incomingInvitationsProvider);
    final notificationsAsync = ref.watch(userNotificationsProvider);
    final user = ref.watch(authProvider).user;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bildirimler ve Davetler'),
        actions: [
          if (user != null)
            TextButton.icon(
              key: const Key('mark_all_notifications_read_btn'),
              onPressed: () async {
                await ref
                    .read(notificationRepositoryProvider)
                    .markAllAsRead(user.id);
                triggerGlobalRefresh(ref);
              },
              icon: const Icon(
                Icons.done_all_rounded,
                color: Colors.white,
                size: 18,
              ),
              label: const Text(
                'Tümünü Okundu İşaretle',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: invitationsAsync.when(
          loading: () =>
              const LoadingWidget(message: 'Bildirimler yükleniyor...'),
          error: (err, _) => AppErrorWidget(
            message: err.toString(),
            onRetry: () => triggerGlobalRefresh(ref),
          ),
          data: (invitations) {
            return notificationsAsync.when(
              loading: () => const LoadingWidget(),
              error: (err, _) => AppErrorWidget(message: err.toString()),
              data: (notifications) {
                final visibleNotifications =
                    notifications.where((n) => !n.isRead).toList();

                if (invitations.isEmpty && visibleNotifications.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.notifications_off_outlined,
                    title: 'Henüz Bildiriminiz Yok',
                    subtitle:
                        'Size gelen takım davetleri ve davet yanıt bildirimleri burada görüntülenecektir.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => triggerGlobalRefresh(ref),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (invitations.isNotEmpty) ...[
                        Text(
                          'Gelen Takım Davetleri (${invitations.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...invitations.map(
                          (inv) => InvitationCard(
                            key: Key('incoming_invitation_${inv.id}'),
                            invitation: inv,
                            onAccept: inv.isPending
                                ? () =>
                                    _handleAcceptInvitation(context, ref, inv.id)
                                : null,
                            onReject: inv.isPending
                                ? () =>
                                    _handleRejectInvitation(context, ref, inv.id)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (visibleNotifications.isNotEmpty) ...[
                        Text(
                          'Tüm Bildirim Kayıtları (${visibleNotifications.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...visibleNotifications.map((n) {
                          final IconData icon;
                          final Color iconColor;
                          switch (n.type) {
                            case NotificationType.teamInvitation:
                              icon = Icons.mail_outline_rounded;
                              iconColor = AppColors.info;
                            case NotificationType.invitationAccepted:
                              icon = Icons.check_circle_outline_rounded;
                              iconColor = AppColors.success;
                            case NotificationType.invitationRejected:
                              icon = Icons.cancel_outlined;
                              iconColor = AppColors.error;
                            case NotificationType.teamInfo:
                              icon = Icons.info_outline_rounded;
                              iconColor = theme.colorScheme.primary;
                          }

                          return Card(
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    iconColor.withValues(alpha: 0.15),
                                child: Icon(icon, color: iconColor),
                              ),
                              title: Text(
                                n.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(n.body),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDateTime(n.createdAt),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 11,
                                      color:
                                          theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.pitchGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year;
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d.$m.$y $h:$min';
  }
}
