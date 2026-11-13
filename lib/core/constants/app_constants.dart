// Uygulama genelinde kullanılan sabit değerleri ve maç saat aralıklarını tutar.

/// Uygulamanın genel yapılandırma değerlerini, depolama anahtarlarını
/// ve 24 saatlik maç periyotlarını barındıran sabitler sınıfı.
class AppConstants {
  AppConstants._();

  // Uygulama kimlik ve kural sabitleri
  static const String appName = '7v7';
  static const String appTagline = '7\'ye 7 Halı Saha Maç Organizasyonu';
  static const int maxPlayersPerTeam = 7;

  // SharedPreferences oturum ve tema saklama anahtarları
  static const String prefActiveUserIdKey = 'active_user_id';
  static const String prefDefaultThemeKey = 'default_theme_mode';

  /// 24 farklı 1 saatlik maç zaman aralığını üretir (Örn: '20.00 - 21.00')
  static List<String> get timeSlots {
    return List.generate(24, (hour) {
      final start = hour.toString().padLeft(2, '0');
      final nextHour = (hour + 1) % 24;
      final end = nextHour.toString().padLeft(2, '0');
      return '$start.00 - $end.00';
    });
  }

  /// Zaman aralığı dizesinden başlangıç saatini ayrıştırır
  static String startTimeFromSlot(String slot) {
    final parts = slot.split(' - ');
    return parts.isNotEmpty ? parts.first.trim() : '00.00';
  }

  /// Zaman aralığı dizesinden bitiş saatini ayrıştırır
  static String endTimeFromSlot(String slot) {
    final parts = slot.split(' - ');
    return parts.length > 1 ? parts[1].trim() : '01.00';
  }
}
