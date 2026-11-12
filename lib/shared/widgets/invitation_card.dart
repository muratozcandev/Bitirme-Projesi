import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';
import '../models/invitation_model.dart';
import '../models/team_member_model.dart';

class InvitationCard extends StatelessWidget {
  final InvitationModel invitation;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const InvitationCard({
    super.key,
    required this.invitation,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final team = invitation.team;
    if (team == null) {
      return const SizedBox.shrink();
    }

    final invitedPositionLabel = team.formation.labelForKey(invitation.position);
    final slots = team.formation.positions;
    final memberByPosition = <String, TeamMemberModel>{
      for (final m in team.members) m.position: m,
    };

    final Color statusColor;
    switch (invitation.status) {
      case InvitationStatus.pending:
        statusColor = AppColors.warning;
      case InvitationStatus.accepted:
        statusColor = AppColors.success;
      case InvitationStatus.rejected:
      case InvitationStatus.cancelled:
        statusColor = AppColors.error;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.colorScheme.primary,
                  child: const Icon(
                    Icons.mail_outline_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Davet Gönderen: ${invitation.senderName}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Davet Edilen Mevki: $invitedPositionLabel',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    invitation.status.labelTr,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            _DetailLine(
              label: 'İl / İlçe:',
              value: '${team.province} / ${team.district}',
            ),
            _DetailLine(
              label: 'Halı Saha:',
              value: team.venueName,
            ),
            _DetailLine(
              label: 'Tarih / Saat:',
              value: '${team.formattedDate} • ${team.timeSlot}',
            ),
            _DetailLine(
              label: 'Diziliş:',
              value: team.formation.label,
            ),
            const SizedBox(height: 8),
            Text(
              'Takım Kadrosu:',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: slots.map((slot) {
                final member = memberByPosition[slot.key];
                final isTargetSlot = slot.key == invitation.position;
                final text = member != null && member.displayName.isNotEmpty
                    ? member.displayName
                    : (isTargetSlot && invitation.isPending
                        ? 'Sizin İçin Ayrıldı'
                        : 'Boş');

                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isTargetSlot
                        ? AppColors.pitchGreen.withValues(alpha: 0.18)
                        : theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isTargetSlot
                          ? AppColors.pitchGreen
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    '${slot.label}: $text',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isTargetSlot ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
            if (invitation.isPending &&
                onAccept != null &&
                onReject != null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: Key('reject_invite_btn_${invitation.id}'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      onPressed: onReject,
                      icon: const Icon(Icons.close_rounded, size: 18),
                      label: const Text('Reddet'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      key: Key('accept_invite_btn_${invitation.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: onAccept,
                      icon: const Icon(Icons.check_rounded, size: 18),
                      label: const Text('Kabul Et'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _DetailLine({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

