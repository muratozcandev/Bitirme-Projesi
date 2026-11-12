import 'dart:io';

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('lib klasörü bulunamadı.');
    exit(1);
  }

  final dartFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  var totalFiles = 0;
  var totalLinesCommented = 0;

  for (final file in dartFiles) {
    final lines = file.readAsLinesSync();
    final updatedLines = <String>[];
    var inTripleSingle = false;
    var inTripleDouble = false;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();

      if (trimmed.isEmpty) {
        updatedLines.add(line);
        continue;
      }

      final wasInMultiline = inTripleSingle || inTripleDouble;
      final singleToggleCount = _countTripleQuotes(line, "'''");
      final doubleToggleCount = _countTripleQuotes(line, '"""');

      if (!inTripleDouble && singleToggleCount % 2 == 1) {
        inTripleSingle = !inTripleSingle;
      }
      if (!inTripleSingle && doubleToggleCount % 2 == 1) {
        inTripleDouble = !inTripleDouble;
      }

      // Çok satırlı string (''' veya """) açılış satırına veya iç satırlarına
      // dokunma (metin/SQL içeriğinin bozulmaması için); yalnızca kapanış satırına (`''';` veya `''');`) yorum ekle.
      final isNowInMultiline = inTripleSingle || inTripleDouble;
      if (isNowInMultiline) {
        updatedLines.add(line);
        continue;
      }
      if (wasInMultiline && !isNowInMultiline) {
        if (!_hasTrailingCommentOutsideQuotes(line)) {
          updatedLines.add('$line // Çok satırlı metin/SQL bloğunu kapatır');
          totalLinesCommented++;
        } else {
          updatedLines.add(line);
        }
        continue;
      }

      // Zaten yorum satırıysa veya satır sonunda yorum varsa koru
      if (trimmed.startsWith('//') || _hasTrailingCommentOutsideQuotes(line)) {
        updatedLines.add(line);
        continue;
      }

      final explanation = _describeLine(trimmed, file.path);
      updatedLines.add('$line // $explanation');
      totalLinesCommented++;
    }

    file.writeAsStringSync('${updatedLines.join('\n')}\n');
    totalFiles++;
  }

  stdout.writeln(
    '✅ Toplam $totalFiles dosyada $totalLinesCommented kod satırının karşısına açıklama yorumu eklendi.',
  );
}

int _countTripleQuotes(String line, String marker) {
  var count = 0;
  var idx = 0;
  while (true) {
    final found = line.indexOf(marker, idx);
    if (found == -1) break;
    count++;
    idx = found + 3;
  }
  return count;
}

bool _hasTrailingCommentOutsideQuotes(String line) {
  var inSingle = false;
  var inDouble = false;
  for (var i = 0; i < line.length - 1; i++) {
    final ch = line[i];
    if (ch == '\\') {
      i++;
      continue;
    }
    if (!inDouble && ch == "'") {
      inSingle = !inSingle;
    } else if (!inSingle && ch == '"') {
      inDouble = !inDouble;
    } else if (!inSingle && !inDouble && ch == '/' && line[i + 1] == '/') {
      return true;
    }
  }
  return false;
}

