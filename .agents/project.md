PROJECT.md — Halı Saha Uygulaması
1. Proje Tanımı

Proje adı: Halı Saha
Platform: Android ve iOS
Framework: Flutter
Programlama dili: Dart
Geliştirme ortamı: Antigravity IDE / Visual Studio Code
İlk sürüm: Firebase kullanılmayan, yerel veritabanıyla çalışan test sürümü.

Projenin amacı

Kullanıcıların halı saha maçları organize edebildiği, takım kurabildiği, takımlarına oyuncu davet edebildiği, maç randevusu oluşturabildiği ve takım arkadaşlarıyla sohbet edebildiği bir mobil uygulama geliştirmek.

Uygulamanın temel amacı 7'ye 7 halı saha maçlarını organize etmektir.

Uygulama gerçek bir ürün gibi tasarlanmalı, bütün ekranlar birbirleriyle bağlantılı çalışmalı ve test hesapları arasında kullanıcı etkileşimleri gerçekleştirilebilmelidir.

2. Geliştirme Aşamaları
Aşama 1 — Yerel test sürümü

Bu aşamada Firebase kullanılmayacaktır.

Kullanıcı hesapları yerel veritabanında tutulacak.
Önceden tanımlanmış 10 kullanıcı bulunacak.
Yeni kullanıcı kayıt oluşturabilecek.
Kullanıcı giriş ve çıkış yapabilecek.
Takımlar ve randevular kaydedilebilecek.
Oyuncu davetleri gönderilebilecek.
Davetler kabul veya reddedilebilecek.
Takım sohbeti çalışacak.
Bildirimler kaydedilecek.
Uygulama kapatılıp açıldığında kayıtlı veriler korunacak.

Yerel veritabanı için SQLite tabanlı Drift tercih edilebilir.

Uygulama mimarisi Repository Pattern üzerine kurulmalıdır. Böylece ileride yerel veri kaynakları Firebase veri kaynaklarıyla değiştirilebilmelidir.

Önemli: Yerel prototipte farklı hesaplara giriş yapılarak davet, sohbet ve bildirim akışları aynı cihaz üzerinde test edilebilir. Farklı cihazlar arasında gerçek zamanlı veri paylaşımı Firebase veya başka bir sunucu entegrasyonu olmadan mümkün değildir.

Aşama 2 — Firebase entegrasyonu

İlerleyen aşamada:

Firebase Authentication
Cloud Firestore
Firebase Storage
Firebase Cloud Messaging

entegrasyonları yapılacaktır.

Bu aşamada mevcut ekran tasarımları ve iş kuralları korunmalıdır.

3. Uygulama Navigasyonu

Uygulama giriş yapıldıktan sonra dört ana sekmeden oluşan sabit alt navigasyon çubuğuna sahip olacaktır.

Sıra	Sekme	Görevi
1	Takım Kur	Yeni 7'ye 7 takım ve maç oluşturma
2	Randevularım	Oluşturulan ve katılınan maçları görüntüleme
3	Profil	Kullanıcı bilgileri ve tema ayarları
4	Sohbet	Oyuncu önerileri ve takım sohbeti

Alt navigasyon bütün ana ekranlarda sabit kalmalıdır.

Kullanıcı uygulamaya tekrar giriş yaptığında varsayılan olarak Takım Kur sekmesi açılmalıdır.

Bildirim ikonu ana sayfanın sağ üst köşesinde bulunmalıdır.

4. Giriş Ekranı

Uygulamanın ilk açılışında giriş ekranı gösterilecektir.

Ekran bileşenleri
Uygulama logosu ve adı.
E-posta veya telefon numarası giriş alanı.
Şifre giriş alanı.
Şifre görünürlüğünü açıp kapatma ikonu.
Giriş Yap butonu.
Hesabın yok mu? Hesap oluştur metni.
Giriş işlemi

Kullanıcı e-posta adresi veya telefon numarasıyla giriş yapabilmelidir.

