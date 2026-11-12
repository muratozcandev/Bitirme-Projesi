import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import 'package:go_router/go_router.dart'; // GoRouter sayfa yönlendirme paketini içe aktarır
import '../../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/appointment_card.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/notification_icon.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/state_widgets.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class AppointmentsScreen extends ConsumerWidget { // Riverpod sağlayıcılarını dinleyebilen AppointmentsScreen görsel bileşenini tanımlar
  const AppointmentsScreen({super.key}); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context, WidgetRef ref) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final appointmentsAsync = ref.watch(userAppointmentsProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer

    return Scaffold( // Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur
      appBar: AppBar( // Ekranın üst başlık çubuğunu (AppBar) oluşturur
        title: const Text('Randevularım'), // Ekrana metin bileşeni yazdırır
        actions: const [ // İlgili kod satırını ve işlemi yürütür
          NotificationIcon(), // Ekranda vektörel ikon gösterir
          SizedBox(width: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
      body: SafeArea( // İçeriği telefonun çentik ve sistem çubuğu alanlarından korur
        child: appointmentsAsync.when( // İlgili kod satırını ve işlemi yürütür
          loading: () => // İlgili kod satırını ve işlemi yürütür
              const LoadingWidget(message: 'Randevularınız yükleniyor...'), // Sabit/final değişken veya nesne tanımını başlatır
          error: (err, _) => AppErrorWidget( // İlgili kod satırını ve işlemi yürütür
            message: err.toString(), // message özelliğini yapılandırır
            onRetry: () => triggerGlobalRefresh(ref), // onRetry özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
          data: (appointments) { // data özelliğini yapılandırır
            if (appointments.isEmpty || user == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
              return EmptyStateWidget( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                icon: Icons.event_busy_rounded, // icon özelliğini yapılandırır
                title: 'Henüz Maç Randevunuz Yok', // title özelliğini yapılandırır
                subtitle: // İlgili kod satırını ve işlemi yürütür
                    'Takım Kur sekmesinden yeni bir 7v7 maç organizasyonu oluşturabilir veya size gelen takım davetlerini kabul edebilirsiniz.', // İlgili kod satırını ve işlemi yürütür
                action: ElevatedButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
                  onPressed: () => context.go('/team-creation'), // Belirtilen rotaya doğrudan geçiş yapar (navigasyon geçmişini sıfırlar)
                  icon: const Icon(Icons.add_circle_outline), // Ekranda vektörel ikon gösterir
                  label: const Text('Yeni Takım Kur'), // Ekrana metin bileşeni yazdırır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ); // Açık olan kod/bileşen bloğunu kapatır
            } // Açık olan kod/bileşen bloğunu kapatır

            return RefreshIndicator( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
              onRefresh: () async => triggerGlobalRefresh(ref), // onRefresh özelliğini yapılandırır
              child: ListView.builder( // Kaydırılabilir liste görünümü oluşturur
                padding: // İlgili kod satırını ve işlemi yürütür
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Sabit/final değişken veya nesne tanımını başlatır
                itemCount: appointments.length, // itemCount özelliğini yapılandırır
                itemBuilder: (context, index) { // itemBuilder özelliğini yapılandırır
                  final team = appointments[index]; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                  return AppointmentCard( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                    key: Key('appointment_card_${team.id}'), // key özelliğini yapılandırır
                    team: team, // team özelliğini yapılandırır
                    currentUserId: user.id, // currentUserId özelliğini yapılandırır
                    onDeleteConfirmed: () async { // onDeleteConfirmed özelliğini yapılandırır
                      await ref // Asenkron işlemin tamamlanmasını bekler
                          .read(teamRepositoryProvider) // İlgili kod satırını ve işlemi yürütür
                          .deleteAppointmentForUser( // İlgili kod satırını ve işlemi yürütür
                            teamId: team.id, // teamId özelliğini yapılandırır
                            userId: user.id, // userId özelliğini yapılandırır
                          ); // Açık olan kod/bileşen bloğunu kapatır
                      triggerGlobalRefresh(ref); // İlgili kod satırını ve işlemi yürütür
                      if (context.mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                        ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
                          const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
                            content: // İlgili kod satırını ve işlemi yürütür
                                Text('Randevu listenizden başarıyla silindi.'), // Ekrana metin bileşeni yazdırır
                            backgroundColor: AppColors.success, // backgroundColor özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ); // Açık olan kod/bileşen bloğunu kapatır
                      } // Açık olan kod/bileşen bloğunu kapatır
                    }, // Açık olan kod/bileşen bloğunu kapatır
                  ); // Açık olan kod/bileşen bloğunu kapatır
                }, // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ); // Açık olan kod/bileşen bloğunu kapatır
          }, // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

