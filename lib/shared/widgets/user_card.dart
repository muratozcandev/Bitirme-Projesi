import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import '../models/user_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class UserCard extends StatelessWidget { // Durumsuz (Stateless) UserCard görsel bileşenini tanımlar
  final UserModel player; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final VoidCallback onInvitePressed; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const UserCard({ // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
    super.key, // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
    required this.player, // player parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.onInvitePressed, // onInvitePressed parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
      child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12), // padding özelliğini yapılandırır
        child: Row( // Alt bileşenleri yatay eksende yan yana dizer
          children: [ // İlgili kod satırını ve işlemi yürütür
            CircleAvatar( // İlgili kod satırını ve işlemi yürütür
              radius: 24, // radius özelliğini yapılandırır
              backgroundColor: theme.colorScheme.primary, // backgroundColor özelliğini yapılandırır
              child: Text( // Ekrana metin bileşeni yazdırır
                player.initials, // İlgili kod satırını ve işlemi yürütür
                style: const TextStyle( // İlgili kod satırını ve işlemi yürütür
                  color: Colors.white, // color özelliğini yapılandırır
                  fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                  fontSize: 16, // fontSize özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(width: 14), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
              child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                crossAxisAlignment: CrossAxisAlignment.start, // crossAxisAlignment özelliğini yapılandırır
                children: [ // İlgili kod satırını ve işlemi yürütür
                  Text( // Ekrana metin bileşeni yazdırır
                    player.fullName, // İlgili kod satırını ve işlemi yürütür
                    style: theme.textTheme.titleMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                      fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(height: 3), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                  Text( // Ekrana metin bileşeni yazdırır
                    player.email, // İlgili kod satırını ve işlemi yürütür
                    style: theme.textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
                      color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ], // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
            const SizedBox(width: 8), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
            ElevatedButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
              key: Key('invite_player_btn_${player.id}'), // key özelliğini yapılandırır
              onPressed: onInvitePressed, // onPressed özelliğini yapılandırır
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18), // Ekranda vektörel ikon gösterir
              label: const Text('Davet Yolla'), // Ekrana metin bileşeni yazdırır
              style: ElevatedButton.styleFrom( // Tıklanabilir aksiyon butonunu oluşturur
                padding: // İlgili kod satırını ve işlemi yürütür
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10), // Sabit/final değişken veya nesne tanımını başlatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ], // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

