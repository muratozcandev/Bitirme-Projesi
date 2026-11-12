import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import '../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../models/formation.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class PlayerPositionButton extends StatelessWidget { // Durumsuz (Stateless) PlayerPositionButton görsel bileşenini tanımlar
  final PlayerPositionSlot slot; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String? playerName; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final bool isCaptain; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final VoidCallback onTap; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const PlayerPositionButton({ // Sabit/final değişken veya nesne tanımını başlatır
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.slot, // slot parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    this.playerName, // playerName sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    this.isCaptain = false, // isCaptain = false sınıf alanını yapıcı (constructor) parametresiyle eşleştirir
    required this.onTap, // onTap parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final hasPlayer = playerName != null && playerName!.trim().isNotEmpty; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final isGk = slot.line == PositionLine.goalkeeper; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    final Color jerseyColor; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    if (isCaptain) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      jerseyColor = AppColors.goldAccent; // İlgili kod satırını ve işlemi yürütür
    } else if (isGk) { // Önceki koşul sağlanmadıysa alternatif koşulu kontrol eder
      jerseyColor = const Color(0xFF0284C7); // İlgili kod satırını ve işlemi yürütür
    } else if (hasPlayer) { // Önceki koşul sağlanmadıysa alternatif koşulu kontrol eder
      jerseyColor = AppColors.pitchLightGreen; // İlgili kod satırını ve işlemi yürütür
    } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
      jerseyColor = Colors.white.withValues(alpha: 0.25); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    return Semantics( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
      button: true, // button özelliğini yapılandırır
      label: '${slot.label} ${hasPlayer ? playerName : "Boş"}', // label özelliğini yapılandırır
      child: InkWell( // İlgili kod satırını ve işlemi yürütür
        onTap: onTap, // onTap özelliğini yapılandırır
        borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
        child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
          constraints: const BoxConstraints(minWidth: 78, maxWidth: 102), // constraints özelliğini yapılandırır
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5), // padding özelliğini yapılandırır
          decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
            color: Colors.black.withValues(alpha: 0.48), // color özelliğini yapılandırır
            borderRadius: BorderRadius.circular(14), // borderRadius özelliğini yapılandırır
            border: Border.all( // İlgili kod satırını ve işlemi yürütür
              color: hasPlayer // İlgili kod satırını ve işlemi yürütür
                  ? (isCaptain ? AppColors.goldAccent : AppColors.pitchLightGreen) // İlgili kod satırını ve işlemi yürütür
                  : Colors.white.withValues(alpha: 0.55), //  özelliğini yapılandırır
              width: hasPlayer ? 1.8 : 1.1, // width özelliğini yapılandırır
            ), // Açık olan kod/bileşen bloğunu kapatır
            boxShadow: [ // İlgili kod satırını ve işlemi yürütür
              BoxShadow( // İlgili kod satırını ve işlemi yürütür
                color: Colors.black.withValues(alpha: 0.28), // color özelliğini yapılandırır
                blurRadius: 6, // blurRadius özelliğini yapılandırır
                offset: const Offset(0, 3), // offset özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
          child: Column( // Alt bileşenleri dikey eksende alt alta dizer
            mainAxisSize: MainAxisSize.min, // mainAxisSize özelliğini yapılandırır
            children: [ // İlgili kod satırını ve işlemi yürütür
              Stack( // Alt bileşenleri üst üste katmanlar halinde yerleştirir
                clipBehavior: Clip.none, // clipBehavior özelliğini yapılandırır
                alignment: Alignment.center, // alignment özelliğini yapılandırır
                children: [ // İlgili kod satırını ve işlemi yürütür
                  CircleAvatar( // İlgili kod satırını ve işlemi yürütür
                    radius: 15, // radius özelliğini yapılandırır
                    backgroundColor: jerseyColor, // backgroundColor özelliğini yapılandırır
                    child: Icon( // Ekranda vektörel ikon gösterir
                      hasPlayer ? Icons.person : Icons.add, // hasPlayer ? Icons.person özelliğini yapılandırır
                      size: 18, // size özelliğini yapılandırır
                      color: hasPlayer && (isCaptain || !isGk) // İlgili kod satırını ve işlemi yürütür
                          ? const Color(0xFF052E16) // İlgili kod satırını ve işlemi yürütür
                          : Colors.white, //  özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  if (isCaptain) // Koşulun sağlanıp sağlanmadığını kontrol eder
                    Positioned( // İlgili kod satırını ve işlemi yürütür
                      right: -5, // right özelliğini yapılandırır
                      top: -4, // top özelliğini yapılandırır
                      child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                        padding: const EdgeInsets.symmetric( // İlgili kod satırını ve işlemi yürütür
                            horizontal: 4, vertical: 1), // horizontal özelliğini yapılandırır
                        decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                          color: AppColors.primaryDarkGreen, // color özelliğini yapılandırır
                          borderRadius: BorderRadius.circular(6), // borderRadius özelliğini yapılandırır
                          border: Border.all( // İlgili kod satırını ve işlemi yürütür
                              color: AppColors.goldAccent, width: 1), // color özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                        child: const Text( // Ekrana metin bileşeni yazdırır
                          'K', // İlgili kod satırını ve işlemi yürütür
                          style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                            color: AppColors.goldAccent, // color özelliğini yapılandırır
                            fontSize: 9, // fontSize özelliğini yapılandırır
                            fontWeight: FontWeight.w900, // fontWeight özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                ], // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
              const SizedBox(height: 3), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
              Text( // Ekrana metin bileşeni yazdırır
                slot.label, // İlgili kod satırını ve işlemi yürütür
                maxLines: 1, // maxLines özelliğini yapılandırır
                overflow: TextOverflow.ellipsis, // overflow özelliğini yapılandırır
                style: const TextStyle( // İlgili kod satırını ve işlemi yürütür
                  color: Color(0xFFD1FAE5), // color özelliğini yapılandırır
                  fontSize: 10, // fontSize özelliğini yapılandırır
                  fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
              Text( // Ekrana metin bileşeni yazdırır
                hasPlayer ? playerName! : 'Boş', // hasPlayer ? playerName! özelliğini yapılandırır
                maxLines: 1, // maxLines özelliğini yapılandırır
                overflow: TextOverflow.ellipsis, // overflow özelliğini yapılandırır
                style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                  color: hasPlayer ? Colors.white : Colors.white70, // color özelliğini yapılandırır
                  fontSize: 11, // fontSize özelliğini yapılandırır
                  fontWeight: hasPlayer ? FontWeight.w800 : FontWeight.w400, // fontWeight özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ], // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

