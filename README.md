# ⚽ 7v7 - Halı Saha Maç Organizasyon ve Takım Kurma Platformu

**7v7**, futbolseverlerin halı saha maçı organize etme, eksik mevkileri tamamlama ve takım yönetimi süreçlerini dijitalleştiren kapsamlı bir mobil platformdur. Halı saha maçlarında yaşanan *"oyuncu eksikliği"*, *"mevki karmaşası"*, *"iletişim kopuklukları"* ve *"organizasyon zorlukları"* gibi temel sorunlara modern, pratik ve interaktif bir çözüm sunar.

---

## 📌 Projenin Ana Fikri ve Amacı

Geleneksel halı saha organizasyonları genellikle dağınık mesajlaşma grupları ve telefon trafiği üzerinden yürütülür; bu durum son dakika iptallerine, eksik kadrolara veya dengesiz mevki dağılımlarına yol açar. 

**7v7**'nin temel amacı:
- **Kaptanlara**; saha, tarih, saat ve taktiksel diziliş belirleyerek dakikalar içinde 7'ye 7 takım kurma olanağı sağlamak,
- **İnteraktif Futbol Sahası (Taktik Tahtası)** üzerinden oyuncuları gerçek mevkilerine (Kaleci, Defans, Orta Saha, Forvet) yerleştirmek,
- Boş kalan mevkiler için sistemdeki diğer uygun oyunculara **birebir mevki daveti** göndermek,
- Takım üyelerinin maç saatine kadar strateji konuşabileceği ve koordinasyon kurabileceği **özel takım sohbet odaları** sunmak,
- Çevrimiçi bulut altyapısının (Firebase) yanı sıra **çevrimdışı (offline-first) yerel veritabanı desteğiyle** ağ kesintilerinde dahi kesintisiz bir kullanıcı deneyimi yaşatmaktır.

---

## 🏗️ Yazılım Mimarisi (Architecture)

Proje, sürdürülebilir, test edilebilir ve ölçeklenebilir bir kod tabanı sağlamak amacıyla **Feature-First (Özellik Odaklı)** ve **Clean Architecture** prensipleri harmanlanarak geliştirilmiştir.

```
lib/
├── app/                  # Uygulama kökü, tema tanımları ve GoRouter yapılandırması
├── core/                 # Sabitler, hata yönetimi (AppException), veri doğrulayıcılar ve şifreleme
├── data/                 # SQLite veritabanı kurulumu (AppDatabase) ve tohumlama (Seed Data)
├── features/             # Özellik bazlı modüller (Feature-Driven)
│   ├── appointments/     # Randevu ve maç geçmişi
│   ├── authentication/   # Giriş, kayıt ve oturum yönetimi (Data, Domain, Presentation)
│   ├── chat/             # Takım içi anlık mesajlaşma
│   ├── legal/            # Kullanıcı Sözleşmesi ve KVKK metinleri/onayları
│   ├── notifications/    # Davet ve sistem bildirimleri
│   ├── profile/          # Kullanıcı profili, tema ayarı ve oyuncu arama
│   └── team_creation/    # Takım oluşturma, interaktif saha ve kadro yönetimi
└── shared/               # Paylaşılan modeller (Models), Riverpod Provider'ları ve ortak UI bileşenleri
```

### Katman Dağılımı:
1. **Presentation Katmanı (Sunum):** Flutter Widget'ları, dinamik form alanları ve Riverpod StateNotifier tüketimi.
2. **Domain Katmanı (İş Mantığı & Sözleşmeler):** Repository arayüzleri (`AuthRepository`, `TeamRepository`, `ChatRepository`, `InvitationRepository` vb.).
3. **Data Katmanı (Veri Erişimi):** Hem Firebase (Cloud Firestore & Firebase Auth) hem de yerel SQLite (`sqflite`) implementasyonları.
4. **Hibrit & Offline-First Dayanıklılık:** Ağ bağlantısı kesildiğinde veya ortam kısıtlamalarında sistem otomatik olarak yerel SQLite veritabanına geri düşerek (`fallback`) kullanıcının işlemlerini kesintiye uğratmaz.

---

## 🛠️ Kullanılan Teknolojiler ve Kütüphaneler

| Teknoloji / Paket | Sürüm | Kullanım Amacı |
| :--- | :--- | :--- |
| **Flutter & Dart** | SDK ^3.10.0 | Çapraz platform yüksek performanslı mobil uygulama geliştirme |
| **flutter_riverpod** | `^2.6.1` | Reaktif, test edilebilir ve merkezi durum yönetimi (State Management) |
| **go_router** | `^14.8.1` | Deklaratif sayfa yönlendirme, derin bağlantılar (deep linking) ve oturum korumalı rotalar |
| **firebase_core** | `^5.1.0` | Firebase servislerinin temel başlatılması |
| **firebase_auth** | `^7.0.1` | Güvenli bulut tabanlı kimlik doğrulama |
| **cloud_firestore** | `^7.1.0` | Gerçek zamanlı NoSQL bulut veritabanı senkronizasyonu |
| **sqflite / sqflite_common_ffi** | `^2.4.2` | Cihaz üzerinde yerel ilişkisel SQLite veritabanı ve masaüstü/test desteği |
| **shared_preferences** | `^2.5.2` | Aktif kullanıcı oturumu ve tema tercihlerinin yerel önbellekte tutulması |
| **crypto** | `^3.0.6` | Parola özetleme (SHA-256) ve güvenlik kontrolleri |
| **uuid** | `^4.5.1` | Yerel kayıtlar ve davetler için benzersiz kimlik (UUID v4) üretimi |
| **intl & flutter_localizations** | Güncel | Türkçe tarih, saat ve metin yerelleştirme desteği |