Giriş işlemi şu şekilde gerçekleşmelidir:

E-posta veya telefon numarası boş bırakılamaz.
Şifre boş bırakılamaz.
Girilen bilgiler kayıtlı kullanıcılarla karşılaştırılır.
Bilgiler doğruysa ana sayfaya yönlendirilir.
Bilgiler yanlışsa kullanıcıya anlaşılır hata mesajı gösterilir.

Telefon numarası ve e-posta aynı kullanıcıyı temsil etmelidir.

5. Hesap Oluşturma Ekranı

Giriş ekranındaki Hesap oluştur bağlantısına basıldığında açılacaktır.

İstenen bilgiler
Ad
Soyad
E-posta
Telefon numarası
Şifre

Bütün alanlar zorunludur.

Sözleşme onayları

Hesap oluştur butonunun altında iki ayrı onay alanı bulunacaktır.

1. Kullanıcı Sözleşmesi

Yanında onay kutusu ve "Sözleşmeyi okudum ve anladım" yazısı bulunmalıdır.

Yazıya basıldığında kullanıcı sözleşmesi ayrı bir ekranda veya modal pencerede açılmalıdır.

2. KVKK Aydınlatma Metni

Yanında onay kutusu ve "KVKK metnini okudum ve anladım" yazısı bulunmalıdır.

Yazıya basıldığında KVKK aydınlatma metni açılmalıdır.

İlk test sürümünde bu iki metin için yapay zekâ yardımıyla örnek taslak metinler oluşturulabilir. Bunlar hukuken onaylanmış belgeler olarak kabul edilmemeli, gerçek kullanıcılarla yayına çıkmadan önce hukuk uzmanı tarafından incelenmelidir.

Kayıt koşulları

Hesap oluşturulabilmesi için:

Ad doldurulmalı.
Soyad doldurulmalı.
Geçerli e-posta girilmeli.
Telefon numarası girilmeli.
Şifre belirlenmeli.
Kullanıcı sözleşmesi onaylanmalı.
KVKK aydınlatma metni onayı verilmelidir.

Ayrıca e-posta ve telefon numarası başka bir hesapta kayıtlı olmamalıdır.

Başarılı kayıt sonrasında:

Kullanıcı yerel veritabanına kaydedilir.
Başarılı kayıt mesajı gösterilir.
Kullanıcı giriş ekranına yönlendirilir.
Kullanıcı yeni oluşturduğu hesapla giriş yapabilir.
6. Önceden Kayıtlı Test Hesapları

Aşağıdaki 10 kullanıcı uygulamanın ilk kurulumunda önceden kayıtlı olarak bulunmalıdır.

No	Ad	Soyad	E-posta	Telefon	Şifre
1	cristiano	Ronaldo	cr7@gmail.com	05111111111	cris7
2	lionel	messi	m10@gmail.com	05222222222	messi10
3	Manuel	neur	neur1@gmail.com	05333333333	neur1
4	Sergio	Ramos	ramos4@gmail.com	05444444444	ramos4
5	lamine	yamal	lamine@gmail.com	05555555555	yamal10
6	kylian	mbappe	mbappe@gmail.com	05666666666	mbappe10
7	hary	kane	kane@gmail.com	05777777777	kane9
8	erling	Haaland	haaland@gmail.com	05888888888	haaland9
9	ronaldinho	gaucho	r10@gmail.com	05999999999	ronaldinho10
10	arjen	Robben	robben@gmail.com	05000000000	robben10
Test hesabı kuralları
Bu hesaplar uygulamanın ilk çalıştırılmasında otomatik oluşturulmalıdır.
Uygulama her açıldığında tekrar oluşturulmamalıdır.
E-posta ve telefon numarasıyla giriş desteklenmelidir.
Hesapların her biri bağımsız kullanıcı olarak davranmalıdır.
Bir kullanıcıya ait profil bilgileri başka kullanıcının profiline karışmamalıdır.

