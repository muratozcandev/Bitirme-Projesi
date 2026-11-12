enum PositionLine { // PositionLine sabit seçenekler (enum) kümesini tanımlar
  goalkeeper, // İlgili kod satırını ve işlemi yürütür
  defender, // İlgili kod satırını ve işlemi yürütür
  midfielder, // İlgili kod satırını ve işlemi yürütür
  forward, // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

class PlayerPositionSlot { // PlayerPositionSlot veri/yardımcı sınıfını tanımlar
  final String key; // Örn: GK_1, DEF_1, MID_1, FWD_1
  final String label; // Örn: Kaleci, Defans 1, Orta Saha 1, Forvet 1
  final PositionLine line; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final int indexInLine; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final int totalInLine; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const PlayerPositionSlot({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.key, // key parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.label, // label parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.line, // line parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.indexInLine, // indexInLine parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.totalInLine, // totalInLine parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

enum Formation { // Formation sabit seçenekler (enum) kümesini tanımlar
  threeThree('3-3', 1, 3, 0, 3), // İlgili kod satırını ve işlemi yürütür
  threeOneTwo('3-1-2', 1, 3, 1, 2), // İlgili kod satırını ve işlemi yürütür
  threeTwoOne('3-2-1', 1, 3, 2, 1), // İlgili kod satırını ve işlemi yürütür
  twoThreeOne('2-3-1', 1, 2, 3, 1), // İlgili kod satırını ve işlemi yürütür
  twoOneThree('2-1-3', 1, 2, 1, 3), // İlgili kod satırını ve işlemi yürütür
  twoTwoTwo('2-2-2', 1, 2, 2, 2); // İlgili kod satırını ve işlemi yürütür

  final String label; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final int goalkeeperCount; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final int defenderCount; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final int midfielderCount; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final int forwardCount; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const Formation( // Sabit/final değişken veya nesne tanımını başlatır
    this.label, // label sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.goalkeeperCount, // goalkeeperCount sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.defenderCount, // defenderCount sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.midfielderCount, // midfielderCount sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.forwardCount, // forwardCount sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  ); // Açık olan kod/bileşen bloğunu kapatır

  static Formation fromLabel(String value) { // İlgili kod satırını ve işlemi yürütür
    return Formation.values.firstWhere( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      (f) => f.label == value || f.name == value, // İlgili kod satırını ve işlemi yürütür
      orElse: () => Formation.threeTwoOne, // orElse özelliğini yapılandırır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  List<PlayerPositionSlot> get positions { // İlgili kod satırını ve işlemi yürütür
    final slots = <PlayerPositionSlot>[ // Sabit/final değişken veya nesne tanımını başlatır
      const PlayerPositionSlot( // Sabit/final değişken veya nesne tanımını başlatır
        key: 'GK_1', // key özelliğini yapılandırır
        label: 'Kaleci', // label özelliğini yapılandırır
        line: PositionLine.goalkeeper, // line özelliğini yapılandırır
        indexInLine: 0, // indexInLine özelliğini yapılandırır
        totalInLine: 1, // totalInLine özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ]; // Açık olan kod/bileşen bloğunu kapatır

    for (var i = 0; i < defenderCount; i++) { // Koleksiyon veya aralık üzerinde döngü başlatır
      slots.add( // İlgili kod satırını ve işlemi yürütür
        PlayerPositionSlot( // İlgili kod satırını ve işlemi yürütür
          key: 'DEF_${i + 1}', // key özelliğini yapılandırır
          label: 'Defans ${i + 1}', // label özelliğini yapılandırır
          line: PositionLine.defender, // line özelliğini yapılandırır
          indexInLine: i, // indexInLine özelliğini yapılandırır
          totalInLine: defenderCount, // totalInLine özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    for (var i = 0; i < midfielderCount; i++) { // Koleksiyon veya aralık üzerinde döngü başlatır
      slots.add( // İlgili kod satırını ve işlemi yürütür
        PlayerPositionSlot( // İlgili kod satırını ve işlemi yürütür
          key: 'MID_${i + 1}', // key özelliğini yapılandırır
          label: midfielderCount == 1 ? 'Orta Saha 1' : 'Orta Saha ${i + 1}', // label özelliğini yapılandırır
          line: PositionLine.midfielder, // line özelliğini yapılandırır
          indexInLine: i, // indexInLine özelliğini yapılandırır
          totalInLine: midfielderCount, // totalInLine özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    for (var i = 0; i < forwardCount; i++) { // Koleksiyon veya aralık üzerinde döngü başlatır
      slots.add( // İlgili kod satırını ve işlemi yürütür
        PlayerPositionSlot( // İlgili kod satırını ve işlemi yürütür
          key: 'FWD_${i + 1}', // key özelliğini yapılandırır
          label: forwardCount == 1 ? 'Forvet 1' : 'Forvet ${i + 1}', // label özelliğini yapılandırır
          line: PositionLine.forward, // line özelliğini yapılandırır
          indexInLine: i, // indexInLine özelliğini yapılandırır
          totalInLine: forwardCount, // totalInLine özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    return slots; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  String labelForKey(String key) { // İlgili kod satırını ve işlemi yürütür
    for (final slot in positions) { // Koleksiyon veya aralık üzerinde döngü başlatır
      if (slot.key == key || slot.label == key) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        return slot.label; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    if (key.startsWith('GK')) return 'Kaleci'; // Koşulun sağlanıp sağlanmadığını kontrol eder
    if (key.startsWith('DEF_')) return 'Defans ${key.split('_').last}'; // Koşulun sağlanıp sağlanmadığını kontrol eder
    if (key.startsWith('MID_')) return 'Orta Saha ${key.split('_').last}'; // Koşulun sağlanıp sağlanmadığını kontrol eder
    if (key.startsWith('FWD_')) return 'Forvet ${key.split('_').last}'; // Koşulun sağlanıp sağlanmadığını kontrol eder
    return key; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  /// Diziliş değiştiğinde yalnızca yeni dizilişte karşılığı bulunan mevkileri korur;
  /// artık bulunmayan mevkilerdeki verileri sessizce başka mevkilere aktarmaz.
  Map<String, String> migrateLineup(Map<String, String> oldLineup) { // İlgili kod satırını ve işlemi yürütür
    final validKeys = positions.map((p) => p.key).toSet(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final migrated = <String, String>{}; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (final entry in oldLineup.entries) { // Koleksiyon veya aralık üzerinde döngü başlatır
      if (validKeys.contains(entry.key) && entry.value.trim().isNotEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        migrated[entry.key] = entry.value.trim(); // İlgili kod satırını ve işlemi yürütür
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
    return migrated; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

