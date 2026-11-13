// Seçilen dizilişe göre futbol sahası görünümünü ve oyuncu mevkilerini çizen bileşendir.

import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/models/formation.dart';
import '../../../../shared/widgets/player_position_button.dart';

/// Yeşil çim şeritleri, saha çizgileri, ceza sahaları ve orta yuvarlağı
/// CustomPainter ile çizen, seçili dizilişe göre oyuncu butonlarını yerleştiren saha bileşeni.
class FootballPitchWidget extends StatelessWidget {
  final Formation formation;
  final Map<String, String> lineup;
  final String captainPositionKey;
  final void Function(PlayerPositionSlot slot) onPositionTap;

  const FootballPitchWidget({
    super.key,
    required this.formation,
    required this.lineup,
    required this.captainPositionKey,
    required this.onPositionTap,
  });

  @override
  Widget build(BuildContext context) {
    // Mevkileri forvet, orta saha, defans ve kaleci hatlarına ayırma
    final slots = formation.positions;
    final forwards =
        slots.where((s) => s.line == PositionLine.forward).toList();
    final midfielders =
        slots.where((s) => s.line == PositionLine.midfielder).toList();
    final defenders =
        slots.where((s) => s.line == PositionLine.defender).toList();
    final goalkeepers =
        slots.where((s) => s.line == PositionLine.goalkeeper).toList();

    return AspectRatio(
      aspectRatio: 0.76,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.85),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDarkGreen.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Halı saha çizgilerini ve çim dokusunu çizen özel ressam
            CustomPaint(
              painter: _PitchMarkingsPainter(),
            ),
            // Sahadaki hatları dikey eksende sıralama
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLineRow(forwards),
                  if (midfielders.isNotEmpty)
                    _buildLineRow(midfielders)
                  else
                    const SizedBox(height: 12),
                  _buildLineRow(defenders),
                  _buildLineRow(goalkeepers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Belirli bir hattaki (forvet, defans vb.) oyuncu mevkii butonlarını yatayda eşit aralıklarla çizer.
  Widget _buildLineRow(List<PlayerPositionSlot> rowSlots) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: rowSlots.map((slot) {
        return Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: PlayerPositionButton(
              key: Key('pitch_pos_${slot.key}'),
              slot: slot,
              playerName: lineup[slot.key],
              isCaptain: slot.key == captainPositionKey,
              onTap: () => onPositionTap(slot),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Halı sahanın çim tonlarını, taç ve kale çizgilerini, ceza sahalarını ve orta yuvarlağını çizen CustomPainter.
class _PitchMarkingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 8 adet açık ve koyu yeşil çim deseni şeridi çizimi
    const stripeCount = 8;
    final stripeHeight = size.height / stripeCount;
    for (var i = 0; i < stripeCount; i++) {
      final paint = Paint()
        ..color = i.isEven ? AppColors.pitchGrassDark : AppColors.pitchGrassLight;
      canvas.drawRect(
        Rect.fromLTWH(0, i * stripeHeight, size.width, stripeHeight),
        paint,
      );
    }

    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Dış saha sınır çizgisi
    final outerRect = Rect.fromLTWH(10, 10, size.width - 20, size.height - 20);
    canvas.drawRect(outerRect, linePaint);

    // Orta saha çizgisi ve orta daire
    final midY = size.height / 2;
    canvas.drawLine(
      Offset(10, midY),
      Offset(size.width - 10, midY),
      linePaint,
    );
    canvas.drawCircle(Offset(size.width / 2, midY), size.width * 0.14, linePaint);

    final spotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, midY), 3.5, spotPaint);

    // Ceza sahası yay ve kutuları
    final penaltyWidth = size.width * 0.54;
    final penaltyHeight = size.height * 0.14;
    final penaltyLeft = (size.width - penaltyWidth) / 2;

    canvas.drawRect(
      Rect.fromLTWH(penaltyLeft, 10, penaltyWidth, penaltyHeight),
      linePaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(
        penaltyLeft,
        size.height - 10 - penaltyHeight,
        penaltyWidth,
        penaltyHeight,
      ),
      linePaint,
    );

    // Kale alanı çizgileri
    final goalWidth = size.width * 0.28;
    final goalHeight = size.height * 0.055;
    final goalLeft = (size.width - goalWidth) / 2;

    canvas.drawRect(
      Rect.fromLTWH(goalLeft, 10, goalWidth, goalHeight),
      linePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        goalLeft,
        size.height - 10 - goalHeight,
        goalWidth,
        goalHeight,
      ),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