Güvenlik notu: Verilen şifreler yalnızca geliştirme ortamında test amacıyla kullanılmalıdır. Şifreler üretim ortamında düz metin olarak saklanmamalıdır. Yerel prototipte bile parola hash'leme tercih edilmelidir.

7. Ana Sayfa — Takım Kur

Giriş sonrasında açılacak varsayılan ekrandır.

Ekranın sağ üst köşesinde bildirim ikonu bulunacaktır.

Bildirim ikonuna basıldığında Bildirimler ekranı açılacaktır.

Ekranın alt kısmında dört sekmeli navigasyon bulunacaktır.

7.1. İl seçimi

Takım kurma alanının üst bölümünde beş adet eşit boyutlu seçim butonu bulunmalıdır.

İlk buton il seçimidir.

Türkiye'nin 81 ili listelenmelidir.

İl listesi alfabetik sıralanmalıdır.

7.2. İlçe seçimi

İkinci buton ilçe seçimidir.

Önce il seçilmelidir.
İl seçilmeden ilçe seçilememelidir.
Seçilen ile ait ilçeler gösterilmelidir.
İl değiştirildiğinde önceki ilçe seçimi sıfırlanmalıdır.

Türkiye'nin 81 iline ait ilçeler gerçek ve güncel bir coğrafi veri kaynağından alınmalıdır.

İl ve ilçe bilgileri kod içerisinde tek tek ekranlara yazılmak yerine JSON veya benzeri bir veri dosyasında tutulmalıdır.

7.3. Halı saha seçimi

Üçüncü buton halı saha seçimidir.

İl ve ilçe seçildikten sonra bu bölgeye uygun halı saha isimleri gösterilmelidir.

İlk test sürümünde:

Halı saha isimleri otomatik üretilebilir.
Her ilçede değişen sayıda örnek halı saha bulunabilir.
Aynı ilçeye ait farklı halı sahalar listelenebilir.
Seçilen halı saha maç bilgilerine kaydedilmelidir.

Bu isimler test verisidir; gerçek işletme veya rezervasyon bilgisi olarak sunulmamalıdır.

İleride gerçek halı saha işletmeleri sisteme eklenebilir.

7.4. Tarih seçimi

Dördüncü buton tarih seçimidir.

Tıklandığında takvim penceresi açılmalıdır.

Takvim:

12 ayı kapsamalıdır.
Her ay kendi gün sayısına sahip olmalıdır.
Artık yıllar desteklenmelidir.
Gün, ay ve yıl seçilebilmelidir.
Geçmiş tarihler için maç oluşturulması engellenmelidir.

Seçilen tarih ana ekrandaki tarih butonunda gösterilmelidir.

7.5. Saat seçimi

Beşinci buton saat seçimidir.

Maç süresi 1 saattir.

24 saatlik sistem kullanılmalıdır.

Saat seçenekleri:

00.00 - 01.00
01.00 - 02.00
02.00 - 03.00
...
22.00 - 23.00
23.00 - 00.00

Toplam 24 farklı saat aralığı bulunmalıdır.

Kullanıcı yalnızca bir saat aralığı seçebilmelidir.

8. Diziliş Sistemi

Beş konum seçim butonunun altında diziliş seçimi için yatay ve geniş bir buton bulunmalıdır.

Bu butona tıklandığında altı farklı diziliş seçeneği gösterilmelidir.

Her dizilişte toplam 7 oyuncu bulunmalıdır.

Kaleci bütün dizilişlerde sabittir.

Desteklenecek dizilişler
Diziliş	Kaleci	Defans	Orta saha	Forvet
3-3	1	3	0	3
3-1-2	1	3	1	2
3-2-1	1	3	2	1
2-3-1	1	2	3	1
2-1-3	1	2	1	3
2-2-2	1	2	2	2

Her diziliş için futbol sahası görünümünde oyuncu yerleşimi gösterilmelidir.

Oyuncu butonları

Her mevki ayrı bir buton şeklinde tasarlanmalıdır.

Örnek:

