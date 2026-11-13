// E-posta, telefon, şifre ve form alanları için doğrulama kurallarını içerir.

/// Kullanıcı form girdilerini düzenli ifadeler (RegExp) ve
/// iş kurallarıyla denetleyen statik doğrulama sınıfı.
class Validators {
  Validators._();

  // Standart e-posta formatı regex deseni
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Türkiye cep telefonu formatı (05XXXXXXXXX veya 5XXXXXXXXX) regex deseni
  static final RegExp _phoneRegex = RegExp(
    r'^0?5\d{9}$',
  );

  /// Girdinin geçerli bir e-posta formatında olup olmadığını kontrol eder
  static bool isEmail(String value) {
    return _emailRegex.hasMatch(value.trim());
  }

  /// Telefon numarasını rakamlardan arındırıp standart 11 haneli '05XXXXXXXXX' formatına dönüştürür
  static String normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10 && digits.startsWith('5')) {
      return '0$digits';
    }
    return digits;
  }

  /// Girdinin geçerli bir Türkiye cep telefonu formatında olup olmadığını kontrol eder
  static bool isPhone(String value) {
    final normalized = normalizePhone(value);
    return _phoneRegex.hasMatch(normalized);
  }

  /// Giriş ekranında e-posta veya telefon alanı boşluk kontrolü
  static String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta veya telefon numarası boş bırakılamaz.';
    }
    return null;
  }

  /// Şifre uzunluğu ve boşluk kontrolü (en az 4 karakter)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre boş bırakılamaz.';
    }
    if (value.length < 4) {
      return 'Şifre en az 4 karakter olmalıdır.';
    }
    return null;
  }

  /// Zorunlu metin alanları (Ad, Soyad vb.) boşluk kontrolü
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName alanı zorunludur.';
    }
    return null;
  }

  /// Kayıt formunda e-posta geçerlilik kontrolü
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresi zorunludur.';
    }
    if (!isEmail(value)) {
      return 'Geçerli bir e-posta adresi giriniz.';
    }
    return null;
  }

  /// Kayıt formunda cep telefonu geçerlilik kontrolü
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Telefon numarası zorunludur.';
    }
    if (!isPhone(value)) {
      return 'Geçerli bir telefon numarası giriniz (Örn: 05XXXXXXXXX).';
    }
    return null;
  }
}
