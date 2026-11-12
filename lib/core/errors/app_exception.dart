// Uygulama içindeki iş kuralı ve servis hatalarını temsil eden özel hata sınıfıdır.

class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, {this.code});

  @override
  String toString() => message;
}
