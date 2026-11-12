import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import 'package:go_router/go_router.dart'; // GoRouter sayfa yönlendirme paketini içe aktarır
import '../providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class NotificationIcon extends ConsumerWidget { // Riverpod sağlayıcılarını dinleyebilen NotificationIcon görsel bileşenini tanımlar
  const NotificationIcon({super.key}); // Ekranda vektörel ikon gösterir

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context, WidgetRef ref) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final unreadAsync = ref.watch(unreadNotificationCountProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final unreadCount = unreadAsync.valueOrNull ?? 0; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    return IconButton( // Tıklanabilir aksiyon butonunu oluşturur
      tooltip: 'Bildirimler', // tooltip özelliğini yapılandırır
      onPressed: () { // onPressed özelliğini yapılandırır
        context.push('/notifications'); // Yeni ekranı mevcut ekranın üzerine açar (geri dönülebilir)
      }, // Açık olan kod/bileşen bloğunu kapatır
      icon: Stack( // Alt bileşenleri üst üste katmanlar halinde yerleştirir
        clipBehavior: Clip.none, // clipBehavior özelliğini yapılandırır
        children: [ // İlgili kod satırını ve işlemi yürütür
          const Icon(Icons.notifications_outlined, size: 26), // Ekranda vektörel ikon gösterir
          if (unreadCount > 0) // Koşulun sağlanıp sağlanmadığını kontrol eder
            Positioned( // İlgili kod satırını ve işlemi yürütür
              right: -4, // right özelliğini yapılandırır
              top: -4, // top özelliğini yapılandırır
              child: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5), // padding özelliğini yapılandırır
                decoration: BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                  color: const Color(0xFFEF4444), // color özelliğini yapılandırır
                  borderRadius: BorderRadius.circular(10), // borderRadius özelliğini yapılandırır
                  border: Border.all(color: Colors.white, width: 1.4), // border özelliğini yapılandırır
                ), // Açık olan kod/bileşen bloğunu kapatır
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18), // constraints özelliğini yapılandırır
                alignment: Alignment.center, // alignment özelliğini yapılandırır
                child: Text( // Ekrana metin bileşeni yazdırır
                  unreadCount > 9 ? '9+' : '$unreadCount', // unreadCount > 9 ? '9+' özelliğini yapılandırır
                  style: const TextStyle( // İlgili kod satırını ve işlemi yürütür
                    color: Colors.white, // color özelliğini yapılandırır
                    fontSize: 10, // fontSize özelliğini yapılandırır
                    fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

