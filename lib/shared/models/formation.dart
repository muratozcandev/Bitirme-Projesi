enum PositionLine {
  goalkeeper,
  defender,
  midfielder,
  forward,
}

class PlayerPositionSlot {
  final String key; // Örn: GK_1, DEF_1, MID_1, FWD_1
  final String label; // Örn: Kaleci, Defans 1, Orta Saha 1, Forvet 1
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

  static Formation fromLabel(String value) {
    return Formation.values.firstWhere(
      (f) => f.label == value || f.name == value,
      orElse: () => Formation.threeTwoOne,
    );
  }

  List<PlayerPositionSlot> get positions {
    final slots = <PlayerPositionSlot>[
      const PlayerPositionSlot(
        key: 'GK_1',
        label: 'Kaleci',
        line: PositionLine.goalkeeper,
        indexInLine: 0,
        totalInLine: 1,
      ),
    ];

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

  /// Diziliş değiştiğinde yalnızca yeni dizilişte karşılığı bulunan mevkileri korur;
  /// artık bulunmayan mevkilerdeki verileri sessizce başka mevkilere aktarmaz.
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

