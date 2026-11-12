import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import '../data/legal_texts.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class LegalDocumentScreen extends StatelessWidget { // Durumsuz (Stateless) LegalDocumentScreen görsel bileşenini tanımlar
  final String documentType; // 'user_agreement' | 'kvkk'

  const LegalDocumentScreen({ // Sabit/final değişken veya nesne tanımını başlatır
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.documentType, // documentType parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  bool get _isKvkk => documentType == 'kvkk'; // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final title = // Sabit/final değişken veya nesne tanımını başlatır
        _isKvkk ? LegalTexts.kvkkTitle : LegalTexts.userAgreementTitle; // İlgili kod satırını ve işlemi yürütür
    final content = // Sabit/final değişken veya nesne tanımını başlatır
        _isKvkk ? LegalTexts.kvkkContent : LegalTexts.userAgreementContent; // İlgili kod satırını ve işlemi yürütür
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    return Scaffold( // Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur
      appBar: AppBar( // Ekranın üst başlık çubuğunu (AppBar) oluşturur
        title: Text(title), // Ekrana metin bileşeni yazdırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      body: SafeArea( // İçeriği telefonun çentik ve sistem çubuğu alanlarından korur
        child: Column( // Alt bileşenleri dikey eksende alt alta dizer
          children: [ // İlgili kod satırını ve işlemi yürütür
            Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
              width: double.infinity, // width özelliğini yapılandırır
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8), // margin özelliğini yapılandırır
              padding: const EdgeInsets.all(12), // padding özelliğini yapılandırır
              decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45), // color özelliğini yapılandırır
                borderRadius: BorderRadius.circular(12), // borderRadius özelliğini yapılandırır
                border: Border.all( // İlgili kod satırını ve işlemi yürütür
                  color: theme.colorScheme.primary.withValues(alpha: 0.3), // color özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
              child: Row( // Alt bileşenleri yatay eksende yan yana dizer
                children: [ // İlgili kod satırını ve işlemi yürütür
                  Icon( // Ekranda vektörel ikon gösterir
                    Icons.verified_user_outlined, // İlgili kod satırını ve işlemi yürütür
                    color: theme.colorScheme.primary, // color özelliğini yapılandırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(width: 10), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                  Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                    child: Text( // Ekrana metin bileşeni yazdırır
                      'Lütfen metni dikkatlice inceleyiniz. Onay kutucuğunu işaretleyerek kayıt işlemini tamamlayabilirsiniz.', // İlgili kod satırını ve işlemi yürütür
                      style: theme.textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
                        fontWeight: FontWeight.w600, // fontWeight özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ], // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
              child: SingleChildScrollView( // İçeriğin ekrana sığmadığında dikey/yatay kaydırılabilmesini sağlar
                padding: const EdgeInsets.all(16), // padding özelliğini yapılandırır
                child: Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                  child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
                    padding: const EdgeInsets.all(18), // padding özelliğini yapılandırır
                    child: SelectableText( // Ekrana metin bileşeni yazdırır
                      content, // İlgili kod satırını ve işlemi yürütür
                      style: theme.textTheme.bodyMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                        height: 1.55, // height özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16), // padding özelliğini yapılandırır
              child: SizedBox( // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                width: double.infinity, // width özelliğini yapılandırır
                child: ElevatedButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
                  onPressed: () => Navigator.of(context).pop(true), // onPressed özelliğini yapılandırır
                  icon: const Icon(Icons.check_circle_outline), // Ekranda vektörel ikon gösterir
                  label: const Text('Okudum ve Anladım'), // Ekrana metin bileşeni yazdırır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

