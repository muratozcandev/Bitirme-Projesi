class Validators { // Validators veri/yardımcı sınıfını tanımlar
  Validators._(); // İlgili kod satırını ve işlemi yürütür

  static final RegExp _emailRegex = RegExp( // Sabit/final değişken veya nesne tanımını başlatır
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', // İlgili kod satırını ve işlemi yürütür
  ); // Açık olan kod/bileşen bloğunu kapatır

  static final RegExp _phoneRegex = RegExp( // Sabit/final değişken veya nesne tanımını başlatır
    r'^0?5\d{9}$', // İlgili kod satırını ve işlemi yürütür
  ); // Açık olan kod/bileşen bloğunu kapatır

  static bool isEmail(String value) { // İlgili kod satırını ve işlemi yürütür
    return _emailRegex.hasMatch(value.trim()); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  static String normalizePhone(String phone) { // İlgili kod satırını ve işlemi yürütür
    final digits = phone.replaceAll(RegExp(r'\D'), ''); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (digits.length == 10 && digits.startsWith('5')) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return '0$digits'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return digits; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  static bool isPhone(String value) { // İlgili kod satırını ve işlemi yürütür
    final normalized = normalizePhone(value); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return _phoneRegex.hasMatch(normalized); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  static String? validateIdentifier(String? value) { // İlgili kod satırını ve işlemi yürütür
    if (value == null || value.trim().isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return 'E-posta veya telefon numarası boş bırakılamaz.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  static String? validatePassword(String? value) { // İlgili kod satırını ve işlemi yürütür
    if (value == null || value.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return 'Şifre boş bırakılamaz.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    if (value.length < 4) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return 'Şifre en az 4 karakter olmalıdır.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  static String? validateRequired(String? value, String fieldName) { // İlgili kod satırını ve işlemi yürütür
    if (value == null || value.trim().isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return '$fieldName alanı zorunludur.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  static String? validateEmail(String? value) { // İlgili kod satırını ve işlemi yürütür
    if (value == null || value.trim().isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return 'E-posta adresi zorunludur.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    if (!isEmail(value)) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return 'Geçerli bir e-posta adresi giriniz.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır

  static String? validatePhone(String? value) { // İlgili kod satırını ve işlemi yürütür
    if (value == null || value.trim().isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return 'Telefon numarası zorunludur.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    if (!isPhone(value)) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return 'Geçerli bir telefon numarası giriniz (Örn: 05XXXXXXXXX).'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
    } // Açık olan kod/bileşen bloğunu kapatır
    return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

