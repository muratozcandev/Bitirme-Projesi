// Önerilen oyuncuları ve profil bilgilerini listeleyen kart bileşenidir.

import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Takıma oyuncu davet etme ekranında önerilen oyuncunun profil baş harflerini,
/// adını, e-posta adresini ve Davet Yolla butonunu içeren kart bileşeni.
class UserCard extends StatelessWidget {
  final UserModel player;
  final VoidCallback onInvitePressed;

  const UserCard({
    super.key,
    required this.player,
    required this.onInvitePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Kullanıcı baş harflerini gösteren profil avatarı
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                player.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Oyuncu adı ve e-posta adresi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.fullName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    player.email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Takıma davet etme butonu
            ElevatedButton.icon(
              key: Key('invite_player_btn_${player.id}'),
              onPressed: onInvitePressed,
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: const Text('Davet Yolla'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
