import '../../core/utils/password_hasher.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../shared/models/user_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class SeedData { // SeedData veri/yardımcı sınıfını tanımlar
  SeedData._(); // İlgili kod satırını ve işlemi yürütür

  static final DateTime _seedTime = DateTime.utc(2026, 1, 1, 12, 0); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  /// PROJECT.md Bölüm 6'da tanımlanan 10 önceden kayıtlı test hesabı
  static List<UserModel> get predefinedUsers => [ // İlgili kod satırını ve işlemi yürütür
        UserModel( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_1', // id özelliğini yapılandırır
          firstName: 'cristiano', // firstName özelliğini yapılandırır
          lastName: 'Ronaldo', // lastName özelliğini yapılandırır
          email: 'cr7@gmail.com', // email özelliğini yapılandırır
          phone: '05111111111', // phone özelliğini yapılandırır
          passwordHash: PasswordHasher.hash('cris7'), // passwordHash özelliğini yapılandırır
          themeMode: 'light', // themeMode özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        UserModel( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_2', // id özelliğini yapılandırır
          firstName: 'lionel', // firstName özelliğini yapılandırır
          lastName: 'messi', // lastName özelliğini yapılandırır
          email: 'm10@gmail.com', // email özelliğini yapılandırır
          phone: '05222222222', // phone özelliğini yapılandırır
          passwordHash: PasswordHasher.hash('messi10'), // passwordHash özelliğini yapılandırır
          themeMode: 'light', // themeMode özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        UserModel( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_3', // id özelliğini yapılandırır
          firstName: 'Manuel', // firstName özelliğini yapılandırır
          lastName: 'neur', // lastName özelliğini yapılandırır
          email: 'neur1@gmail.com', // email özelliğini yapılandırır
          phone: '05333333333', // phone özelliğini yapılandırır
          passwordHash: PasswordHasher.hash('neur1'), // passwordHash özelliğini yapılandırır
          themeMode: 'light', // themeMode özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        UserModel( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_4', // id özelliğini yapılandırır
          firstName: 'Sergio', // firstName özelliğini yapılandırır
          lastName: 'Ramos', // lastName özelliğini yapılandırır
          email: 'ramos4@gmail.com', // email özelliğini yapılandırır
          phone: '05444444444', // phone özelliğini yapılandırır
          passwordHash: PasswordHasher.hash('ramos4'), // passwordHash özelliğini yapılandırır
          themeMode: 'light', // themeMode özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        UserModel( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_5', // id özelliğini yapılandırır
          firstName: 'lamine', // firstName özelliğini yapılandırır
          lastName: 'yamal', // lastName özelliğini yapılandırır
          email: 'lamine@gmail.com', // email özelliğini yapılandırır
          phone: '05555555555', // phone özelliğini yapılandırır
          passwordHash: PasswordHasher.hash('yamal10'), // passwordHash özelliğini yapılandırır
          themeMode: 'light', // themeMode özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        UserModel( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_6', // id özelliğini yapılandırır
          firstName: 'kylian', // firstName özelliğini yapılandırır
          lastName: 'mbappe', // lastName özelliğini yapılandırır
          email: 'mbappe@gmail.com', // email özelliğini yapılandırır
          phone: '05666666666', // phone özelliğini yapılandırır
          passwordHash: PasswordHasher.hash('mbappe10'), // passwordHash özelliğini yapılandırır
          themeMode: 'light', // themeMode özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        UserModel( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_7', // id özelliğini yapılandırır
          firstName: 'hary', // firstName özelliğini yapılandırır
          lastName: 'kane', // lastName özelliğini yapılandırır
          email: 'kane@gmail.com', // email özelliğini yapılandırır
          phone: '05777777777', // phone özelliğini yapılandırır
          passwordHash: PasswordHasher.hash('kane9'), // passwordHash özelliğini yapılandırır
          themeMode: 'light', // themeMode özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        UserModel( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_8', // id özelliğini yapılandırır
          firstName: 'erling', // firstName özelliğini yapılandırır
          lastName: 'Haaland', // lastName özelliğini yapılandırır
          email: 'haaland@gmail.com', // email özelliğini yapılandırır
          phone: '05888888888', // phone özelliğini yapılandırır
          passwordHash: PasswordHasher.hash('haaland9'), // passwordHash özelliğini yapılandırır
          themeMode: 'light', // themeMode özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        UserModel( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_9', // id özelliğini yapılandırır
          firstName: 'ronaldinho', // firstName özelliğini yapılandırır
          lastName: 'gaucho', // lastName özelliğini yapılandırır
          email: 'r10@gmail.com', // email özelliğini yapılandırır
          phone: '05999999999', // phone özelliğini yapılandırır
          passwordHash: PasswordHasher.hash('ronaldinho10'), // passwordHash özelliğini yapılandırır
          themeMode: 'light', // themeMode özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
        UserModel( // İlgili kod satırını ve işlemi yürütür
          id: 'seed_user_10', // id özelliğini yapılandırır
          firstName: 'arjen', // firstName özelliğini yapılandırır
          lastName: 'Robben', // lastName özelliğini yapılandırır
          email: 'robben@gmail.com', // email özelliğini yapılandırır
          phone: '05000000000', // phone özelliğini yapılandırır
          passwordHash: PasswordHasher.hash('robben10'), // passwordHash özelliğini yapılandırır
          themeMode: 'light', // themeMode özelliğini yapılandırır
          createdAt: _seedTime, // createdAt özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ]; // Açık olan kod/bileşen bloğunu kapatır

  static const List<String> _venueSuffixes = [ // Sabit/final değişken veya nesne tanımını başlatır
    'Arena 7v7 Halı Saha (Test)', // İlgili kod satırını ve işlemi yürütür
    'Yıldızlar Spor Kompleksi (Test)', // İlgili kod satırını ve işlemi yürütür
    'Şampiyonlar Halı Saha Tesisleri (Test)', // İlgili kod satırını ve işlemi yürütür
    'Elit Park Halı Saha (Test)', // İlgili kod satırını ve işlemi yürütür
    'Olimpiyat 7\'ye 7 Halı Saha (Test)', // İlgili kod satırını ve işlemi yürütür
    'Santra Halı Saha & Sosyal Tesis (Test)', // İlgili kod satırını ve işlemi yürütür
  ]; // Açık olan kod/bileşen bloğunu kapatır

  /// İl ve ilçeye göre deterministik (ekran yenilendiğinde değişmeyen) örnek halı saha listesi üretir.
  static List<String> generateDeterministicVenues(String province, String district) { // İlgili kod satırını ve işlemi yürütür
    final hash = (province.hashCode ^ district.hashCode).abs(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final count = 3 + (hash % 3); // Her ilçede 3 ile 5 arası sabit örnek halı saha
    final venues = <String>[]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    for (var i = 0; i < count; i++) { // Koleksiyon veya aralık üzerinde döngü başlatır
      final suffix = _venueSuffixes[(hash + i) % _venueSuffixes.length]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
      venues.add('$district $suffix'); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
    return venues; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

