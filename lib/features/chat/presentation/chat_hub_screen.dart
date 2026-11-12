// Kullanıcının üyesi olduğu takımların sohbet odalarını listelediği ana sohbet ekranıdır.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/models/team_model.dart';
import '../../../shared/models/user_model.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/notification_icon.dart';
import '../../../shared/widgets/state_widgets.dart';
import '../../../shared/widgets/user_card.dart';

class ChatHubScreen extends ConsumerWidget {
  const ChatHubScreen({super.key});

  Future<void> _showInviteDialog(
    BuildContext context,
    WidgetRef ref,
    UserModel targetPlayer,
  ) async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    final captainTeams = await ref.read(captainTeamsProvider.future);
    if (!context.mounted) return;

    if (captainTeams.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Oyuncu davet edebilmek için önce "Takım Kur" sekmesinden bir takım oluşturmalısınız.',
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final teamsWithEmptySlots =
        captainTeams.where((t) => t.emptyPositions.isNotEmpty).toList();
    if (teamsWithEmptySlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Oluşturduğunuz tüm takımların kadrosu (7/7) dolu durumda.',
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    TeamModel selectedTeam = teamsWithEmptySlots.first;
    String selectedPositionKey = selectedTeam.emptyPositions.first.key;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final emptySlots = selectedTeam.emptyPositions;
            if (!emptySlots.any((s) => s.key == selectedPositionKey) &&
                emptySlots.isNotEmpty) {
              selectedPositionKey = emptySlots.first.key;
            }

            return AlertDialog(
              title: Text('${targetPlayer.fullName} — Davet Gönder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Davet göndermek istediğiniz takımı ve boş mevkiyi seçiniz:',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: selectedTeam.id,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Takım / Maç Seçin',
                        prefixIcon: Icon(Icons.stadium_outlined),
                      ),
                      items: teamsWithEmptySlots.map((team) {
                        return DropdownMenuItem<String>(
                          value: team.id,
                          child: Text(
                            '${team.venueName} (${team.formattedDate} ${team.timeSlot})',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      onChanged: (teamId) {
                        if (teamId == null) return;
                        final found = teamsWithEmptySlots
                            .firstWhere((t) => t.id == teamId);
                        setDialogState(() {
                          selectedTeam = found;
                          selectedPositionKey =
                              found.emptyPositions.first.key;
                        });
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      initialValue: selectedPositionKey,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Boş Mevki Seçin',
                        prefixIcon: Icon(Icons.sports_soccer_outlined),
                      ),
                      items: emptySlots.map((slot) {
                        return DropdownMenuItem<String>(
                          value: slot.key,
                          child: Text(
                            '${slot.label} (${selectedTeam.formation.label})',
                          ),
                        );
                      }).toList(),
                      onChanged: (posKey) {
                        if (posKey == null) return;
                        setDialogState(() {
                          selectedPositionKey = posKey;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('İptal'),
                ),
                ElevatedButton.icon(
                  key: const Key('confirm_send_invite_btn'),
                  onPressed: () async {
                    try {
                      await ref
                          .read(invitationRepositoryProvider)
                          .sendInvitation(
                            teamId: selectedTeam.id,
                            senderId: user.id,
                            receiverId: targetPlayer.id,
                            positionKey: selectedPositionKey,
                          );
                      triggerGlobalRefresh(ref);
                      if (ctx.mounted) {
                        Navigator.of(ctx).pop();
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${targetPlayer.fullName} oyuncusuna davet gönderildi (Durum: Beklemede).',
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    } catch (e) {
                      if (ctx.mounted) {
                        Navigator.of(ctx).pop();
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Daveti Gönder'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestedPlayersAsync = ref.watch(suggestedPlayersProvider);
    final chatTeamsAsync = ref.watch(userChatTeamsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Oyuncu Önerileri & Sohbet'),
          actions: const [
            NotificationIcon(),
            SizedBox(width: 4),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.pitchLightGreen,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            tabs: [
              Tab(
                key: Key('tab_player_suggestions'),
                icon: Icon(Icons.group_add_outlined),
                text: 'Oyuncu Önerileri',
              ),
              Tab(
                key: Key('tab_team_chat'),
                icon: Icon(Icons.chat_bubble_outline_rounded),
                text: 'Sohbet',
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              suggestedPlayersAsync.when(
                loading: () =>
                    const LoadingWidget(message: 'Oyuncular yükleniyor...'),
                error: (err, _) => AppErrorWidget(
                  message: err.toString(),
                  onRetry: () => triggerGlobalRefresh(ref),
                ),
                data: (players) {
                  if (players.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.people_outline_rounded,
                      title: 'Önerilecek Oyuncu Bulunamadı',
                      subtitle: 'Sistemde başka kayıtlı oyuncu bulunmuyor.',
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => triggerGlobalRefresh(ref),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: players.length,
                      itemBuilder: (ctx, index) {
                        final player = players[index];
                        return UserCard(
                          key: Key('suggested_user_card_${player.id}'),
                          player: player,
                          onInvitePressed: () =>
                              _showInviteDialog(context, ref, player),
                        );
                      },
                    ),
                  );
                },
              ),

              chatTeamsAsync.when(
                loading: () => const LoadingWidget(
                    message: 'Takım sohbetleri yükleniyor...'),
                error: (err, _) => AppErrorWidget(
                  message: err.toString(),
                  onRetry: () => triggerGlobalRefresh(ref),
                ),
                data: (teams) {
                  if (teams.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.forum_outlined,
                      title: 'Henüz Üyesi Olduğunuz Takım Yok',
                      subtitle:
                          'Takım sohbetine katılmak için yeni bir takım kurabilir veya size gelen bir takım davetini kabul edebilirsiniz.',
                      action: ElevatedButton.icon(
                        onPressed: () => context.go('/team-creation'),
                        icon: const Icon(Icons.sports_soccer),
                        label: const Text('Takım Kur'),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => triggerGlobalRefresh(ref),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: teams.length,
                      itemBuilder: (ctx, index) {
                        final team = teams[index];
                        return Card(
                          key: Key('chat_team_tile_${team.id}'),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              child: const Icon(
                                Icons.groups_rounded,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              '${team.captainName} Takımı (${team.formation.label})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  '${team.province} / ${team.district} — ${team.venueName}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Maç: ${team.formattedDate} • ${team.timeSlot} • ${team.members.length}/7 Oyuncu',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            trailing:
                                const Icon(Icons.chevron_right_rounded),
                            onTap: () {
                              context.push('/chat-room/${team.id}');
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
