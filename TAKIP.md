# 7v7 — Halı Saha Organizasyon Uygulaması Geliştirme Takip Dosyası

Bu belge, **7v7** mobil uygulamasının (`PROJECT.md` ve `SKILL.md` standartlarına uygun olarak) başlangıçtan tamamlanmasına kadar gerçekleştirilen tüm geliştirme, mimari kurulum, veri modelleme, ekran tasarımı, logo/ikon entegrasyonu, birim/widget testleri ve Firebase'e geçiş hazırlık adımlarını detaylı olarak kayıt altına alır.

---

## 1. Genel Proje Bilgileri
- **Uygulama Adı:** `7v7`
- **Paket Adı (Dart/Flutter):** `hali_saha_7v7`
- **Platform:** Android, iOS, Web, Windows, macOS (Flutter / Dart - Material 3)
- **State Management:** Flutter Riverpod (`flutter_riverpod`)
- **Navigasyon:** GoRouter (`go_router` - `StatefulShellRoute.indexedStack` ile sabit 4 sekmeli alt bar ve oturum koruması)
- **Yerel Veritabanı & Kalıcılık:** SQLite (`sqflite` & `sqflite_common_ffi` + `shared_preferences`), Repository Pattern (Firebase'e geçişe hazır mimari)
- **Şifreleme & Kimlik:** `crypto` (SHA-256 + Salt parola hash'leme), `uuid` (benzersiz kayıt kimlikleri)

---

## 2. Faz Bazlı İlerleme Durumu

| Faz | Açıklama | Durum |
| :--- | :--- | :--- |
| **FAZ 1** | Proje Kurulumu, Feature-First Klasör Mimarisi, Paketler, Tema, Logo/İkon | ✅ Tamamlandı |
| **FAZ 2** | Giriş, Kayıt, Sözleşmeler (KVKK & Kullanıcı Sözleşmesi) ve 10 Test Hesabı | ✅ Tamamlandı |
| **FAZ 3** | Ana Navigasyon (4 Sekmeli Alt Bar, Bildirim İkonu, Auth Guard) | ✅ Tamamlandı |
| **FAZ 4** | Takım Oluşturma (81 İl/İlçe JSON, Halı Saha, Takvim, 24 Saat, 6 Diziliş, Saha UI) | ✅ Tamamlandı |
| **FAZ 5** | Randevularım (Randevu Kartları, Kadro/Rol Gösterimi, Randevu Silme İş Kuralı) | ✅ Tamamlandı |
| **FAZ 6** | Profil ve Kullanıcı Bazlı Açık/Koyu Tema Sistemi | ✅ Tamamlandı |
| **FAZ 7** | Davet ve Bildirimler (Oyuncu Önerileri, Boş Mevki Seçimi, Kabul/Ret Akışı) | ✅ Tamamlandı |
| **FAZ 8** | Takım Sohbeti (Üyelik Kontrollü Takım Odaları, Mesajlaşma) | ✅ Tamamlandı |
| **FAZ 9** | Genel Kontrol, `flutter analyze` ve `flutter test` Doğrulaması | ✅ Tamamlandı |
| **FAZ 10** | Firebase'e Geçiş Hazırlık Raporu ve Mimari İnceleme | ✅ Tamamlandı |

---

## 3. Detaylı Faz ve İşlem Kayıtları

### FAZ 1 — Proje Kurulumu, Logo/İkon ve Klasör Mimarisi
1. **Ortam Kontrolü:**
   - Flutter (`3.47.7`) ve Dart (`3.13.5`) sürümleri doğrulandı.
2. **Uygulama Adı (`7v7`) Yapılandırması:**
   - `android/app/src/main/AndroidManifest.xml` içerisinde `android:label="7v7"` olarak ayarlandı.
   - `ios/Runner/Info.plist` içerisinde `CFBundleDisplayName` ve `CFBundleName` değerleri `7v7` olarak ayarlandı.
   - `web/manifest.json`, `web/index.html` ve `windows/runner/main.cpp` başlıkları `7v7` olarak güncellendi.
3. **Uygulama Logosu ve İkon Üretimi:**
   - Koyu orman yeşili (`#0D3B26`), canlı saha yeşili (`#1DB954` / `#2ECC71`), beyaz saha çizgileri ve altın/beyaz vurgularla **7v7** arması ve saha ikonu üretildi.
   - Görseller `assets/icons/app_icon.png`, `assets/images/logo.png` ve `assets/images/pitch_logo.png` konumlarına eklendi.
   - `flutter_launcher_icons` çalıştırılarak Android (varsayılan + adaptive icon), iOS, Web, Windows ve macOS uygulama ikonları otomatik oluşturuldu.
4. **Feature-First Klasör Yapısı (`SKILL.md` Bölüm 3):**
   - `lib/app/theme/` (`app_theme.dart`, `light_theme.dart`, `dark_theme.dart`)
   - `lib/core/` (`constants/app_constants.dart`, `errors/app_exception.dart`, `utils/password_hasher.dart`, `utils/validators.dart`)
   - `lib/data/` (`database/app_database.dart`, `seed/seed_data.dart`)
   - `lib/features/` (`authentication`, `team_creation`, `appointments`, `profile`, `chat`, `notifications`, `legal`)
   - `lib/shared/` (`models/`, `providers/app_providers.dart`, `widgets/`)

---

### FAZ 2 — Giriş, Kayıt, Sözleşmeler ve 10 Test Hesabı
1. **10 Önceden Tanımlı Test Hesabı (`lib/data/seed/seed_data.dart`):**
   - `PROJECT.md` Bölüm 6'da belirtilen 10 futbolcu hesabı (`cristiano Ronaldo`, `lionel messi`, `Manuel neur`, `Sergio Ramos`, `lamine yamal`, `kylian mbappe`, `hary kane`, `erling Haaland`, `ronaldinho gaucho`, `arjen Robben`) ilk kurulumda otomatik olarak SQLite `users` tablosuna (`ConflictAlgorithm.ignore` ile tekrar eklenmeyecek şekilde) kaydedildi.
   - Şifreler düz metin yerine `PasswordHasher.hash` (SHA-256 + salt) ile güvenli şekilde saklandı.
2. **Giriş Ekranı (`lib/features/authentication/presentation/login_screen.dart`):**
   - `AppLogoWidget` ile **7v7** logosu ve uygulama adı eklendi.
   - E-posta veya telefon numarasıyla giriş desteği (`LocalAuthRepository.login`) sağlandı; hem e-posta hem telefon aynı kullanıcı hesabını temsil eder.
   - Şifre görünürlüğünü açıp kapatma ikonu (`visibility_outlined` / `visibility_off_outlined`) eklendi.
   - Test kolaylığı için `SeedData.predefinedUsers` üzerinden beslenen açılır/kapanır hızlı test hesabı doldurma paneli eklendi.
3. **Kayıt ve Sözleşme Ekranları (`register_screen.dart` & `legal_document_screen.dart`):**
   - Ad, Soyad, E-posta, Telefon numarası ve Şifre zorunlu alan doğrulamaları eklendi.
   - E-posta ve telefon numarasının benzersizliği SQLite üzerinden kontrol edildi.
   - **Kullanıcı Sözleşmesi** ve **KVKK Aydınlatma Metni** için iki ayrı onay kutusu ve tıklanabilir metin bağlantıları oluşturuldu; metinlere tıklandığında `LegalDocumentScreen` açılarak taslak metinler gösterilir ve onay verilir.
   - Onaylar `consents` tablosuna `ConsentModel` olarak kaydedilir.

---

### FAZ 3 — Ana Navigasyon ve Oturum Koruması
1. **GoRouter Yapılandırması (`lib/app/router.dart`):**
   - Oturum açmamış kullanıcıların korumalı ekranlara erişimi engellenip `/login` ekranına yönlendirildi.
   - Oturum açmış kullanıcıların `/login` veya `/register` ekranlarına gitmesi engellenip varsayılan olarak `/team-creation` (Takım Kur) sekmesine yönlendirildi.
2. **Sabit 4 Sekmeli Alt Navigasyon (`lib/shared/widgets/app_bottom_navigation.dart`):**
   - `StatefulShellRoute.indexedStack` ile sekme geçişlerinde sabit kalan 4 ana sekme oluşturuldu:
     1. **Takım Kur** (`/team-creation`)
     2. **Randevularım** (`/appointments`)
     3. **Profil** (`/profile`)
     4. **Sohbet** (`/chat`)
3. **Bildirim İkonu (`lib/shared/widgets/notification_icon.dart`):**
   - Ana ekranların sağ üst köşesine okunmamış bildirim sayısını rozet (badge) olarak gösteren bildirim ikonu eklendi.

---

### FAZ 4 — Takım Oluşturma ve Futbol Sahası UI
1. **81 İl ve İlçe Coğrafi Veri Sistemi (`assets/data/provinces.json` & `assets/data/districts.json`):**
   - Türkiye'nin 81 ili Türkçe alfabetik sırayla `provinces.json` dosyasına, tüm gerçek ilçeleri ise `districts.json` dosyasına eklendi.
   - `LocalLocationRepository` üzerinden arama destekli seçim pencereleriyle sunuldu.
   - İl seçilmeden ilçe seçilemez; il değiştiğinde ilçe ve halı saha seçimi sıfırlanır; ilçe değiştiğinde halı saha seçimi sıfırlanır.
2. **Halı Saha, Tarih ve Saat Seçimi:**
   - İl ve ilçe seçildikten sonra her ilçe için deterministik (ekran yenilendiğinde değişmeyen ve `venues_cache` tablosunda saklanan) örnek halı sahalar listelenir.
   - Takvim penceresi 12 ayı ve artık yılları destekler, geçmiş tarihler için maç oluşturulmasını engeller (`firstDate: today`).
   - Saat seçimi `00.00 - 01.00` ile `23.00 - 00.00` arasındaki 24 farklı 1 saatlik aralıktan oluşur.
3. **6 Farklı Diziliş ve Futbol Sahası Görünümü (`formation.dart` & `football_pitch_widget.dart`):**
   - Desteklenen 6 diziliş: `3-3`, `3-1-2`, `3-2-1`, `2-3-1`, `2-1-3`, `2-2-2` (her birinde Kaleci sabit ve toplam 7 oyuncu).
   - Diziliş değiştiğinde önceki dizilişte karşılığı olan mevkilerdeki oyuncu isimleri korunur (`migrateLineup`), artık bulunmayan pozisyonlardaki veriler sessizce başka mevkilere aktarılmaz.
   - `FootballPitchWidget` üzerinde üstte Forvet, ortada Orta Saha, altında Defans ve en altta Kaleci yer alır.
   - Her mevki butonuna (`PlayerPositionButton`) basıldığında oyuncu adı/soyadı girilebilir veya boş bırakılabilir.
4. **Diziliş Tamamlama (Yeşil Tik İkonu):**
   - Diziliş butonunun yanındaki yeşil tik ikonu; İl, İlçe, Halı Saha, Tarih, Saat ve Diziliş seçildiğinde aktifleşir (oyuncu isimlerinin tamamının doldurulması zorunlu değildir).
   - Kaydedildiğinde `teams`, `matches` ve `team_members` tablolarına tek bir transaction içinde kaydedilir ve aynı maç için mükerrer takım oluşturulması engellenir.

---

### FAZ 5 — Randevularım Ekranı
1. **Randevu Kartları (`lib/shared/widgets/appointment_card.dart`):**
   - Kullanıcının oluşturduğu (Takım Kaptanı) ve davet kabul ederek katıldığı (Oyuncu) maçlar listelenir.
   - Kart üzerinde; Kaptan/Takım adı, Kullanıcının rolü, Diziliş, İl/İlçe, Halı Saha, Tarih, Saat ve 7 kişilik takım kadrosunun dolu/boş durumu gösterilir.
2. **Üç Nokta Menüsü ve Randevu Silme (`appointments_screen.dart`):**
   - Sağ üst köşedeki üç nokta menüsünde **Randevuyu Sil** seçeneği yer alır.
   - Onay penceresi sonrasında randevu yalnızca ilgili kullanıcının kendi listesinden (`dismissed_appointments`) silinir; diğer takım oyuncularının randevusu silinmez. Kaptan henüz hiçbir üye katılmadan silerse bekleyen davetler `Cancelled` durumuna çekilir.

---

### FAZ 6 — Profil ve Tema Sistemi
1. **Profil Bilgileri (`lib/features/profile/presentation/profile_screen.dart`):**
   - Kullanıcının Ad, Soyad, E-posta ve Telefon numarası bilgileri gösterilir.
2. **Kullanıcı Bazlı Açık/Koyu Tema (`Light Mode` / `Dark Mode`):**
   - Profil ekranındaki tema anahtarı (`SwitchListTile`) ile uygulama anında Light veya Dark temaya geçer.
   - Tema tercihi `users.themeMode` alanında kullanıcıya özel saklanır; bir kullanıcının tema tercihi diğer kullanıcıların temasını değiştirmez ve uygulama kapatılıp açıldığında korunur.

---

### FAZ 7 — Davet ve Bildirim Sistemi
1. **Oyuncu Önerileri ve Davet Gönderme (`chat_hub_screen.dart` & `local_invitation_repository.dart`):**
   - Aktif kullanıcı kendi hesabını listede görmez; diğer kullanıcılar `UserCard` ile listelenir.
   - `Davet Yolla` butonuna basıldığında kaptanın boş mevkisi bulunan takımları ve boş mevkileri seçilir.
   - Sistem; hedef kullanıcının zaten takımda olup olmadığını, aynı takıma bekleyen daveti olup olmadığını ve seçilen mevkinin boş olup olmadığını kontrol eder.
   - Davet `Pending` (Beklemede) olarak kaydedilir ve alıcıya `teamInvitation` bildirimi oluşturulur.
2. **Gelen Davetler, Kabul ve Ret İşlemleri (`notifications_screen.dart` & `invitation_card.dart`):**
   - Alıcı bildirimler ekranında davet kartı üzerinde gönderen adını, il/ilçe/halı saha/tarih/saat/diziliş/kadro bilgilerini ve davet edilen mevkiyi görür.
   - **Kabul Et:** Tek bir atomik veritabanı transaction'ı içinde davet `Accepted` olur, oyuncu `team_members` tablosunda ilgili mevkiye eklenir, maç oyuncunun Randevularım ve Takım Sohbeti listelerine dahil edilir ve kaptana "Davet Kabul Edildi" bildirimi gönderilir.
   - **Reddet:** Davet `Rejected` olur, oyuncu takıma eklenmez, mevki boş kalır ve kaptana "Davet Reddedildi" bildirimi gönderilir.
   - Bir davet yalnızca bir kez sonuçlandırılabilir.

---

### FAZ 8 — Takım Sohbeti
1. **Takım Sohbet Odaları (`team_chat_room_screen.dart` & `local_chat_repository.dart`):**
   - Sohbet sekmesinde yalnızca kullanıcının üyesi olduğu takımlar listelenir.
   - Repository katmanında da `isUserMemberOfTeam` kontrolü yapılarak üye olmayan kullanıcıların sohbet mesajlarını okuması veya mesaj göndermesi engellenir.
   - Gönderilen mesajlar gönderen adı ve zaman bilgisiyle SQLite `messages` tablosuna kaydedilir; aynı takımın tüm üyeleri ortak yerel veritabanı üzerinden aynı sohbet geçmişini görür.

---

### FAZ 9 — Genel Kontrol, Analiz ve Otomatik Testler
1. **Statik Kod Analizi (`flutter analyze`):**
   - Tüm proje dosyaları `flutter analyze` ile tarandı ve **0 hata / 0 uyarı** (`No issues found!`) doğrulandı.
2. **Birim ve Widget Testleri (`flutter test`):**
   - `test/unit/seven_v_seven_business_rules_test.dart`: `SKILL.md` Bölüm 19'daki 15 öncelikli iş kuralının tamamını (e-posta/telefon girişi, yanlış şifre, sözleşme onayı, yinelenen hesap, 6 diziliş pozisyon hesaplama ve güvenli diziliş taşıma, takım kurma, davet gönderme, davet kabul/ret, bildirimler, takım sohbeti üyelik kontrolü, kullanıcı bazlı tema ve randevu silme) bağımsız bellek içi SQLite veritabanı üzerinde test eder.
   - `test/widget_test.dart`: `7v7` giriş ekranı bileşenlerini ve kayıt ekranı navigasyonunu test eder.

---

### FAZ 10 — Firebase'e Geçiş Hazırlık Raporu
Mevcut uygulama mimarisi `PROJECT.md` (Aşama 2) ve `SKILL.md` (Bölüm 5 & 20) gereksinimlerine uygun olarak **Repository Pattern** üzerine inşa edilmiştir. UI katmanı ve Riverpod `StateNotifier` sınıfları doğrudan SQLite sorguları çalıştırmaz; yalnızca soyut repository arayüzlerini kullanır:

| Soyut Arayüz (Domain) | Yerel İmplementasyon (Aşama 1) | Firebase İmplementasyonu (Aşama 2 Karşılığı) |
| :--- | :--- | :--- |
| `AuthRepository` | `LocalAuthRepository` | `FirebaseAuthRepository` (`FirebaseAuth` + `users` Firestore koleksiyonu) |
| `LocationRepository` | `LocalLocationRepository` | `FirestoreLocationRepository` (Statik JSON + `venues` Firestore koleksiyonu) |
| `TeamRepository` | `LocalTeamRepository` | `FirestoreTeamRepository` (`teams`, `team_members`, `matches` koleksiyonları) |
| `InvitationRepository` | `LocalInvitationRepository` | `FirestoreInvitationRepository` (`invitations` koleksiyonu + Firestore Batch/Transaction) |
| `NotificationRepository` | `LocalNotificationRepository` | `FirestoreNotificationRepository` (`notifications` koleksiyonu + Firebase Cloud Messaging) |
| `ChatRepository` | `LocalChatRepository` | `FirestoreChatRepository` (`teams/{teamId}/messages` alt koleksiyonu + gerçek zamanlı `snapshots()`) |

**Firebase'e Geçişte Yapılacak Teknik Adımlar:**
1. `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage` ve `firebase_messaging` paketlerinin `pubspec.yaml` dosyasına eklenmesi ve `flutterfire configure` ile `firebase_options.dart` dosyasının üretilmesi.
2. Veri modellerindeki (`UserModel`, `TeamModel`, `TeamMemberModel`, `InvitationModel`, `MessageModel`, `NotificationModel`, `ConsentModel`) hazır `toMap()` ve `fromMap()` metotlarının doğrudan Firestore `DocumentSnapshot` / `Map<String, dynamic>` serileştirmesinde kullanılması.
3. `lib/shared/providers/app_providers.dart` içerisindeki 6 repository provider'da `Local*Repository` yerine `Firebase*Repository` sınıflarının enjekte edilmesi (ekran tasarımları ve iş kuralları hiçbir değişikliğe uğramadan korunacaktır).

---

### Ek Düzeltme Kaydı — Diziliş Seçim Penceresi Taşma (`Bottom Overflowed by 76 Pixels`) Giderimi
- **Sorun:** `TeamCreationScreen` içerisinde `_handleFormationSelect` metodundaki `showModalBottomSheet` varsayılan yükseklik sınırıyla (`isScrollControlled: false`) açıldığı ve içeriği kaydırılabilir olmadığı için 6 diziliş seçeneği küçük/orta ekranlarda `bottom overflowed by 76 pixels` hatası veriyordu.
- **Çözüm:**
  - [team_creation_screen.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/team_creation/presentation/team_creation_screen.dart) içerisindeki `_handleFormationSelect` metoduna `isScrollControlled: true`, `useSafeArea: true` eklendi ve içerik `SingleChildScrollView` içine alındı.
  - Ayrıca oyuncu adı girme penceresi (`_handlePositionTap` içindeki `AlertDialog`) klavye açıldığında taşma yapmaması için `SingleChildScrollView` ile sarmalandı.
  - [widget_test.dart](file:///c:/Users/Murat/Desktop/7v7/test/widget_test.dart) içerisine diziliş seçim penceresinin taşma olmadan açıldığını doğrulayan otomatik widget testi eklendi.

---

### Ek Düzeltme Kaydı — Bildirimler Ekranında "Tüm Bildirim Kayıtları" Görünürlük Kuralı
- **İster:** Bildirimler sayfasında altta bulunan "Tüm Bildirim Kayıtları" bölümü, "Tümünü Okundu İşaretle" butonuna tıklanmadığı sürece ekranda kalmalı; "Tümünü Okundu İşaretle" butonuna tıklandığında ise yalnızca "Tüm Bildirim Kayıtları" bölümü kaldırılmalı ve üstteki "Gelen Takım Davetleri" bölümüne dokunulmamalı (her durumda kalmalı).
- **Yapılan İşlem:**
  - [notifications_screen.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/notifications/presentation/notifications_screen.dart) içerisinde `visibleNotifications = notifications.where((n) => !n.isRead).toList()` filtresi uygulandı ve tekil bildirim satırına dokunulduğunda gizlenme davranışı kaldırıldı.
  - [local_invitation_repository.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/notifications/data/local_invitation_repository.dart) içerisinde davet kabul/ret işleminde bildirimin otomatik olarak `isRead = 1` yapılması kaldırıldı; böylece kullanıcı "Tümünü Okundu İşaretle" butonuna tıklayana kadar "Tüm Bildirim Kayıtları" sabit kalır, tıklandığında ise yalnızca o bölüm kaybolur ve "Gelen Takım Davetleri" olduğu gibi kalır.

---

### Ek Düzeltme Kaydı — Giriş Ekranındaki Hızlı Test Hesabı Panelinin Kaldırılması
- **İster:** Giriş ekranının altındaki "Önceden Kayıtlı 10 Test Hesabı" hızlı seçim alanı ekrandan kaldırılmalı; ancak veritabanındaki 10 test hesabı silinmeyip korunmalı ve kullanıcılar e-posta/telefon ve şifre bilgilerini elle girerek giriş yapabilmeli.
- **Yapılan İşlem:**
  - [login_screen.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/authentication/presentation/login_screen.dart) içerisindeki "Önceden Kayıtlı 10 Test Hesabı" kartı kaldırıldı (`SKILL.md` Bölüm 6: "Kullanıcı bilgilerini ekranların içerisine doğrudan yazma" kuralıyla da tam uyumlu hale getirildi).
  - [seed_data.dart](file:///c:/Users/Murat/Desktop/7v7/lib/data/seed/seed_data.dart) ve SQLite `users` tablosundaki 10 hazır test hesabı aynen korundu; kullanıcılar e-posta veya telefon numarası ve şifrelerini yazarak giriş yapabilir.

---

### Aşama 2 Başlangıcı — Firebase Bağlantı Kontrolü ve Doğrulaması
- **İncelenen Yapılandırma Dosyaları:**
  - `pubspec.yaml`: `firebase_core: ^5.1.0`, `firebase_auth: ^7.0.1` ve `cloud_firestore: ^7.1.0` paketleri doğrulandı.
  - `lib/firebase_options.dart`: FlutterFire CLI tarafından oluşturulan `v7-app-341ae` (`7v7-app`) proje yapılandırması (`android`, `ios`, `macos`, `web`, `windows`) doğrulandı.
  - `android/app/google-services.json`, `android/app/build.gradle.kts` ve `android/settings.gradle.kts`: `com.google.gms.google-services` (`4.4.4`) eklentisi ve `com.sevenVseven.app.hali_saha_7v7` paket kimliği uyumu doğrulandı.
- **Değiştirilen Dosyalar ve Yapılan İşlemler:**
  1. [lib/main.dart](file:///c:/Users/Murat/Desktop/7v7/lib/main.dart):
     - `_initializeAndVerifyFirebase()` fonksiyonu ile `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)` güvenli şekilde (`Firebase.apps.isEmpty` kontrolü ve hata yakalama ile) başlatıldı; `FirebaseAuth.instanceFor` ve `FirebaseFirestore.instanceFor` bağlantıları doğrulanarak konsola proje kimliği (`v7-app-341ae`) loglandı.
     - Mevcut `AppDatabase.instance.database` (SQLite), `SharedPreferences`, `authProvider.notifier.initializeSession()`, `UncontrolledProviderScope` ve `SevenVSevenApp` akışı olduğu gibi korundu.
  2. [lib/shared/providers/app_providers.dart](file:///c:/Users/Murat/Desktop/7v7/lib/shared/providers/app_providers.dart):
     - Mevcut yerel repository'lere (`LocalAuthRepository`, `LocalTeamRepository`, `LocalInvitationRepository`, `LocalNotificationRepository`, `LocalChatRepository`, `LocalLocationRepository`), GoRouter ve Tema sistemine dokunulmadan merkezi `firebaseInitializedProvider`, `firebaseAppProvider`, `firebaseAuthInstanceProvider` ve `firestoreInstanceProvider` tanımlandı.
  3. [test/unit/seven_v_seven_business_rules_test.dart](file:///c:/Users/Murat/Desktop/7v7/test/unit/seven_v_seven_business_rules_test.dart):
     - `DefaultFirebaseOptions` yapılandırma doğrulama testi eklendi.

---

### Aşama 2.1 — Kullanıcı Kayıt ve Giriş Sisteminin Firebase Authentication & Cloud Firestore'a Taşınması
- **Değiştirilen / Eklenen Dosyalar:**
  1. [lib/shared/models/user_model.dart](file:///c:/Users/Murat/Desktop/7v7/lib/shared/models/user_model.dart):
     - `termsAccepted` ve `kvkkAccepted` alanları eklendi.
     - `toFirestoreMap()` ve `UserModel.fromFirestore()` metotları eklendi (`uid`, `firstName`, `lastName`, `email`, `phone`, `createdAt`, `termsAccepted`, `kvkkAccepted` alanlarını içerir; `password` veya `passwordHash` alanı kesinlikle Firestore'a yazılmaz).
  2. [lib/features/authentication/data/firebase_auth_repository.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/authentication/data/firebase_auth_repository.dart):
     - `AuthRepository` arayüzünü gerçekleyen `FirebaseAuthRepository` oluşturuldu.
     - **Kayıt (`register`):** Ad, Soyad, E-posta, Telefon, Şifre (en az 6 karakter), Kullanıcı Sözleşmesi ve KVKK onaylarını doğrular. `FirebaseAuth.createUserWithEmailAndPassword` ile kullanıcıyı oluşturur; ardından atomik **Firestore Transaction** (`_db.runTransaction`) ile `phone_lookup/{normalizedPhone}` (telefon benzersizliği ve eşleştirme indeksi) ve `users/{uid}` belgelerini oluşturur. Herhangi bir çakışmada oluşturulan Auth kaydını geri alır (`user.delete()`). Kayıt sonunda oturumu kapatarak kullanıcıyı giriş ekranına yönlendirir.
     - **Giriş (`login`):** E-posta girilmişse doğrudan, telefon numarası girilmişse önce Firestore `phone_lookup/{normalizedPhone}` (ve yedek olarak `users`) üzerinden e-posta adresini çözümleyerek `FirebaseAuth.signInWithEmailAndPassword` ile giriş yapar. Şifre doğrulaması hiçbir şekilde yerel olarak yapılmaz.
     - **Oturum Kalıcılığı (`getCurrentUser` & `logout`):** Uygulama yeniden başlatıldığında `FirebaseAuth.currentUser` üzerinden oturumu korur ve Firestore'dan `UserModel` profilini yükler.
     - **Yerel Özelliklerle Uyumluluk:** Mevcut SQLite veritabanındaki 10 test hesabı korunmuş olup, Firebase ile giriş yapan kullanıcının şifresiz profil önbelleği yerel SQLite'a yansıtılarak Takım Kurma, Randevularım, Sohbet, Bildirimler ve Davet sistemlerinin kesintisiz çalışması sağlanmıştır.
  3. [lib/shared/providers/app_providers.dart](file:///c:/Users/Murat/Desktop/7v7/lib/shared/providers/app_providers.dart):
     - `authRepositoryProvider` artık `FirebaseAuthRepository` kullanacak şekilde güncellendi (`localAuthRepositoryProvider` ise yerel testler ve mevcut 10 hesap için korundu).
  4. [lib/features/authentication/presentation/register_screen.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/authentication/presentation/register_screen.dart):
     - Şifre alanı ipucu ve doğrulaması Firebase Authentication standartlarına uygun olarak en az 6 karakter olacak şekilde güncellendi.
  5. [firestore.rules](file:///c:/Users/Murat/Desktop/7v7/firestore.rules):
     - Kullanıcıların yalnızca kendi `users/{uid}` profil verilerini oluşturup güncelleyebilmesini, şifre alanlarının Firestore'a yazılamamasını ve `phone_lookup/{phone}` belge kimliği üzerinden telefon numarası benzersizliğinin veritabanı seviyesinde korunmasını sağlayan güvenlik kuralları hazırlandı.

---

## GÜNCELLEME 5 — Firestore Güvenlik Kuralları Sıkılaştırması (`firestore.rules`) ve Telefonla Giriş Güvenlik Düzenlemesi
- **Durum:** Tamamlandı ve Doğrulandı
- **Yapılan İşlemler:**
  1. [firestore.rules](file:///c:/Users/Murat/Desktop/7v7/firestore.rules):
     - `users/{uid}` koleksiyonunda okuma izni yalnızca kullanıcının kendi UID belgesiyle sınırlandırıldı (`allow get: if isOwner(uid); allow list: if false;`). Başka kullanıcıların telefon numarası ve e-posta bilgilerinin okunması ve koleksiyonun listelenmesi tamamen engellendi.
     - `users/{uid}` güncelleme kuralında (`allow update: if isOwner(uid)`) `uid`, `email`, `phone`, `termsAccepted` ve `kvkkAccepted` alanlarının değiştirilemezliği ve başka kullanıcıların profil verilerinin değiştirilememesi garanti altına alındı (`allow delete: if false`).
     - `phone_lookup/{phone}` koleksiyonuna kimlik doğrulaması yapılmadan (`request.auth == null`) erişilmesi engellendi (`allow get: if isSignedIn(); allow list: if false;`).
     - `phone_lookup/{phone}` belgelerinden `email` alanı tamamen çıkarıldı (`request.resource.data.keys().hasOnly(['uid', 'phone', 'createdAt'])`); böylece bu koleksiyon yalnızca kayıt esnasında telefon numarası benzersizliğini atomik olarak doğrulamak için kullanılır ve e-posta sızıntısına yol açmaz.
  2. [lib/features/authentication/data/firebase_auth_repository.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/authentication/data/firebase_auth_repository.dart):
     - İstemci tarafında kimlik doğrulaması öncesinde Firestore üzerinden telefon -> e-posta sorgulaması yapılmasının güvenlik riski (enumeration ve kimliksiz okuma gereksinimi) değerlendirilerek, güvenli bir sunucu tarafı çözümü eklenene kadar telefon numarasıyla giriş geçici olarak devre dışı bırakıldı (`code: 'phone-login-disabled'`). E-posta ve şifreyle giriş çalışmaya devam etmektedir.
     - Kayıt (`register`) akışında kimlik doğrulaması öncesinde yapılan `phone_lookup` ön sorgusu kaldırıldı; telefon benzersizlik kontrolü `createUserWithEmailAndPassword` sonrasında oturum açmış kullanıcı bağlamında (`isSignedIn()`) atomik `_db.runTransaction` içinde gerçekleştirilecek şekilde güncellendi. Çakışma durumunda oluşturulan geçici Firebase Auth kullanıcısı `delete()` ile geri alınır (rollback).
     - `getUserById` ve `getSuggestedPlayers` metotları, `users` koleksiyonunda yalnızca kendi UID belgesini okuma kuralıyla (`isOwner(uid)`) tam uyumlu hale getirildi.
  3. [lib/features/authentication/presentation/login_screen.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/authentication/presentation/login_screen.dart):
     - Mevcut ekran tasarımı ve widget anahtarları korunarak giriş alanı doğrulaması e-posta ile girişe uygun hale getirildi; telefon numarası girildiğinde kullanıcıya telefonla girişin geçici olarak devre dışı olduğu bilgisi gösterilir.
  4. [test/unit/seven_v_seven_business_rules_test.dart](file:///c:/Users/Murat/Desktop/7v7/test/unit/seven_v_seven_business_rules_test.dart):
     - `firestore.rules` kurallarını birebir simüle eden `RuleEnforcingFakeFirestore` ve `FakeFirebaseAuth` ile kayıt, e-posta girişi, telefon benzersizliği (ve rollback), telefonla girişin engellenmesi, kimliksiz `phone_lookup` erişim engeli ve kullanıcılar arası profil okuma/güncelleme izolasyonu uçtan uca test edildi.

---

## GÜNCELLEME 6 — İlk Girişte SQLite/SeedData Profil Senkronizasyonu ve Gerçek Onay (`consents`) Doğrulaması
- **Durum:** Tamamlandı ve Doğrulandı
- **Yapılan İşlemler:**
  1. [lib/features/authentication/data/firebase_auth_repository.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/authentication/data/firebase_auth_repository.dart):
     - `login()` metodunda Firebase Authentication ile giriş yapan kullanıcının Firestore `users/{uid}` belgesi henüz mevcut değilse (`!userDoc.exists`), `_resolveLocalOrSeedProfile(uid)` ile önce SQLite `users` tablosundaki mevcut kayıt, eğer UID `seed_user_1` .. `seed_user_10` arasındaysa `SeedData.predefinedUsers` kaydı bulunur.
     - Kullanıcının `id` (`uid`), `firstName`, `lastName`, `email`, `phone`, `createdAt` ve `themeMode` bilgileri birebir korunur; `phone` alanı kesinlikle boş (`''`) değerle ezilmez.
     - `_syncProfileToLocalCache` metodu mevcut SQLite kaydındaki dolu `phone` ve `passwordHash` alanlarını boş veya yer tutucu değerle ezmeyecek şekilde güçlendirildi.
     - Firestore `users/{uid}` ve `phone_lookup/{phone}` belgeleri atomik `_db.runTransaction` ile oluşturulur; eğer `users/{uid}` belgesi zaten varsa yeniden yazılmaz ve mevcut profil korunur.
     - Telefon numarası Firestore `phone_lookup/{phone}` içinde başka bir `uid` tarafından kullanılıyorsa işlem durdurulur (`AppException(code: 'phone-already-in-use')`), oturum kapatılır ve anlaşılır hata gösterilir.
     - `termsAccepted` ve `kvkkAccepted` alanları `_getVerifiedLocalConsents(uid)` ile SQLite `consents` tablosundan denetlenir; yalnızca gerçekten onay kaydı (`accepted = 1`) varsa `true` yapılır. Eski test hesaplarında (`seed_user_1` .. `seed_user_10`) gerçek kullanıcı onayı olmadığı için `false` olarak kaydedilir.
  2. [lib/shared/models/user_model.dart](file:///c:/Users/Murat/Desktop/7v7/lib/shared/models/user_model.dart) & [lib/features/authentication/data/local_auth_repository.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/authentication/data/local_auth_repository.dart):
     - `UserModel` içerisinde `termsAccepted` ve `kvkkAccepted` varsayılan değerleri `false` yapıldı; böylece gerçek onay kaydı bulunmayan hesaplarda otomatik `true` atanması engellendi.
  3. [firestore.rules](file:///c:/Users/Murat/Desktop/7v7/firestore.rules):
     - Yeni kullanıcı kayıtlarında `termsAccepted == true && kvkkAccepted == true` zorunluluğu korunurken, `isLegacySeedUser(uid)` (`seed_user_1` .. `seed_user_10`) için ilk profil senkronizasyonunda `false` onay durumunun gerçeğe uygun şekilde kaydedilebilmesine ve sonradan `true` olarak güncellenebilmesine izin verildi.
  4. [test/unit/seven_v_seven_business_rules_test.dart](file:///c:/Users/Murat/Desktop/7v7/test/unit/seven_v_seven_business_rules_test.dart):
     - Firestore profili olmayan seed kullanıcısının SQLite profilinden senkronizasyonu, telefon numarasının boş değerle ezilmemesi, UID korunumu, mevcut Firestore belgesinin tekrar yazılmaması, başka kullanıcıya ait telefon numarası çakışmasının engellenmesi ve normal Firebase kullanıcılarının girişinin çalışmaya devam etmesi testleri eklendi.

---

## GÜNCELLEME 7 — 10 Hazır Test Hesabının Firebase Auth Import Hazırlığı, `.gitignore` Koruması, Yedekleme ve Çakışma Doğrulaması
- **Durum:** Tamamlandı (Aktarım Öncesi Onay Bekleniyor)
- **Yapılan İşlemler:**
  1. [.gitignore](file:///c:/Users/Murat/Desktop/7v7/.gitignore):
     - `seed_users_auth.json`, `existing_firebase_users_backup*.json`, `*firebase-adminsdk*.json`, `*service-account*.json`, `*serviceAccount*.json` ve `.env*` gibi tüm kimlik doğrulama import/export ve servis anahtarı dosyalarını Git/GitHub'a yüklenmekten koruyan kurallar eklendi.
  2. [lib/core/utils/firebase_auth_import_preparer.dart](file:///c:/Users/Murat/Desktop/7v7/lib/core/utils/firebase_auth_import_preparer.dart) & [tool/prepare_seed_users_auth.dart](file:///c:/Users/Murat/Desktop/7v7/tool/prepare_seed_users_auth.dart):
     - `SeedData.predefinedUsers` içerisindeki 10 hazır test hesabının (`seed_user_1` .. `seed_user_10`) SHA-256 hex özetlerini (`PasswordHasher.hash()`) 32 ham byte Base64 formatına dönüştüren, Firebase CLI `SHA256` (`SALT_FIRST`, `rounds=1`, `salt="N3Y3X2hhbGlfc2FoYV9zZWN1cmVfc2FsdF92MTo="`) çıktısıyla %100 eşleşmesini doğrulayan, `seed_users_auth.json` dosyasını oluşturan ve mevcut Firebase kullanıcılarıyla çakışma kontrolü yapan hazırlık aracı oluşturuldu.
  3. **Mevcut Firebase Kullanıcısı Yedeği ve Çakışma Kontrolü:**
     - `firebase auth:export existing_firebase_users_backup.json --format=json --project=v7-app-341ae` komutuyla mevcut 1 Firebase Auth kullanıcısının tam yedeği alındı ve 10 hazır test hesabıyla (`seed_user_1` .. `seed_user_10`) hiçbir UID veya e-posta çakışması olmadığı doğrulandı.
     - Henüz `firebase auth:import` çalıştırılmadı; mevcut kullanıcıya dokunulmadı.

---

## GÜNCELLEME 8 — 10 Hazır Test Hesabının Firebase Authentication'a Aktarımı ve Doğrulanması
- **Durum:** Tamamlandı ve Doğrulandı
- **Yapılan İşlemler:**
  1. `firebase auth:import seed_users_auth.json --hash-algo=SHA256 --rounds=1 --hash-input-order=SALT_FIRST --project=v7-app-341ae` komutu çalıştırıldı.
  2. **Sonuç:** 10 hesabın tamamı **başarıyla** içe aktarıldı (Başarılı: 10, Başarısız: 0).
  3. `firebase auth:export firebase_auth_backup_after_import.json --format=json --project=v7-app-341ae` ile aktarım sonrası doğrulama yapıldı:
     - Toplam kullanıcı sayısı: **11** (1 mevcut kullanıcı + 10 hazır test hesabı).
     - `seed_user_1` .. `seed_user_10` UID değerlerinin, e-posta adreslerinin ve `displayName` bilgilerinin eksiksiz korunduğu doğrulandı.
     - Mevcut Firebase kullanıcısının (`ZRhD3BxzUnQcThSM2r7bpiUA0DE2` - `orkun@gmail.com`) `localId`, `email`, `passwordHash`, `salt`, `createdAt` ve `lastSignedInAt` alanlarının hiçbir değişikliğe uğramadığı doğrulandı.

---

## GÜNCELLEME 9 — 10 Hazır Test Hesabının İlk Giriş Firestore Senkronizasyonu ve `orkun@gmail.com` / SQLite Uyumluluk Doğrulaması
- **Durum:** Tamamlandı ve Doğrulandı
- **Yapılan İşlemler:**
  1. [lib/features/authentication/data/firebase_auth_repository.dart](file:///c:/Users/Murat/Desktop/7v7/lib/features/authentication/data/firebase_auth_repository.dart):
     - `_syncProfileToLocalCache` içerisinde SQLite `users.phone` `UNIQUE` kısıtlamasına karşı koruma eklendi; `seed_user_1` .. `seed_user_10` ve `orkun@gmail.com` gibi hesapların SQLite önbelleklemesi sırasında hiçbir telefon numarası veya şifre özetinin ezilmemesi garanti altına alındı.
  2. [test/unit/seven_v_seven_business_rules_test.dart](file:///c:/Users/Murat/Desktop/7v7/test/unit/seven_v_seven_business_rules_test.dart):
     - `seed_user_1` .. `seed_user_10` hesaplarının tamamının ilk girişte SQLite/`SeedData` profil bilgilerini doğru aldığı, `users/{uid}` ve `phone_lookup/{phone}` belgelerini atomik transaction ve `firestore.rules` kurallarıyla tam uyumlu oluşturduğu, mevcut `orkun@gmail.com` hesabının sorunsuz çalıştığı ve SQLite üzerindeki takım, davet, randevu, bildirim ve sohbet mesajlarının eksiksiz korunduğu uçtan uca test edilerek doğrulandı.





