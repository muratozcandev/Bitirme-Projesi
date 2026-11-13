// 7v7 maç dizilişlerini (formasyonları) ve saha içi mevki koordinatlarını tanımlar.

/// Futbol sahasındaki genel mevki hatlarını belirten numaralandırma.
enum PositionLine {
  goalkeeper,
  defender,
  midfielder,
  forward,
}

/// Saha grafiği üzerindeki tek bir oyuncu mevki yuvasını ve koordinat bilgilerini temsil eden sınıf.
class PlayerPositionSlot {
  final String key;
  final String label;
  final PositionLine line;
  final int indexInLine;
  final int totalInLine;

  const PlayerPositionSlot({
    required this.key,
    required this.label,
    required this.line,
    required this.indexInLine,
    required this.totalInLine,
  });
}

/// 7v7 maçları için desteklenen 6 farklı taktiksel diziliş ve mevki dağılımları.
enum Formation {
  threeThree('3-3', 1, 3, 0, 3),
  threeOneTwo('3-1-2', 1, 3, 1, 2),
  threeTwoOne('3-2-1', 1, 3, 2, 1),
  twoThreeOne('2-3-1', 1, 2, 3, 1),
  twoOneThree('2-1-3', 1, 2, 1, 3),
  twoTwoTwo('2-2-2', 1, 2, 2, 2);

  final String label;
  final int goalkeeperCount;
  final int defenderCount;
  final int midfielderCount;
  final int forwardCount;

  const Formation(
    this.label,
    this.goalkeeperCount,
    this.defenderCount,
    this.midfielderCount,
    this.forwardCount,
  );

  /// Etiket veya isim üzerinden ilgili Formation enum elemanını bulur
  static Formation fromLabel(String value) {
    return Formation.values.firstWhere(
      (f) => f.label == value || f.name == value,
      orElse: () => Formation.threeTwoOne,
    );
  }

  /// Seçili dizilişe ait Kaleci dahil tam 7 mevki yuvasını sırayla üretir
  List<PlayerPositionSlot> get positions {
    final slots = <PlayerPositionSlot>[
      // 1. Kaleci
      const PlayerPositionSlot(
        key: 'GK_1',
        label: 'Kaleci',
        line: PositionLine.goalkeeper,
        indexInLine: 0,
        totalInLine: 1,
      ),
    ];

    // 2. Defans hattı mevkileri
    for (var i = 0; i < defenderCount; i++) {
      slots.add(
        PlayerPositionSlot(
          key: 'DEF_${i + 1}',
          label: 'Defans ${i + 1}',
          line: PositionLine.defender,
          indexInLine: i,
          totalInLine: defenderCount,
        ),
      );
    }

    // 3. Orta saha hattı mevkileri
    for (var i = 0; i < midfielderCount; i++) {
      slots.add(
        PlayerPositionSlot(
          key: 'MID_${i + 1}',
          label: midfielderCount == 1 ? 'Orta Saha 1' : 'Orta Saha ${i + 1}',
          line: PositionLine.midfielder,
          indexInLine: i,
          totalInLine: midfielderCount,
        ),
      );
    }

    // 4. Forvet (hücum) hattı mevkileri
    for (var i = 0; i < forwardCount; i++) {
      slots.add(
        PlayerPositionSlot(
          key: 'FWD_${i + 1}',
          label: forwardCount == 1 ? 'Forvet 1' : 'Forvet ${i + 1}',
          line: PositionLine.forward,
          indexInLine: i,
          totalInLine: forwardCount,
        ),
      );
    }

    return slots;
  }

  /// Mevki anahtarına (Örn: 'DEF_1') karşılık gelen kullanıcı dostu Türkçe başlığı döndürür
  String labelForKey(String key) {
    for (final slot in positions) {
      if (slot.key == key || slot.label == key) {
        return slot.label;
      }
    }
    if (key.startsWith('GK')) return 'Kaleci';
    if (key.startsWith('DEF_')) return 'Defans ${key.split('_').last}';
    if (key.startsWith('MID_')) return 'Orta Saha ${key.split('_').last}';
    if (key.startsWith('FWD_')) return 'Forvet ${key.split('_').last}';
    return key;
  }

  /// Diziliş değiştirildiğinde önceki kadrodaki eşleşen mevkileri koruyup geçersiz olanları filtreler
  Map<String, String> migrateLineup(Map<String, String> oldLineup) {
    final validKeys = positions.map((p) => p.key).toSet();
    final migrated = <String, String>{};
    for (final entry in oldLineup.entries) {
      if (validKeys.contains(entry.key) && entry.value.trim().isNotEmpty) {
        migrated[entry.key] = entry.value.trim();
      }
    }
    return migrated;
  }
}
