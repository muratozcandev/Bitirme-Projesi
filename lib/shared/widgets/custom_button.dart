import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır

class CustomButton extends StatelessWidget { // Durumsuz (Stateless) CustomButton görsel bileşenini tanımlar
  final String label; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final VoidCallback? onPressed; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool isLoading; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final IconData? icon; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool isOutlined; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Color? backgroundColor; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final Color? foregroundColor; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const CustomButton({ // Tıklanabilir aksiyon butonunu oluşturur
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.label, // label parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.onPressed, // onPressed parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.isLoading = false, // isLoading = false sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.icon, // icon sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.isOutlined = false, // isOutlined = false sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.backgroundColor, // backgroundColor sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.foregroundColor, // foregroundColor sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final child = isLoading // Sabit/final değişken veya nesne tanımını başlatır
        ? const SizedBox( // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            width: 22, // width özelliğini yapılandırır
            height: 22, // height özelliğini yapılandırır
            child: CircularProgressIndicator( // İşlem devam ederken dönen yükleme göstergesi çizer
              strokeWidth: 2.5, // strokeWidth özelliğini yapılandırır
              color: Colors.white, // color özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ) // İlgili kod satırını ve işlemi yürütür
        : Row( // Alt bileşenleri yatay eksende yan yana dizer
            mainAxisSize: MainAxisSize.min, // mainAxisSize özelliğini yapılandırır
            mainAxisAlignment: MainAxisAlignment.center, // mainAxisAlignment özelliğini yapılandırır
            children: [ // İlgili kod satırını ve işlemi yürütür
              if (icon != null) ...[ // Koşulun sağlanıp sağlanmadığını kontrol eder
                Icon(icon, size: 20), // Ekranda vektörel ikon gösterir
                const SizedBox(width: 8), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
              ], // Açık olan kod/bileşen bloğunu kapatır
              Flexible( // İçeriğin taşmasını önlemek için esnek boyutlandırma sağlar
                child: Text( // Ekrana metin bileşeni yazdırır
                  label, // İlgili kod satırını ve işlemi yürütür
                  overflow: TextOverflow.ellipsis, // overflow özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ); // Açık olan kod/bileşen bloğunu kapatır

    if (isOutlined) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return SizedBox( // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
        width: double.infinity, // width özelliğini yapılandırır
        child: OutlinedButton( // Tıklanabilir aksiyon butonunu oluşturur
          onPressed: isLoading ? null : onPressed, // onPressed özelliğini yapılandırır
          child: child, // child özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    return SizedBox( // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
      width: double.infinity, // width özelliğini yapılandırır
      child: ElevatedButton( // Tıklanabilir aksiyon butonunu oluşturur
        style: backgroundColor != null || foregroundColor != null // İlgili kod satırını ve işlemi yürütür
            ? ElevatedButton.styleFrom( // Tıklanabilir aksiyon butonunu oluşturur
                backgroundColor: backgroundColor, // backgroundColor özelliğini yapılandırır
                foregroundColor: foregroundColor, // foregroundColor özelliğini yapılandırır
              ) // İlgili kod satırını ve işlemi yürütür
            : null, //  özelliğini yapılandırır
        onPressed: isLoading ? null : onPressed, // onPressed özelliğini yapılandırır
        child: child, // child özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

