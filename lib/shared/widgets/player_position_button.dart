// Futbol sahası üzerinde her bir oyuncu mevkisini gösteren tıklanabilir bileşendir.

import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';
import '../models/formation.dart';

/// Halı saha taktik tahtası üzerinde her bir mevkii yuvasını (kaleci, defans, orta saha, forvet)
/// temsil eden, oyuncu atanmışlık durumuna veya kaptanlığa göre renk ve rozet gösteren buton.
class PlayerPositionButton extends StatelessWidget {
  final PlayerPositionSlot slot;
  final String? playerName;
  final bool isCaptain;
  final VoidCallback onTap;

  const PlayerPositionButton({
    super.key,
    required this.slot,
    this.playerName,
    this.isCaptain = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasPlayer = playerName != null && playerName!.trim().isNotEmpty;
    final isGk = slot.line == PositionLine.goalkeeper;

    // Rol ve mevkiiye göre forma arka plan rengini belirleme
    final Color jerseyColor;
    if (isCaptain) {
      jerseyColor = AppColors.goldAccent;
    } else if (isGk) {
      jerseyColor = const Color(0xFF0284C7);
    } else if (hasPlayer) {
      jerseyColor = AppColors.pitchLightGreen;
    } else {
      jerseyColor = Colors.white.withValues(alpha: 0.25);
    }

    return Semantics(
      button: true,
      label: '${slot.label} ${hasPlayer ? playerName : "Boş"}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minWidth: 78, maxWidth: 102),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.48),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasPlayer
                  ? (isCaptain ? AppColors.goldAccent : AppColors.pitchLightGreen)
                  : Colors.white.withValues(alpha: 0.55),
              width: hasPlayer ? 1.8 : 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Forma ikonu ve kaptanlık 'K' rozeti
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: jerseyColor,
                    child: Icon(
                      hasPlayer ? Icons.person : Icons.add,
                      size: 18,
                      color: hasPlayer && (isCaptain || !isGk)
                          ? const Color(0xFF052E16)
                          : Colors.white,
                    ),
                  ),
                  if (isCaptain)
                    Positioned(
                      right: -5,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDarkGreen,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                              color: AppColors.goldAccent, width: 1),
                        ),
                        child: const Text(
                          'K',
                          style: TextStyle(
                            color: AppColors.goldAccent,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),

              // Mevki etiketi ve oyuncu adı (veya Boş)
              Text(
                slot.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFD1FAE5),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                hasPlayer ? playerName! : 'Boş',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: hasPlayer ? Colors.white : Colors.white70,
                  fontSize: 11,
                  fontWeight: hasPlayer ? FontWeight.w800 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
