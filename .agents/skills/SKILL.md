SKILL.md — Flutter Halı Saha Projesi Geliştirme Kuralları
1. Görevin

Sen bu projede kıdemli bir Flutter mobil uygulama geliştiricisi, yazılım mimarı ve UI/UX tasarımcısı olarak görev yapacaksın.

Geliştirdiğin uygulama gerçek bir mobil ürün kalitesinde olmalıdır.

Ana proje gereksinimlerini PROJECT.md dosyasından öğren.

PROJECT.md uygulamanın özelliklerini ve iş kurallarını belirler.

SKILL.md ise kodlama yöntemlerini, geliştirme standartlarını ve çalışma kurallarını belirler.

İki dosya birbiriyle birlikte uygulanmalıdır.

2. En Önemli Geliştirme Kuralları
Kullanıcı istemeden mevcut özellikleri değiştirme.
Çalışan kodları gereksiz yere silme veya yeniden yazma.
Her özelliği modüler şekilde geliştir.
Kod tekrarından kaçın.
Tek bir Dart dosyasında bütün uygulamayı oluşturma.
Bütün ekranların gerçek işlevleri olmalıdır.
Görsel olarak çalışan ama işlevsiz buton bırakma.
Test verilerini gerçek kullanıcı verilerinden ayır.
Veritabanı işlemlerini UI katmanından ayır.
Hata yönetimini ihmal etme.
Her yeni özellikten sonra analiz ve test gerçekleştir.
Firebase entegrasyonu istenene kadar Firebase kullanma.
Kullanıcı tarafından belirlenen proje özelliklerini kendiliğinden değiştirme.
Emin olmadığın önemli bir iş kuralında kullanıcıya sor.
Geliştirme sürecinde Türkçe arayüz kullan.
3. Flutter Proje Mimarisi

Feature-first yaklaşımı kullan.

Önerilen klasör yapısı:

text
lib/
│
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme/
│       ├── app_theme.dart
│       ├── light_theme.dart
│       └── dark_theme.dart
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── helpers/
│   ├── services/
│   ├── utils/
│   └── widgets/
│
├── data/
│   ├── database/
│   ├── datasources/
│   ├── repositories/
│   └── seed/
│
├── features/
│   │
│   ├── authentication/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── team_creation/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── appointments/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── profile/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── chat/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── notifications/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── legal/
│       ├── data/
│       └── presentation/
│
└── shared/
    ├── models/
    ├── providers/
    └── widgets/

assets/
├── images/
├── icons/
├── fonts/
└── data/
    ├── provinces.json
    └── districts.json

test/
├── unit/
├── widget/
└── integration/


Bu yapı başlangıç önerisidir. Proje büyüdükçe mantıklı şekilde genişletilebilir.

4. State Management

State management için Riverpod kullan.

Aşağıdaki veriler merkezi state üzerinden yönetilmelidir:

Oturum açmış kullanıcı.
Kullanıcı profili.
Tema tercihi.
Takım oluşturma formu.
Seçilen diziliş.
Seçilen il ve ilçe.
Seçilen halı saha.
Tarih ve saat.
Randevular.
Takım üyeleri.
Gelen ve giden davetler.
Bildirimler.
Sohbet mesajları.

State değişiklikleri ilgili ekranlara doğru şekilde yansıtılmalıdır.

Aynı bilgiyi farklı ekranlarda birbirinden bağımsız şekilde saklama.

5. Veritabanı Kuralları

İlk aşamada yerel SQLite veritabanı kullan.

Veritabanı işlemlerini Repository Pattern ile yönet.

Örnek:

dart
abstract class AuthRepository {
  Future<User?> login({
    required String identifier,
    required String password,
  });

  Future<User> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  });

  Future<void> logout();
}


Veritabanı implementasyonu UI içerisinde yazılmamalıdır.

Örneğin LoginScreen doğrudan SQL sorgusu çalıştırmamalıdır.

Repository üzerinden işlem yapmalıdır.

İleride Firebase'e geçildiğinde aynı repository arayüzleri korunmalı, veri kaynakları değiştirilmelidir.

6. Test Hesapları

PROJECT.md içerisinde belirtilen 10 kullanıcıyı seed data olarak oluştur.

Kurallar:

İlk kurulumda otomatik ekle.
Her uygulama açılışında tekrar ekleme.
E-posta benzersizliğini kontrol et.
Telefon benzersizliğini kontrol et.
Şifreleri üretim ortamına uygun şekilde güvenli sakla.
Giriş yapan kullanıcının ID bilgisini aktif oturumda tut.
Kullanıcı çıkış yaptığında aktif oturumu temizle.

