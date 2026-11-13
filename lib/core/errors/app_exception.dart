// Uygulama içindeki iş kuralı ve servis hatalarını temsil eden özel hata sınıfıdır.

/// Kullanıcıya gösterilecek anlaşılır hata mesajlarını ve
/// hata kodlarını sarmalayan temel istisna (Exception) sınıfı.
class AppException implements Exception {
  /// Kullanıcı arayüzünde görüntülenecek Türkçe hata mesajı
  final String message;

  /// Hatanın teknik veya kategorik kodu (Örn: 'invalid-email', 'phone-already-in-use')
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}