---

## 🌟 Temel Özellikler

### 1. Kimlik Doğrulama ve Yasal Uyumluluk (KVKK & Sözleşme)
- E-posta ve güvenli şifre ile kayıt olma ve giriş yapma.
- 6698 sayılı KVKK Aydınlatma Metni ve Kullanıcı Sözleşmesi onay mekanizması.
- Telefon numarası ve e-posta benzersizlik kontrolleri.
- Firebase Auth ve SQLite yerel veritabanı arasında çift yönlü profil senkronizasyonu.

### 2. Taktiksel Takım Kurma ve İnteraktif Futbol Sahası
- İl (81 İl), İlçe ve Halı Saha seçim hiyerarşisi.
- 24 farklı maç saat aralığı (Örn: `20.00 - 21.00`, `21.00 - 22.00`).
- **6 Farklı 7v7 Diziliş Seçeneği:**
  - `3-2-1`, `2-3-1`, `3-1-2`, `2-2-2`, `3-3` ve `1-3-2`.
- **Yeşil Saha Arayüzü (Pitch Widget):** Oyuncu mevkilerinin (Kaleci, Defans, Orta Saha, Forvet) grafiksel saha üzerinde canlı gösterimi, kaptan atama ve kadro tamamlama.

### 3. Davet ve Bildirim Sistemi
- Kaptanların boş mevkiler için diğer kayıtlı oyuncuları maça davet edebilmesi.
- Gelen davetleri kabul etme veya reddetme.
- Kabul edilen davetlerde oyuncunun anında takım kadrosuna ve maç randevusuna eklenmesi.
- Okunmamış bildirim sayacı (Badge) ve anlık işlem bildirimleri.

### 4. Takım İçi Özel Sohbet Odaları
- Yalnızca maça ve takıma dahil olan oyuncuların erişebildiği özel sohbet odaları.
- Maç öncesi taktik konuşmaları ve buluşma detayları için mesajlaşma altyapısı.

### 5. Randevularım ve Profil Yönetimi
- Kullanıcının kaptan olduğu veya oyuncu olarak katıldığı tüm maç randevularının listelenmesi.
- Randevu iptal ve kadro takip fonksiyonları.
- Kullanıcıya özel **Açık (Light) / Koyu (Dark)** tema desteği.

---

## 🚀 Başlangıç ve Kurulum

Projeyi yerel geliştirme ortamınızda çalıştırmak için aşağıdaki adımları izleyebilirsiniz:

### Gereksinimler
- Flutter SDK (3.10.0 veya üzeri)
- Dart SDK
- Android Studio / Xcode / VS Code

### Adım 1: Depoyu Klonlayın
```bash
git clone https://github.com/kullanici-adi/Bitirme-Projesi.git
cd Bitirme-Projesi
```

### Adım 2: Bağımlılıkları Yükleyin
```bash
flutter pub get
```

### Adım 3: Statik Kod Analizi ve Testleri Çalıştırın
```bash
flutter analyze
flutter test
```

### Adım 4: Uygulamayı Başlatın
```bash
# macOS üzerinde çalıştırmak için:
flutter run -d macos

# Android üzerinde çalıştırmak için:
flutter run -d android

# iOS Simulator üzerinde çalıştırmak için:
flutter run -d ios
```

---

## 👥 Hazır Test Kullanıcıları

Hızlı test ve değerlendirme için sistem ilk açılışta aşağıdaki hazır futbolcu hesaplarıyla tohumlanır (Seed Data):

| E-posta | Şifre | Oyuncu Adı | Telefon |
| :--- | :--- | :--- | :--- |
| `cr7@gmail.com` | `cris7` | Cristiano Ronaldo | `05111111111` |
| `m10@gmail.com` | `messi10` | Lionel Messi | `05222222222` |
| `neur1@gmail.com` | `neur1` | Manuel Neuer | `05333333333` |
| `ramos4@gmail.com` | `ramos4` | Sergio Ramos | `05444444444` |
| `yamal10@gmail.com` | `yamal10` | Lamine Yamal | `05555555555` |
| `mbappe10@gmail.com` | `mbappe10` | Kylian Mbappe | `05666666666` |

---

## 📄 Lisans

Bu proje bir bitirme projesi kapsamında akademik ve gelişim amaçlı geliştirilmiştir. Tüm hakları saklıdır.