Test hesapları için ayrı bir SeedData dosyası kullan.

Kullanıcı bilgilerini ekranların içerisine doğrudan yazma.

7. Authentication Kuralları

Giriş ekranı e-posta ve telefon numarasıyla giriş desteklemelidir.

Giriş alanındaki değer e-posta formatındaysa e-posta üzerinden arama yapılmalıdır.

Telefon numarasıysa telefon üzerinden arama yapılmalıdır.

Şifre kontrolü yapılmalıdır.

Başarılı girişte aktif kullanıcı bilgisi saklanmalıdır.

Yeni kayıt sırasında:

Bütün alanlar kontrol edilmeli.
E-posta formatı doğrulanmalı.
Telefon formatı doğrulanmalı.
Şifre kuralları kontrol edilmeli.
Sözleşme onayları zorunlu olmalı.
E-posta ve telefon tekrar kontrol edilmeli.

Başarılı kayıt sonrasında giriş ekranına dönülmelidir.

8. Takım Kurma Kuralları

Takım oluşturma ekranında bütün seçimler state üzerinden yönetilmelidir.

Dizilişler enum veya benzeri tip güvenli bir yapı ile tutulmalıdır.

Örnek:

dart
enum Formation {
  threeThree,
  threeOneTwo,
  threeTwoOne,
  twoThreeOne,
  twoOneThree,
  twoTwoTwo,
}


Her dizilişin oyuncu pozisyonları merkezi bir modelden üretilmelidir.

Diziliş değiştiğinde:

Yeni diziliş yüklenmeli.
Pozisyon sayıları güncellenmeli.
Saha üzerindeki butonlar yeniden yerleşmeli.
Önceki dizilişte bulunan oyuncu isimleri uygun pozisyonlara taşınabiliyorsa korunmalı.
Artık bulunmayan pozisyonlardaki veriler sessizce başka mevkilere aktarılmamalıdır.

Takım oluşturma işlemi yalnızca gerekli bilgiler tamamlandığında etkinleşmelidir.

9. Futbol Sahası UI Kuralları

Futbol sahası görünümü responsive hazırlanmalıdır.

Sabit piksel koordinatlarıyla bütün cihazlara uygun tasarım yapılmaya çalışılmamalıdır.

Oyuncuların konumları diziliş modeline göre hesaplanmalıdır.

Saha görünümünde:

Kaleci alt bölümde.
Defans kalecinin önünde.
Orta saha defansın önünde.
Forvet üst bölümde.

gösterilmelidir.

Oyuncu butonları kolay tıklanabilir boyutta olmalıdır.

Her oyuncu kartı mevkiyi ve oyuncu adını göstermelidir.

10. İl ve İlçe Sistemi

81 il ve ilçeler için gerçek veri kullanılmalıdır.

Verileri ayrı JSON dosyasında tut.

İl seçilmeden ilçe listesi açılmamalıdır.

İl değiştiğinde ilçe ve halı saha seçimleri sıfırlanmalıdır.

İlçe değiştiğinde halı saha seçimi sıfırlanmalıdır.

Veri listelerinde arama özelliği bulunmalıdır.

Halı saha isimleri test sürümünde önceden oluşturulmuş bölgesel örneklerden üretilebilir.

Rastgele isim üretme işlemi her ekran yenilendiğinde sürekli değişmemelidir. Üretilen isimler ilgili test verisiyle birlikte saklanmalıdır.

11. Takvim ve Saat

Takvim için güvenilir bir Flutter takvim bileşeni kullan.

Ay değişimi çalışmalı.
Yıl değişimi çalışmalı.
Ayların gün sayıları doğru olmalı.
Artık yıl desteklenmeli.
Geçmiş maç tarihleri engellenmeli.

Saat seçenekleri merkezi olarak üretilmelidir.

24 saatlik sistem kullanılmalıdır.

Saat aralıkları bir saatlik olmalıdır.

00.00-01.00 ile 23.00-00.00 dahil bütün aralıklar gösterilmelidir.

Tarih ve saat verilerini veritabanında karşılaştırılabilir formatta sakla.

12. Davet Sistemi

Davet sistemi ayrı bir servis ve repository üzerinden yönetilmelidir.

Davet gönderirken:

