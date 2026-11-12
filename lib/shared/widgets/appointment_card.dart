import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';
import '../models/team_member_model.dart';
import '../models/team_model.dart';

class AppointmentCard extends StatelessWidget {
  final TeamModel team;
  final String currentUserId;
  final VoidCallback onDeleteConfirmed;

  const AppointmentCard({
    super.key,
    required this.team,
    required this.currentUserId,
    required this.onDeleteConfirmed,
  });

  bool get _isCaptain => team.captainId == currentUserId;

  String get _userRoleLabel {
    if (_isCaptain) return 'Takım Kaptanı';
    final myMember =
        team.members.where((m) => m.userId == currentUserId).firstOrNull;
    if (myMember != null) {
      final posLabel = team.formation.labelForKey(myMember.position);
      return 'Oyuncu ($posLabel)';
    }
    return 'Takım Üyesi';
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Randevuyu Sil'),
        content: const Text(
          'Bu maç randevusunu randevu listenizden silmek istediğinize emin misiniz?\n\nNot: Kendi listenizden silmeniz diğer takım oyuncularının randevusunu silmez.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            key: const Key('confirm_delete_appointment_btn'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Randevuyu Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onDeleteConfirmed();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slots = team.formation.positions;
    final memberByPosition = <String, TeamMemberModel>{
      for (final m in team.members) m.position: m,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Üst Başlık + Rol Rozeti + Üç Nokta Menüsü
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(
                    Icons.sports_soccer,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${team.captainName} Takımı (7v7)',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _isCaptain
                                  ? AppColors.goldAccent.withValues(alpha: 0.2)
                                  : theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Rolünüz: $_userRoleLabel',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: _isCaptain
                                    ? const Color(0xFFB45309)
                                    : theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Diziliş: ${team.formation.label}',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  key: Key('appointment_menu_${team.id}'),
                  tooltip: 'Seçenekler',
                  icon: const Icon(Icons.more_vert_rounded),
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteDialog(context);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.error,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Randevuyu Sil',
                            style: TextStyle(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Konum, Tarih ve Saat Bilgileri
            _InfoRow(
              icon: Icons.location_on_outlined,
              label: 'İl / İlçe:',
              value: '${team.province} / ${team.district}',
            ),
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.stadium_outlined,
              label: 'Halı Saha:',
              value: team.venueName,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Tarih:',
                    value: team.formattedDate,
                  ),
                ),
                Expanded(
                  child: _InfoRow(
                    icon: Icons.access_time_rounded,
                    label: 'Saat:',
                    value: team.timeSlot,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Takım Kadrosu (7 Mevki)
            Text(
              'Takım Kadrosu (${team.members.length}/7 Dolu)',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: slots.map((slot) {
                final member = memberByPosition[slot.key];
                final hasMember =
                    member != null && member.displayName.trim().isNotEmpty;
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: hasMember
                        ? theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.45)
                        : theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: hasMember
                          ? theme.colorScheme.primary.withValues(alpha: 0.35)
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasMember
                            ? Icons.person_rounded
                            : Icons.person_outline_rounded,
                        size: 14,
                        color: hasMember
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${slot.label}: ',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        hasMember ? member.displayName : 'Boş',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight:
                              hasMember ? FontWeight.w800 : FontWeight.w500,
                          color: hasMember
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 17, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

