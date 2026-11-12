// E-posta, telefon, şifre ve form alanları için doğrulama kurallarını içerir.

class Validators {
  Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phoneRegex = RegExp(
    r'^0?5\d{9}$',
  );

  static bool isEmail(String value) {
    return _emailRegex.hasMatch(value.trim());
  }

  static String normalizePhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10 && digits.startsWith('5')) {
      return '0$digits';
    }
    return digits;
  }

  static bool isPhone(String value) {
    final normalized = normalizePhone(value);
    return _phoneRegex.hasMatch(normalized);
  }

  static String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta veya telefon numarası boş bırakılamaz.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Şifre boş bırakılamaz.';
    }
    if (value.length < 4) {
      return 'Şifre en az 4 karakter olmalıdır.';
    }
    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName alanı zorunludur.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-posta adresi zorunludur.';
    }
    if (!isEmail(value)) {
      return 'Geçerli bir e-posta adresi giriniz.';
    }
    return null;
  }

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