Gönderen kullanıcı belirlenmeli.
Hedef kullanıcı belirlenmeli.
Takım belirlenmeli.
Boş mevki belirlenmeli.
Davet durumu Pending olarak kaydedilmelidir.

Kabul işleminde tek bir tutarlı işlem içerisinde:

Davetin durumu güncellenmeli.
Takım üyeliği oluşturulmalı.
İlgili mevki doldurulmalı.
Randevu ilişkisi kurulmalı.
Bildirim oluşturulmalıdır.

Bu işlemlerde aynı davetin iki defa kabul edilmesine izin verilmemelidir.

Ret işleminde takım üyeliği oluşturulmamalıdır.

Ret sonrası mevki boş kalmalıdır.

13. Bildirim Sistemi

Bildirimler kullanıcı ID'sine bağlı olmalıdır.

Bir kullanıcı yalnızca kendi bildirimlerini görebilmelidir.

Bildirim türleri enum olarak tanımlanmalıdır.

Bildirim okundu bilgisi tutulmalıdır.

Davet bildirimi ilgili davet kaydına bağlanmalıdır.

Bir davet kabul veya ret edildiğinde gönderen kullanıcıya ilgili sonuç bildirimi eklenmelidir.

14. Sohbet Sistemi

Sohbet mesajları takım ID'si üzerinden ilişkilendirilmelidir.

Her mesajda:

Mesaj ID
Takım ID
Gönderen ID
Mesaj içeriği
Gönderilme zamanı

bulunmalıdır.

Sohbet ekranı mesajları veritabanından okumalıdır.

Mesaj gönderildiğinde liste otomatik güncellenmelidir.

Mesaj gönderen kişinin adı ve mesaj zamanı gösterilmelidir.

Kullanıcı yalnızca üyesi olduğu takımların sohbetlerine erişebilmelidir.

15. Navigasyon

GoRouter kullan.

Oturum açılmamış kullanıcılar giriş ve kayıt ekranları dışında korumalı ekranlara erişememelidir.

Oturum açılmış kullanıcı giriş ekranına yönlendirilmemelidir.

Ana navigasyon dört sekmeden oluşmalıdır:

Takım Kur
Randevularım
Profil
Sohbet

Alt navigasyon ekran değişimlerinde sabit kalmalıdır.

Bildirimler ayrı bir sayfa olarak açılmalıdır.

16. UI/UX Tasarım Standartları

Material 3 kullan.

Bütün ekranlarda ortak tasarım sistemi bulunmalıdır.

Renkleri merkezi tema dosyalarından yönet.

Tekrarlanan widget'ları ortak bileşenlere dönüştür.

Örnek ortak bileşenler:

CustomButton
CustomTextField
AppBottomNavigation
NotificationIcon
UserCard
AppointmentCard
InvitationCard
PlayerPositionButton
EmptyStateWidget
LoadingWidget
ErrorWidget

Butonların basılma durumları ve yüklenme durumları bulunmalıdır.

Kullanıcıya başarılı ve başarısız işlemler hakkında anlaşılır mesajlar gösterilmelidir.

Ekranlar küçük ve büyük telefonlarda taşma yapmamalıdır.

17. Açık ve Koyu Tema

Tema sistemi uygulama genelinde çalışmalıdır.

Renkler doğrudan widget içerisine sabit yazılmamalıdır.

ThemeData kullanılmalıdır.

Kullanıcı tercihi kaydedilmelidir.

Uygulama yeniden başladığında önceki tema korunmalıdır.

18. Kod Kalitesi

Aşağıdaki kurallara uy:

Null safety kullan.
Anlamlı sınıf ve değişken isimleri seç.
Gereksiz kod tekrarından kaçın.
Büyük widget'ları küçük widget'lara ayır.
İş mantığını UI'dan ayır.
Gereksiz paket kullanma.
Hataları try/catch ile uygun şekilde yönet.
Async işlemlerde loading durumlarını göster.
Kullanılmayan import ve değişken bırakma.
Flutter analyzer hatalarını gider.
Kodları okunabilir tut.

Kodları teslim etmeden önce:

bash
flutter analyze


komutunu çalıştır.

Uygun testleri de çalıştır:

bash
flutter test

19. Test Kuralları

Her özellik için uygun testler oluştur.

Öncelikli testler:

Login işlemi.
Yanlış şifre kontrolü.
E-posta ile giriş.
Telefon ile giriş.
Kayıt formu doğrulama.
Yinelenen hesap kontrolü.
Diziliş pozisyon hesaplama.
Takım oluşturma.
Davet gönderme.
Davet kabul etme.
Davet reddetme.
Takım üyeliği.
Sohbet mesajı kaydetme.
Tema tercihi.
Randevu silme.

