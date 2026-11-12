class AppException implements Exception { // Uygulama içi özel hata (AppException) sınıfını tanımlar
  final String message; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? code; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const AppException(this.message, {this.code}); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  String toString() => message; // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

