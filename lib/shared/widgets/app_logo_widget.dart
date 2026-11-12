import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import '../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class AppLogoWidget extends StatelessWidget { // Durumsuz (Stateless) AppLogoWidget görsel bileşenini tanımlar
  final double size; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool showTitle; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool showSubtitle; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const AppLogoWidget({ // Sabit/final değişken veya nesne tanımını başlatır
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    this.size = 92, // size = 92 sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.showTitle = true, // showTitle = true sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.showSubtitle = true, // showSubtitle = true sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return Column( // Alt bileşenleri dikey eksende alt alta dizer
      mainAxisSize: MainAxisSize.min, // mainAxisSize özelliğini yapılandırır
      children: [ // İlgili kod satırını ve işlemi yürütür
        Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
          width: size, // width özelliğini yapılandırır
          height: size, // height özelliğini yapılandırır
          decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
            borderRadius: BorderRadius.circular(size * 0.24), // borderRadius özelliğini yapılandırır
            boxShadow: [ // İlgili kod satırını ve işlemi yürütür
              BoxShadow( // İlgili kod satırını ve işlemi yürütür
                color: AppColors.pitchGreen.withValues(alpha: 0.28), // color özelliğini yapılandırır
                blurRadius: 18, // blurRadius özelliğini yapılandırır
                offset: const Offset(0, 6), // offset özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
          clipBehavior: Clip.antiAlias, // clipBehavior özelliğini yapılandırır
          child: Image.asset( // İlgili kod satırını ve işlemi yürütür
            'assets/images/logo.png', // İlgili kod satırını ve işlemi yürütür
            fit: BoxFit.cover, // fit özelliğini yapılandırır
            errorBuilder: (context, error, stackTrace) { // errorBuilder özelliğini yapılandırır
              return Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                color: AppColors.primaryDarkGreen, // color özelliğini yapılandırır
                alignment: Alignment.center, // alignment özelliğini yapılandırır
                child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                  mainAxisAlignment: MainAxisAlignment.center, // mainAxisAlignment özelliğini yapılandırır
                  children: [ // İlgili kod satırını ve işlemi yürütür
                    Icon( // Ekranda vektörel ikon gösterir
                      Icons.sports_soccer, // İlgili kod satırını ve işlemi yürütür
                      color: AppColors.pitchLightGreen, // color özelliğini yapılandırır
                      size: size * 0.42, // size özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    Text( // Ekrana metin bileşeni yazdırır
                      '7v7', // İlgili kod satırını ve işlemi yürütür
                      style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                        color: Colors.white, // color özelliğini yapılandırır
                        fontWeight: FontWeight.w900, // fontWeight özelliğini yapılandırır
                        fontSize: size * 0.24, // fontSize özelliğini yapılandırır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ], // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ); // Açık olan kod/bileşen bloğunu kapatır
            }, // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
        if (showTitle) ...[ // Koşulun sağlanıp sağlanmadığını kontrol eder
          const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
          Text( // Ekrana metin bileşeni yazdırır
            '7v7', // İlgili kod satırını ve işlemi yürütür
            style: theme.textTheme.headlineMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
              fontWeight: FontWeight.w900, // fontWeight özelliğini yapılandırır
              letterSpacing: 1.2, // letterSpacing özelliğini yapılandırır
              color: theme.colorScheme.primary, // color özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ], // Açık olan kod/bileşen bloğunu kapatır
        if (showSubtitle) ...[ // Koşulun sağlanıp sağlanmadığını kontrol eder
          const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
          Text( // Ekrana metin bileşeni yazdırır
            '7\'ye 7 Halı Saha Maç Organizasyonu', // İlgili kod satırını ve işlemi yürütür
            textAlign: TextAlign.center, // textAlign özelliğini yapılandırır
            style: theme.textTheme.bodyMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
              color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
              fontWeight: FontWeight.w500, // fontWeight özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ], // Açık olan kod/bileşen bloğunu kapatır
      ], // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