Testler birbirinden bağımsız çalışabilmelidir.

20. Antigravity Çalışma Protokolü

Projeyi tek seferde oluşturma.

Aşağıdaki geliştirme sırasını takip et.

FAZ 1 — Proje kurulumu
Flutter ortamını kontrol et.
Proje klasörlerini oluştur.
Gerekli paketleri ekle.
Tema altyapısını oluştur.
Navigasyon altyapısını oluştur.
Uygulamayı çalıştır.
FAZ 2 — Giriş ve kayıt
Giriş ekranını tasarla.
Kayıt ekranını tasarla.
Sözleşme ekranlarını oluştur.
10 test hesabını ekle.
Giriş ve kayıt işlemlerini çalıştır.
Test et.
FAZ 3 — Ana navigasyon
Dört alt sekmeyi oluştur.
Sabit alt navigasyonu hazırla.
Bildirim ikonunu ekle.
Profil ve tema altyapısını oluştur.
Test et.
FAZ 4 — Takım oluşturma
81 il verisini ekle.
İlçe verilerini ekle.
Halı saha seçim sistemini oluştur.
Takvim sistemini oluştur.
Saat seçim sistemini oluştur.
Altı dizilişi oluştur.
Futbol sahası görünümünü hazırla.
Oyuncu girişlerini ekle.
Takım kaydetme sistemini oluştur.
Test et.
FAZ 5 — Randevularım
Randevu kartlarını oluştur.
Takım bilgilerini göster.
Silme işlemini ekle.
Test et.
FAZ 6 — Profil
Kullanıcı bilgilerini göster.
Açık ve koyu tema sistemini tamamla.
Test et.
FAZ 7 — Davet ve bildirimler
Oyuncu önerilerini göster.
Davet gönderme işlemini oluştur.
Gelen davetleri göster.
Kabul ve ret işlemlerini oluştur.
Sonuç bildirimlerini oluştur.
Test et.
FAZ 8 — Sohbet
Takım sohbet listesini oluştur.
Mesaj ekranını oluştur.
Mesaj gönderme ve okuma işlemlerini oluştur.
Üyelik kontrolünü ekle.
Test et.
FAZ 9 — Genel kontrol
Bütün ekranları kontrol et.
Bütün navigasyonları kontrol et.
Veritabanı ilişkilerini kontrol et.
Test hesaplarıyla senaryoları çalıştır.
Hataları düzelt.
Flutter analyze çalıştır.
Flutter test çalıştır.
FAZ 10 — Firebase'e hazırlık

Bu aşamada Firebase entegrasyonu yapma.

Mevcut repository arayüzlerini ve veri modellerini incele.

Firebase'e geçiş için gerekli teknik hazırlığı raporla.

21. AI'ın Kullanıcıyla Çalışma Şekli

Geliştirme süresince aşağıdaki çalışma yöntemini uygula:

Öncelikle mevcut proje dosyalarını incele.
PROJECT.md ve SKILL.md dosyalarını oku.
O an üzerinde çalışılan fazı belirle.
Değişiklik yapmadan önce mevcut kodun etkilenebilecek bölümlerini incele.
Yalnızca gerekli dosyalarda değişiklik yap.
Dosyaları tamamladıktan sonra analiz gerçekleştir.
Hata varsa düzelt.
Yapılan işlemleri kullanıcıya açıkla.
Sonraki faza geçmeden önce kullanıcı onayı bekle.

Kullanıcı onay vermeden büyük mimari değişiklikler yapma.

Kullanıcı istemeden Firebase'e geçme.

Kullanıcı istemeden tasarımı baştan değiştirme.

Bir özellik tamamlanmadıysa tamamlandı şeklinde raporlama.

22. Son Hedef

Ortaya çıkacak uygulama basit bir demo veya yalnızca ekran tasarımlarından oluşan bir prototip olmamalıdır.

Kullanıcılar arasında gerçek iş akışları bulunan, yerel veritabanıyla çalışan, hesap değiştirerek test edilebilen ve Firebase entegrasyonuna hazır bir Flutter halı saha uygulaması geliştirilmelidir.

Öncelik sırası:

Doğru çalışan sistem.
Sağlam veri mimarisi.
Profesyonel tasarım.
Kullanıcı deneyimi.
Performans.
Firebase'e geçiş kolaylığı.