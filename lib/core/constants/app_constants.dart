class AppConstants { // AppConstants veri/yardımcı sınıfını tanımlar
  AppConstants._(); // İlgili kod satırını ve işlemi yürütür

  static const String appName = '7v7'; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const String appTagline = '7\'ye 7 Halı Saha Maç Organizasyonu'; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const int maxPlayersPerTeam = 7; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  static const String prefActiveUserIdKey = 'active_user_id'; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  static const String prefDefaultThemeKey = 'default_theme_mode'; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  /// 24 farklı 1 saatlik maç aralığı (00.00 - 01.00 ... 23.00 - 00.00)
  static List<String> get timeSlots { // İlgili kod satırını ve işlemi yürütür
    return List.generate(24, (hour) { // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      final start = hour.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final nextHour = (hour + 1) % 24; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      final end = nextHour.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      return '$start.00 - $end.00'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    }); // İlgili kod satırını ve işlemi yürütür
  } // Açık olan kod/bileşen bloğunu kapatır

  static String startTimeFromSlot(String slot) { // İlgili kod satırını ve işlemi yürütür
    final parts = slot.split(' - '); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return parts.isNotEmpty ? parts.first.trim() : '00.00'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  static String endTimeFromSlot(String slot) { // İlgili kod satırını ve işlemi yürütür
    final parts = slot.split(' - '); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return parts.length > 1 ? parts[1].trim() : '01.00'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