Kaleci
Defans 1
Defans 2
Defans 3
Orta saha 1
Forvet 1
Forvet 2

Dizilişe göre oyuncu sayısı otomatik değişmelidir.

Bir mevki butonuna basıldığında oyuncu bilgisi girilebilecek küçük bir pencere açılmalıdır.

Kullanıcı:

Sadece ad yazabilir.
Ad ve soyad yazabilir.

Oyuncu isimleri zorunlu değildir. Boş pozisyonlar davet gönderilene veya kullanıcı tarafından doldurulana kadar boş kalabilir.

Takımı kuran kullanıcı takım kaptanı ve organizasyon sahibidir.

Diziliş tamamlama ikonu

Diziliş butonunun yanında yeşil tik ikonu bulunmalıdır.

Kullanıcı aşağıdaki bilgileri tamamladığında kaydetme işlemi etkinleşmelidir:

Diziliş
İl
İlçe
Halı saha
Tarih
Saat

Kadrodaki bütün oyuncuların isimlerinin doldurulması zorunlu değildir.

Yeşil tik ikonuna basıldığında:

Takım oluşturulur.
Randevu kaydedilir.
Takım sahibi kaptan olarak atanır.
Takım bilgileri veritabanına kaydedilir.
Randevularım sekmesine yönlendirme yapılabilir veya başarı mesajı gösterilir.

Bir takım aynı maç için yalnızca bir kez oluşturulmalıdır.

9. Randevularım Ekranı

Bu ekranda kullanıcının oluşturduğu ve davet kabul ederek katıldığı maçlar gösterilmelidir.

Her randevu bir kart şeklinde tasarlanmalıdır.

Kart içerisinde:

Takım adı veya kaptan adı
İl
İlçe
Halı saha
Tarih
Saat
Diziliş
Takım kadrosu
Kullanıcının takımdaki rolü

bulunmalıdır.

Üç nokta menüsü

Her randevu kartının sağ üst köşesinde üç nokta ikonu bulunmalıdır.

İlk sürümde menüde yalnızca:

Randevuyu Sil

seçeneği bulunacaktır.

Silme işleminden önce onay penceresi açılmalıdır.

Kullanıcı onay verdiğinde randevu kendi randevu listesinden silinmelidir.

Takım sahibi tarafından oluşturulan maçın silinmesiyle takımın davet ve sohbet kayıtlarının nasıl etkileneceği ayrı bir iş kuralı olarak yönetilmelidir. Bir oyuncunun kendi listesinden silmesi, diğer oyuncuların randevusunu silmemelidir.

10. Profil Ekranı

Profil ekranında kayıt sırasında girilen bilgiler görüntülenmelidir.

Ad
Soyad
E-posta
Telefon numarası

Kullanıcı kendi profil bilgilerini görüntüleyebilmelidir.

Tema sistemi

Profil sayfasında açık/kapalı tema seçeneği bulunmalıdır.

İki tema desteklenmelidir:

Light Mode
Dark Mode

Kullanıcı temayı değiştirdiğinde uygulamanın bütün ekranları yeni temaya geçmelidir.

Tema tercihi yerel olarak saklanmalı ve uygulama tekrar açıldığında korunmalıdır.

11. Sohbet Ekranı

Sohbet ekranının üst kısmında iki ayrı sekme bulunmalıdır.

Oyuncu Önerileri
Sohbet
11.1. Oyuncu Önerileri

Bu sekmede önceden tanımlanmış 10 kullanıcı listelenmelidir.

Kullanıcı kendi hesabını listede görmemelidir.

Her kullanıcı kartında:

Profil fotoğrafı veya avatar
Ad soyad
Davet Yolla butonu

bulunmalıdır.

Davet Yolla butonuna basıldığında davet gönderme işlemi başlatılmalıdır.

Davet gönderme işleyişi

Davet gönderen kişi önce bir takım ve boş mevki seçmelidir.

Sistem:

