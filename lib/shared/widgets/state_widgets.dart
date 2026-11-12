import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır

class EmptyStateWidget extends StatelessWidget { // Durumsuz (Stateless) EmptyStateWidget görsel bileşenini tanımlar
  final IconData icon; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String title; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String subtitle; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Widget? action; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const EmptyStateWidget({ // Sabit/final değişken veya nesne tanımını başlatır
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.icon, // icon parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.title, // title parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.subtitle, // subtitle parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.action, // action sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
      child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
        padding: const EdgeInsets.all(28), // padding özelliğini yapılandırır
        child: Column( // Alt bileşenleri dikey eksende alt alta dizer
          mainAxisSize: MainAxisSize.min, // mainAxisSize özelliğini yapılandırır
          children: [ // İlgili kod satırını ve işlemi yürütür
            Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
              padding: const EdgeInsets.all(20), // padding özelliğini yapılandırır
              decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45), // color özelliğini yapılandırır
                shape: BoxShape.circle, // shape özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
              child: Icon( // Ekranda vektörel ikon gösterir
                icon, // İlgili kod satırını ve işlemi yürütür
                size: 44, // size özelliğini yapılandırır
                color: theme.colorScheme.primary, // color özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 16), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Text( // Ekrana metin bileşeni yazdırır
              title, // İlgili kod satırını ve işlemi yürütür
              textAlign: TextAlign.center, // textAlign özelliğini yapılandırır
              style: theme.textTheme.titleMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 8), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Text( // Ekrana metin bileşeni yazdırır
              subtitle, // İlgili kod satırını ve işlemi yürütür
              textAlign: TextAlign.center, // textAlign özelliğini yapılandırır
              style: theme.textTheme.bodyMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            if (action != null) ...[ // Koşulun sağlanıp sağlanmadığını kontrol eder
              const SizedBox(height: 18), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
              action!, // İlgili kod satırını ve işlemi yürütür
            ], // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class LoadingWidget extends StatelessWidget { // Durumsuz (Stateless) LoadingWidget görsel bileşenini tanımlar
  final String? message; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const LoadingWidget({super.key, this.message}); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    return Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
      child: Column( // Alt bileşenleri dikey eksende alt alta dizer
        mainAxisSize: MainAxisSize.min, // mainAxisSize özelliğini yapılandırır
        children: [ // İlgili kod satırını ve işlemi yürütür
          const CircularProgressIndicator(), // İşlem devam ederken dönen yükleme göstergesi çizer
          if (message != null) ...[ // Koşulun sağlanıp sağlanmadığını kontrol eder
            const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Text(message!), // Ekrana metin bileşeni yazdırır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class AppErrorWidget extends StatelessWidget { // Durumsuz (Stateless) AppErrorWidget görsel bileşenini tanımlar
  final String message; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final VoidCallback? onRetry; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const AppErrorWidget({ // Sabit/final değişken veya nesne tanımını başlatır
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.message, // message parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.onRetry, // onRetry sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
      child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
        padding: const EdgeInsets.all(24), // padding özelliğini yapılandırır
        child: Column( // Alt bileşenleri dikey eksende alt alta dizer
          mainAxisSize: MainAxisSize.min, // mainAxisSize özelliğini yapılandırır
          children: [ // İlgili kod satırını ve işlemi yürütür
            Icon( // Ekranda vektörel ikon gösterir
              Icons.error_outline_rounded, // İlgili kod satırını ve işlemi yürütür
              size: 48, // size özelliğini yapılandırır
              color: theme.colorScheme.error, // color özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Text( // Ekrana metin bileşeni yazdırır
              message, // İlgili kod satırını ve işlemi yürütür
              textAlign: TextAlign.center, // textAlign özelliğini yapılandırır
              style: theme.textTheme.bodyMedium, // style özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            if (onRetry != null) ...[ // Koşulun sağlanıp sağlanmadığını kontrol eder
              const SizedBox(height: 16), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
              OutlinedButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
                onPressed: onRetry, // onPressed özelliğini yapılandırır
                icon: const Icon(Icons.refresh), // Ekranda vektörel ikon gösterir
                label: const Text('Tekrar Dene'), // Ekrana metin bileşeni yazdırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