String _describeLine(String t, String filePath) {
  // 1. IMPORT & EXPORT İFADELERİ
  if (t.startsWith('import ')) {
    if (t.contains('flutter/material.dart')) {
      return 'Flutter Material tasarım bileşenlerini içe aktarır';
    }
    if (t.contains('flutter/foundation.dart')) {
      return 'Flutter temel platform ve debug yardımcılarını içe aktarır';
    }
    if (t.contains('flutter_localizations')) {
      return 'Çoklu dil ve Türkçe yerelleştirme desteğini içe aktarır';
    }
    if (t.contains('flutter_riverpod')) {
      return 'Riverpod durum yönetimi (state management) paketini içe aktarır';
    }
    if (t.contains('go_router')) {
      return 'GoRouter sayfa yönlendirme paketini içe aktarır';
    }
    if (t.contains('cloud_firestore')) {
      return 'Cloud Firestore bulut veritabanı paketini içe aktarır';
    }
    if (t.contains('firebase_auth')) {
      return 'Firebase Authentication kimlik doğrulama paketini içe aktarır';
    }
    if (t.contains('firebase_core')) {
      return 'Firebase temel başlatma (core) paketini içe aktarır';
    }
    if (t.contains('shared_preferences')) {
      return 'Yerel anahtar-değer (SharedPreferences) depolama paketini içe aktarır';
    }
    if (t.contains('sqflite')) {
      return 'SQLite yerel veritabanı sürücüsünü içe aktarır';
    }
    if (t.contains('crypto')) {
      return 'SHA-256 şifreleme/hash kütüphanesini içe aktarır';
    }
    if (t.contains('uuid')) {
      return 'Benzersiz kimlik (UUID) üretici paketi içe aktarır';
    }
    if (t.contains('dart:convert')) {
      return 'JSON ve UTF-8/Base64 dönüştürme kütüphanesini içe aktarır';
    }
    if (t.contains('dart:io')) {
      return 'İşletim sistemi ve dosya işlemleri kütüphanesini içe aktarır';
    }
    if (t.contains('dart:math')) {
      return 'Matematiksel hesaplama kütüphanesini içe aktarır';
    }
    if (t.contains('flutter/services.dart')) {
      return 'Asset dosyalarını (JSON vb.) okuma servisini içe aktarır';
    }
    return 'İlgili proje modülünü veya bağımlılığını içe aktarır';
  }
  if (t.startsWith('show ')) {
    return 'İçe aktarılan paketten yalnızca belirtilen sembolleri görünür kılar';
  }

  // 2. SINIF, ENUM VE METOT TANIMLARI
  if (t.startsWith('abstract class ')) {
    final name = t.split(' ')[2];
    return '$name soyut arayüz (interface) sınıfını tanımlar';
  }
  if (t.startsWith('class ')) {
    final name = t.split(' ')[1].split('<').first;
    if (t.contains('ConsumerStatefulWidget')) {
      return 'Riverpod destekli durum bilgili (Stateful) $name ekran bileşenini tanımlar';
    }
    if (t.contains('ConsumerState<')) {
      return '$name ekranının Riverpod destekli durum (State) sınıfını tanımlar';
    }
    if (t.contains('ConsumerWidget')) {
      return 'Riverpod sağlayıcılarını dinleyebilen $name görsel bileşenini tanımlar';
    }
    if (t.contains('StatelessWidget')) {
      return 'Durumsuz (Stateless) $name görsel bileşenini tanımlar';
    }
    if (t.contains('StatefulWidget')) {
      return 'Durum bilgili (Stateful) $name görsel bileşenini tanımlar';
    }
    if (t.contains('StateNotifier<')) {
      return 'Durum değişikliklerini yöneten $name StateNotifier sınıfını tanımlar';
    }
    if (t.contains('CustomPainter')) {
      return 'Tuval (Canvas) üzerine özel çizim yapan $name sınıfını tanımlar';
    }
    if (t.contains('implements Exception')) {
      return 'Uygulama içi özel hata ($name) sınıfını tanımlar';
    }
    if (t.contains('implements ')) {
      return '$name veri erişim (repository) sınıfını tanımlar';
    }
    return '$name veri/yardımcı sınıfını tanımlar';
  }
  if (t.startsWith('enum ')) {
    final name = t.split(' ')[1];
    return '$name sabit seçenekler (enum) kümesini tanımlar';
  }
  if (t == '@override') {
    return 'Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir';
  }

  // 3. YÖNLENDİRME (GOROUTER) VE PROVIDER İFADELERİ
  if (t.contains('Provider<') ||
      t.contains('FutureProvider') ||
      t.contains('StateNotifierProvider') ||
      t.contains('StateProvider')) {
    return 'Uygulama genelinde erişilen Riverpod sağlayıcısını (provider) tanımlar';
  }
  if (t.contains('ref.watch(')) {
    return 'İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer';
  }
  if (t.contains('ref.read(')) {
    return 'İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur';
  }
  if (t.contains('ref.listen<') || t.contains('ref.listen(')) {
    return 'Durum değişikliklerini dinleyerek yan etkileri (yönlendirme vb.) tetikler';
  }
  if (t.contains('GoRouter(')) {
    return 'Uygulamanın sayfa yönlendirme (GoRouter) yapılandırmasını oluşturur';
  }
  if (t.contains('GoRoute(')) {
    return 'Belirli bir URL yolu (path) için ekran rotası tanımlar';
  }
  if (t.contains('StatefulShellRoute')) {
    return 'Alt gezinme çubuğu (BottomNavigationBar) sekmelerinin durumunu koruyan kabuk rotayı tanımlar';
  }
  if (t.contains('StatefulShellBranch(')) {
    return 'Alt gezinme çubuğundaki her bir sekme dalını tanımlar';
  }
  if (t.contains('context.go(')) {
    return 'Belirtilen rotaya doğrudan geçiş yapar (navigasyon geçmişini sıfırlar)';
  }
  if (t.contains('context.push(')) {
    return 'Yeni ekranı mevcut ekranın üzerine açar (geri dönülebilir)';
  }
  if (t.contains('Navigator.pop(') || t.contains('context.pop(')) {
    return 'Açık olan pencereyi veya üst ekranı kapatıp önceki ekrana döner';
  }

  // 4. FIREBASE VE SQLITE VERİTABANI İŞLEMLERİ
  if (t.contains('Firebase.initializeApp')) {
    return 'Platforma özel ayarlarla Firebase bağlantısını başlatır';
  }
  if (t.contains('signInWithEmailAndPassword')) {
    return 'Firebase Authentication üzerinden e-posta ve şifre ile oturum açar';
  }
  if (t.contains('createUserWithEmailAndPassword')) {
    return 'Firebase Authentication üzerinde yeni e-posta ve şifre ile hesap oluşturur';
  }
  if (t.contains('.signOut()')) {
    return 'Aktif Firebase Authentication kullanıcı oturumunu kapatır';
  }
  if (t.contains('runTransaction')) {
    return 'Firestore üzerinde atomik (ya hep ya hiç) veritabanı işlemini başlatır';
  }
  if (t.contains("collection('users')") || t.contains("collection('phone_lookup')")) {
    return 'Firestore üzerindeki ilgili koleksiyona/belgeye referans alır';
  }
  if (t.contains('transaction.get(')) {
    return 'Atomik transaction içinde hedef Firestore belgesini okur';
  }
  if (t.contains('transaction.set(')) {
    return 'Atomik transaction içinde hedef Firestore belgesine veri yazar';
  }
  if (t.contains('.query(')) {
    return 'SQLite veritabanı tablosundan koşullu veri sorgular';
  }
  if (t.contains('.insert(')) {
    return 'SQLite veritabanı tablosuna yeni kayıt ekler';
  }
  if (t.contains('.update(')) {
    return 'Veritabanındaki mevcut kaydı günceller';
  }
  if (t.contains('.delete(')) {
    return 'Veritabanındaki kaydı veya hesabı siler';
  }
  if (t.contains('openDatabase(')) {
    return 'SQLite veritabanı dosyasını açar ve ilk kurulum kancalarını tanımlar';
  }

  // 5. WIDGET VE ARAYÜZ (UI) BİLEŞENLERİ
  if (t.startsWith('Widget build(')) {
    return 'Ekranın veya bileşenin görsel arayüz ağacını oluşturur';
  }
  if (t.contains('MaterialApp.router(')) {
    return 'GoRouter ve tema destekli ana Material uygulama kökünü oluşturur';
  }
  if (t.contains('Scaffold(')) {
    return 'Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur';
  }
  if (t.contains('AppBar(')) {
    return 'Ekranın üst başlık çubuğunu (AppBar) oluşturur';
  }
  if (t.contains('SafeArea(')) {
    return 'İçeriği telefonun çentik ve sistem çubuğu alanlarından korur';
  }
  if (t.contains('SingleChildScrollView(')) {
    return 'İçeriğin ekrana sığmadığında dikey/yatay kaydırılabilmesini sağlar';
  }
  if (t.contains('Column(')) {
    return 'Alt bileşenleri dikey eksende alt alta dizer';
  }
  if (t.contains('Row(')) {
    return 'Alt bileşenleri yatay eksende yan yana dizer';
  }
  if (t.contains('Stack(')) {
    return 'Alt bileşenleri üst üste katmanlar halinde yerleştirir';
  }
  if (t.contains('Card(')) {
    return 'Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur';
  }
  if (t.contains('Container(')) {
    return 'Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur';
  }
  if (t.contains('Padding(')) {
    return 'İçindeki bileşenin etrafına iç boşluk (padding) ekler';
  }
  if (t.contains('SizedBox(')) {
    return 'Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur';
  }
  if (t.contains('Expanded(')) {
    return 'Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur';
  }
  if (t.contains('Flexible(')) {
    return 'İçeriğin taşmasını önlemek için esnek boyutlandırma sağlar';
  }
  if (t.contains('Center(')) {
    return 'İçindeki bileşeni yatay ve dikey olarak ortalar';
  }
  if (t.contains('Align(')) {
    return 'İçindeki bileşeni belirtilen hizaya konumlandırır';
  }
  if (t.contains('ListView')) {
    return 'Kaydırılabilir liste görünümü oluşturur';
  }
  if (t.contains('CustomTextField(') || t.contains('TextFormField(') || t.contains('TextField(')) {
    return 'Kullanıcıdan metin girdisi alan form alanını oluşturur';
  }
  if (t.contains('CustomButton(') ||
      t.contains('ElevatedButton') ||
      t.contains('OutlinedButton') ||
      t.contains('TextButton') ||
      t.contains('IconButton(')) {
    return 'Tıklanabilir aksiyon butonunu oluşturur';
  }
  if (t.contains('Text(')) {
    return 'Ekrana metin bileşeni yazdırır';
  }
  if (t.contains('Icon(')) {
    return 'Ekranda vektörel ikon gösterir';
  }
  if (t.contains('CircularProgressIndicator(')) {
    return 'İşlem devam ederken dönen yükleme göstergesi çizer';
  }
  if (t.contains('ScaffoldMessenger.of(context).showSnackBar') || t.contains('SnackBar(')) {
    return 'Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir';
  }
  if (t.contains('showModalBottomSheet')) {
    return 'Ekranın altından açılan seçim penceresini (BottomSheet) gösterir';
  }
  if (t.contains('showDatePicker')) {
    return 'Kullanıcının maç tarihi seçmesi için takvim penceresini açar';
  }
  if (t.contains('NavigationBar(')) {
    return 'Uygulamanın alt gezinme çubuğunu (4 ana sekme) oluşturur';
  }
  if (t.contains('NavigationDestination(')) {
    return 'Alt gezinme çubuğundaki sekme öğesini tanımlar';
  }

  // 6. KONTROL AKIŞI, DEĞİŞKENLER VE GENEL İFADELER
  if (t.startsWith('final ') || t.startsWith('const ') || t.startsWith('static const ') || t.startsWith('static final ')) {
    if (t.endsWith(';')) {
      return 'Değişmez (sabit/final) alanı veya değişkeni tanımlar';
    }
    return 'Sabit/final değişken veya nesne tanımını başlatır';
  }
  if (t.startsWith('required this.')) {
    final prop = t.replaceAll('required this.', '').replaceAll(',', '').trim();
    return '$prop parametresinin dışarıdan zorunlu olarak verilmesini sağlar';
  }
  if (t.startsWith('this.')) {
    final prop = t.replaceAll('this.', '').replaceAll(',', '').trim();
    return '$prop sınıf alanını yapıcı (constructor) parametresiyle eşleştirir';
  }
  if (t.startsWith('super.')) {
    return 'Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır';
  }
  if (t.startsWith('if (')) {
    return 'Koşulun sağlanıp sağlanmadığını kontrol eder';
  }
  if (t.startsWith('} else if (')) {
    return 'Önceki koşul sağlanmadıysa alternatif koşulu kontrol eder';
  }
  if (t == '} else {' || t.startsWith('else {')) {
    return 'Koşul sağlanmadığında çalışacak alternatif bloğu başlatır';
  }
  if (t.startsWith('for (')) {
    return 'Koleksiyon veya aralık üzerinde döngü başlatır';
  }
  if (t.startsWith('switch (')) {
    return 'Değere göre çoklu durum kontrolü (switch) başlatır';
  }
  if (t.startsWith('case ')) {
    return 'Belirtilen durum eşleştiğinde çalışacak dalı tanımlar';
  }
  if (t.startsWith('default:')) {
    return 'Hiçbir durum eşleşmediğinde çalışacak varsayılan dalı tanımlar';
  }
  if (t.startsWith('try {')) {
    return 'Hata yakalama (try) bloğunu başlatır';
  }
  if (t.startsWith('} on ') || t.startsWith('} catch') || t.startsWith('catch (')) {
    return 'Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır';
  }
  if (t.startsWith('throw ')) {
    return 'İlgili hata nesnesini (Exception) fırlatır';
  }
  if (t == 'rethrow;') {
    return 'Yakalanan hatayı üst katmana yeniden fırlatır';
  }
  if (t.startsWith('return ')) {
    return 'Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür';
  }
  if (t.startsWith('await ')) {
    return 'Asenkron işlemin tamamlanmasını bekler';
  }
  if (t.startsWith('setState(')) {
    return 'Yerel durumu güncelleyerek ekranın yeniden çizilmesini tetikler';
  }
  if (t.contains('.dispose()')) {
    return 'Bellek sızıntısını önlemek için kontrolcüyü temizler';
  }
  if (t.contains(': ') && (t.endsWith(',') || t.endsWith('{'))) {
    final key = t.split(':').first.trim();
    return '$key özelliğini yapılandırır';
  }
  if (t == '}' || t == '};' || t == '},' || t == ');' || t == '),' || t == '],' || t == '];') {
    return 'Açık olan kod/bileşen bloğunu kapatır';
  }

  return 'İlgili kod satırını ve işlemi yürütür';
}