Hedef kullanıcının aynı takıma daha önce davet edilip edilmediğini kontrol eder.
Takımda boş mevki olup olmadığını kontrol eder.
Davet kaydı oluşturur.
Hedef kullanıcının bildirimlerine davet isteği ekler.
Davet durumunu Beklemede olarak kaydeder.

Aynı kullanıcıya aynı takıma tekrar tekrar bekleyen davet gönderilmemelidir.

11.2. Takım Sohbeti

Sohbet sekmesinde kullanıcının üyesi olduğu takımlar listelenmelidir.

Kullanıcı bir takım seçtiğinde o takıma ait sohbet ekranı açılmalıdır.

Sohbet ekranında:

Mesaj listesi
Mesaj yazma alanı
Gönder butonu
Mesaj sahibi adı
Mesaj gönderim zamanı

bulunmalıdır.

Takımın bütün üyeleri aynı sohbet kayıtlarını görmelidir.

Bir kullanıcı mesaj gönderdiğinde mesaj o takımın sohbetine kaydedilmelidir.

Diğer takım üyeleri de aynı mesajı görebilmelidir.

Yerel prototipte bu işlem ortak yerel veri deposu üzerinden gerçekleştirilmelidir.

Firebase entegrasyonunda gerçek zamanlı dinleyiciler kullanılmalıdır.

12. Bildirimler Ekranı

Ana sayfanın sağ üstündeki bildirim ikonuyla açılır.

Bildirim türleri:

Takım daveti
Davet kabul edildi
Davet reddedildi
Takım ile ilgili bilgilendirme
Gelen davet bildirimi

Bir kullanıcı davet aldığında bildirim listesinde davet kartı görünmelidir.

Kartın içerisinde:

Davet gönderen kişinin adı
İl
İlçe
Halı saha adı
Tarih
Saat
Diziliş
Takım kadrosu
Davet edilen mevki

gösterilmelidir.

Kullanıcı daveti açtığında iki seçenek bulunmalıdır:

Kabul Et
Reddet
Kabul etme işlemi

Kullanıcı Kabul Et butonuna bastığında:

Davetin durumu Kabul Edildi olur.
Kullanıcı takımın üyesi yapılır.
Kullanıcı kendisine ayrılan mevkiye eklenir.
Randevu kullanıcının Randevularım sayfasına eklenir.
Takım sohbetine erişim hakkı kazanır.
Daveti gönderen kullanıcıya kabul bildirimi gönderilir.
Reddetme işlemi

Kullanıcı Reddet butonuna bastığında:

Davetin durumu Reddedildi olarak kaydedilir.
Kullanıcı takıma eklenmez.
Daveti gönderen kullanıcıya ret bildirimi gönderilir.
Ayrılan mevki tekrar boş hale gelir.

Davet durumları:

Pending
Accepted
Rejected
Cancelled

Bir davet yalnızca bir kez sonuçlandırılabilmelidir.

13. Veri Modeli

Veritabanı yapısı Firebase'e geçişe uygun hazırlanmalıdır.

User
id
firstName
lastName
email
phone
passwordHash
profileImage
themeMode
createdAt
Team
id
captainId
formation
province
district
venueName
matchDate
startTime
endTime
createdAt
status
TeamMember
id
teamId
userId
position
displayName
role
joinedAt
Invitation
id
teamId
senderId
receiverId
position
status
createdAt
respondedAt
Match
id
teamId
venueName
province
district
matchDate
startTime
endTime
Message
id
teamId
senderId
content
createdAt
Notification
id
receiverId
senderId
type
relatedTeamId
relatedInvitationId
title
body
isRead
createdAt
Consent
id
userId
documentType
documentVersion
accepted
acceptedAt
14. İş Kuralları
Bir takımda en fazla 7 oyuncu bulunabilir.
Takımı oluşturan kişi takım kaptanıdır.
Kaleci dahil toplam oyuncu sayısı 7'dir.
Aynı mevkiye iki kişi atanamaz.
Takımın dolu mevkisine yeni davet gönderilemez.
Kabul edilen davet ilgili mevkiyi doldurur.
Reddedilen davet mevkiyi boş bırakır.
Takım üyesi olmayan kişiler takım sohbetine erişemez.
Kullanıcı kendi kendisine davet gönderemez.
Kullanıcı aynı takıma birden fazla kez üye olamaz.
Bekleyen davetler tekrar oluşturulmamalıdır.
Randevu ve takım bilgileri ilişkili tutulmalıdır.
Bir kullanıcının tema tercihi diğer kullanıcıların temasını değiştirmemelidir.
E-posta ve telefon numarası benzersiz olmalıdır.
15. Tasarım İlkeleri

