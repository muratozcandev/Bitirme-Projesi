// Kullanıcının katıldığı maç randevularını ve davet durumlarını listelediği ekrandır.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/appointment_card.dart';
import '../../../shared/widgets/notification_icon.dart';
import '../../../shared/widgets/state_widgets.dart';

/// Kullanıcının kaptan veya oyuncu olarak dahil olduğu tüm aktif maç randevularını
/// tarih ve saat sırasıyla listeleyen, randevuyu listeden silme imkanı sunan ekran.
class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(userAppointmentsProvider);
    final user = ref.watch(authProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevularım'),
        actions: const [
          NotificationIcon(),
          SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: appointmentsAsync.when(
          loading: () =>
              const LoadingWidget(message: 'Randevularınız yükleniyor...'),
          error: (err, _) => AppErrorWidget(
            message: err.toString(),
            onRetry: () => triggerGlobalRefresh(ref),
          ),
          data: (appointments) {
            // Kayıtlı randevu bulunmuyorsa gösterilen boş durum
            if (appointments.isEmpty || user == null) {
              return EmptyStateWidget(
                icon: Icons.event_busy_rounded,
                title: 'Henüz Maç Randevunuz Yok',
                subtitle:
                    'Takım Kur sekmesinden yeni bir 7v7 maç organizasyonu oluşturabilir veya size gelen takım davetlerini kabul edebilirsiniz.',
                action: ElevatedButton.icon(
                  onPressed: () => context.go('/team-creation'),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Yeni Takım Kur'),
                ),
              );
            }

            // Randevu kartlarının listelendiği yenilenebilir liste
            return RefreshIndicator(
              onRefresh: () async => triggerGlobalRefresh(ref),
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final team = appointments[index];
                  return AppointmentCard(
                    key: Key('appointment_card_${team.id}'),
                    team: team,
                    currentUserId: user.id,
                    onDeleteConfirmed: () async {
                      await ref
                          .read(teamRepositoryProvider)
                          .deleteAppointmentForUser(
                            teamId: team.id,
                            userId: user.id,
                          );
                      triggerGlobalRefresh(ref);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Randevu listenizden başarıyla silindi.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
