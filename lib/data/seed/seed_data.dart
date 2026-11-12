import '../../core/utils/password_hasher.dart';
import '../../shared/models/user_model.dart';

class SeedData {
  SeedData._();

  static final DateTime _seedTime = DateTime.utc(2026, 1, 1, 12, 0);

  /// PROJECT.md Bölüm 6'da tanımlanan 10 önceden kayıtlı test hesabı
  static List<UserModel> get predefinedUsers => [
        UserModel(
          id: 'seed_user_1',
          firstName: 'cristiano',
          lastName: 'Ronaldo',
          email: 'cr7@gmail.com',
          phone: '05111111111',
          passwordHash: PasswordHasher.hash('cris7'),
          themeMode: 'light',
          createdAt: _seedTime,
        ),
        UserModel(
          id: 'seed_user_2',
          firstName: 'lionel',
          lastName: 'messi',
          email: 'm10@gmail.com',
          phone: '05222222222',
          passwordHash: PasswordHasher.hash('messi10'),
          themeMode: 'light',
          createdAt: _seedTime,
        ),
        UserModel(
          id: 'seed_user_3',
          firstName: 'Manuel',
          lastName: 'neur',
          email: 'neur1@gmail.com',
          phone: '05333333333',
          passwordHash: PasswordHasher.hash('neur1'),
          themeMode: 'light',
          createdAt: _seedTime,
        ),
        UserModel(
          id: 'seed_user_4',
          firstName: 'Sergio',
          lastName: 'Ramos',
          email: 'ramos4@gmail.com',
          phone: '05444444444',
          passwordHash: PasswordHasher.hash('ramos4'),
          themeMode: 'light',
          createdAt: _seedTime,
        ),
        UserModel(
          id: 'seed_user_5',
          firstName: 'lamine',
          lastName: 'yamal',
          email: 'lamine@gmail.com',
          phone: '05555555555',
          passwordHash: PasswordHasher.hash('yamal10'),
          themeMode: 'light',
          createdAt: _seedTime,
        ),
        UserModel(
          id: 'seed_user_6',
          firstName: 'kylian',
          lastName: 'mbappe',
          email: 'mbappe@gmail.com',
          phone: '05666666666',
          passwordHash: PasswordHasher.hash('mbappe10'),
          themeMode: 'light',
          createdAt: _seedTime,
        ),
        UserModel(
          id: 'seed_user_7',
          firstName: 'hary',
          lastName: 'kane',
          email: 'kane@gmail.com',
          phone: '05777777777',
          passwordHash: PasswordHasher.hash('kane9'),
          themeMode: 'light',
          createdAt: _seedTime,
        ),
        UserModel(
          id: 'seed_user_8',
          firstName: 'erling',
          lastName: 'Haaland',
          email: 'haaland@gmail.com',
          phone: '05888888888',
          passwordHash: PasswordHasher.hash('haaland9'),
          themeMode: 'light',
          createdAt: _seedTime,
        ),
        UserModel(
          id: 'seed_user_9',
          firstName: 'ronaldinho',
          lastName: 'gaucho',
          email: 'r10@gmail.com',
          phone: '05999999999',
          passwordHash: PasswordHasher.hash('ronaldinho10'),
          themeMode: 'light',
          createdAt: _seedTime,
        ),
        UserModel(
          id: 'seed_user_10',
          firstName: 'arjen',
          lastName: 'Robben',
          email: 'robben@gmail.com',
          phone: '05000000000',
          passwordHash: PasswordHasher.hash('robben10'),
          themeMode: 'light',
          createdAt: _seedTime,
        ),
      ];

  static const List<String> _venueSuffixes = [
    'Arena 7v7 Halı Saha (Test)',
    'Yıldızlar Spor Kompleksi (Test)',
    'Şampiyonlar Halı Saha Tesisleri (Test)',
    'Elit Park Halı Saha (Test)',
    'Olimpiyat 7\'ye 7 Halı Saha (Test)',
    'Santra Halı Saha & Sosyal Tesis (Test)',
  ];

  /// İl ve ilçeye göre deterministik (ekran yenilendiğinde değişmeyen) örnek halı saha listesi üretir.
  static List<String> generateDeterministicVenues(String province, String district) {
    final hash = (province.hashCode ^ district.hashCode).abs();
    final count = 3 + (hash % 3); // Her ilçede 3 ile 5 arası sabit örnek halı saha
    final venues = <String>[];
    for (var i = 0; i < count; i++) {
      final suffix = _venueSuffixes[(hash + i) % _venueSuffixes.length];
      venues.add('$district $suffix');
    }
    return venues;
  }
}