Uygulama modern, sportif, profesyonel ve kolay kullanılabilir olmalıdır.

Tasarım yaklaşımı
Modern futbol uygulaması görünümü.
Temiz ve sade arayüz.
Kolay anlaşılabilen ikonlar.
Yuvarlatılmış kartlar ve butonlar.
Tutarlı boşluk ve hizalama.
Responsive tasarım.
Light ve Dark Mode desteği.
Kullanıcı dostu hata mesajları.
Gereksiz karmaşadan uzak ekranlar.
Renk yaklaşımı

İlk tasarım aşamasında:

Ana renk: Koyu yeşil.
İkincil renk: Canlı futbol sahası yeşili.
Arka plan: Açık gri veya koyu antrasit.
Başarı: Yeşil.
Hata: Kırmızı.
Bilgi: Mavi.

Renkler merkezi bir ThemeData yapısından yönetilmelidir.

Futbol sahası diziliş görünümü

Oyuncu pozisyonları gerçek futbol sahası görünümünde gösterilmelidir.

Kaleci kalenin önünde.
Defans kalecinin önünde.
Orta saha defansın önünde.
Forvet hücum bölgesinde.

Diziliş değiştiğinde oyuncular otomatik olarak yeniden konumlandırılmalıdır.

16. Önerilen Flutter Teknolojileri
Flutter
Dart
Material 3
Riverpod: State management
GoRouter: Navigation
Drift / SQLite: Yerel veritabanı
SharedPreferences: Küçük ayarlar ve tercihler
Flutter Localizations: Tarih ve yerelleştirme
UUID: Benzersiz kayıt kimlikleri

Paket sürümleri geliştirme sırasında güncel ve birbiriyle uyumlu olacak şekilde seçilmelidir.

17. Proje Tamamlanma Kriterleri

İlk sürüm tamamlandığında aşağıdaki işlemlerin tamamı çalışmalıdır:

Giriş ekranı açılmalı.
10 test hesabıyla giriş yapılabilmeli.
E-posta ile giriş çalışmalı.
Telefon numarası ile giriş çalışmalı.
Yeni hesap oluşturulabilmeli.
Zorunlu alanlar kontrol edilmeli.
İki sözleşme onayı olmadan kayıt yapılamamalı.
Kullanıcı girişten sonra Takım Kur ekranına gelmeli.
81 il seçilebilmeli.
İl seçimine göre ilçeler filtrelenmeli.
Halı saha seçilebilmeli.
Takvimden tarih seçilebilmeli.
24 saat aralığı arasından seçim yapılabilmeli.
Altı farklı diziliş çalışmalı.
Oyuncu isimleri girilebilmeli.
Takım oluşturulabilmeli.
Randevularım ekranında takım görünmeli.
Randevu silinebilmeli.
Profil bilgileri görüntülenebilmeli.
Tema değiştirilebilmeli.
Oyuncu önerileri listelenmeli.
Davet gönderilebilmeli.
Davet kabul ve ret işlemleri çalışmalı.
Kabul edilen oyuncu takıma eklenmeli.
Bildirimler çalışmalı.
Takım sohbeti çalışmalı.
Uygulama kapatılıp açıldığında veriler korunmalı.

Geliştirme prensibi: Her özellik ayrı ayrı geliştirilip test edilmeden sonraki aşamaya geçilmemelidir.