// Uygulama genelinde kullanılan sabit değerleri ve maç saat aralıklarını tutar.

class AppConstants {
  AppConstants._();

  static const String appName = '7v7';
  static const String appTagline = '7\'ye 7 Halı Saha Maç Organizasyonu';
  static const int maxPlayersPerTeam = 7;

  static const String prefActiveUserIdKey = 'active_user_id';
  static const String prefDefaultThemeKey = 'default_theme_mode';

  static List<String> get timeSlots {
    return List.generate(24, (hour) {
      final start = hour.toString().padLeft(2, '0');
      final nextHour = (hour + 1) % 24;
      final end = nextHour.toString().padLeft(2, '0');
      return '$start.00 - $end.00';
    });
  }

  static String startTimeFromSlot(String slot) {
    final parts = slot.split(' - ');
    return parts.isNotEmpty ? parts.first.trim() : '00.00';
  }

  static String endTimeFromSlot(String slot) {
    final parts = slot.split(' - ');
    return parts.length > 1 ? parts[1].trim() : '01.00';
  }
}
