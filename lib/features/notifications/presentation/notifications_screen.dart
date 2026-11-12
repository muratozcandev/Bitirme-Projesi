import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import '../../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/models/notification_model.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/invitation_card.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/state_widgets.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class NotificationsScreen extends ConsumerWidget { // Riverpod sağlayıcılarını dinleyebilen NotificationsScreen görsel bileşenini tanımlar
  const NotificationsScreen({super.key}); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  Future<void> _handleAcceptInvitation( // İlgili kod satırını ve işlemi yürütür
    BuildContext context, // İlgili kod satırını ve işlemi yürütür
    WidgetRef ref, // İlgili kod satırını ve işlemi yürütür
    String invitationId, // İlgili kod satırını ve işlemi yürütür
  ) async { // İlgili kod satırını ve işlemi yürütür
    final user = ref.read(authProvider).user; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    if (user == null) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
    try { // Hata yakalama (try) bloğunu başlatır
      await ref.read(invitationRepositoryProvider).acceptInvitation( // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
            invitationId: invitationId, // invitationId özelliğini yapılandırır
            currentUserId: user.id, // currentUserId özelliğini yapılandırır
          ); // Açık olan kod/bileşen bloğunu kapatır
      triggerGlobalRefresh(ref); // İlgili kod satırını ve işlemi yürütür
      if (context.mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
            content: Text( // Ekrana metin bileşeni yazdırır
              'Daveti kabul ettiniz! Maç randevularınıza eklendi ve takım sohbetine erişiminiz açıldı.', // İlgili kod satırını ve işlemi yürütür
            ), // Açık olan kod/bileşen bloğunu kapatır
            backgroundColor: AppColors.success, // backgroundColor özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
    } catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      if (context.mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
            content: Text(e.toString()), // Ekrana metin bileşeni yazdırır
            backgroundColor: AppColors.error, // backgroundColor özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleRejectInvitation( // İlgili kod satırını ve işlemi yürütür
    BuildContext context, // İlgili kod satırını ve işlemi yürütür
    WidgetRef ref, // İlgili kod satırını ve işlemi yürütür
    String invitationId, // İlgili kod satırını ve işlemi yürütür
  ) async { // İlgili kod satırını ve işlemi yürütür
    final user = ref.read(authProvider).user; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
    if (user == null) return; // Koşulun sağlanıp sağlanmadığını kontrol eder
    try { // Hata yakalama (try) bloğunu başlatır
      await ref.read(invitationRepositoryProvider).rejectInvitation( // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
            invitationId: invitationId, // invitationId özelliğini yapılandırır
            currentUserId: user.id, // currentUserId özelliğini yapılandırır
          ); // Açık olan kod/bileşen bloğunu kapatır
      triggerGlobalRefresh(ref); // İlgili kod satırını ve işlemi yürütür
      if (context.mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
            content: Text('Davet reddedildi.'), // Ekrana metin bileşeni yazdırır
            backgroundColor: AppColors.info, // backgroundColor özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
    } catch (e) { // Oluşan hatayı yakalayıp işleyen (catch) bloğu başlatır
      if (context.mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
            content: Text(e.toString()), // Ekrana metin bileşeni yazdırır
            backgroundColor: AppColors.error, // backgroundColor özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ); // Açık olan kod/bileşen bloğunu kapatır
      } // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context, WidgetRef ref) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final invitationsAsync = ref.watch(incomingInvitationsProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final notificationsAsync = ref.watch(userNotificationsProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    return Scaffold( // Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur
      appBar: AppBar( // Ekranın üst başlık çubuğunu (AppBar) oluşturur
        title: const Text('Bildirimler ve Davetler'), // Ekrana metin bileşeni yazdırır
        actions: [ // İlgili kod satırını ve işlemi yürütür
          if (user != null) // Koşulun sağlanıp sağlanmadığını kontrol eder
            TextButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
              key: const Key('mark_all_notifications_read_btn'), // key özelliğini yapılandırır
              onPressed: () async { // onPressed özelliğini yapılandırır
                await ref // Asenkron işlemin tamamlanmasını bekler
                    .read(notificationRepositoryProvider) // İlgili kod satırını ve işlemi yürütür
                    .markAllAsRead(user.id); // İlgili kod satırını ve işlemi yürütür
                triggerGlobalRefresh(ref); // İlgili kod satırını ve işlemi yürütür
              }, // Açık olan kod/bileşen bloğunu kapatır
              icon: const Icon( // Ekranda vektörel ikon gösterir
                Icons.done_all_rounded, // İlgili kod satırını ve işlemi yürütür
                color: Colors.white, // color özelliğini yapılandırır
                size: 18, // size özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
              label: const Text( // Ekrana metin bileşeni yazdırır
                'Tümünü Okundu İşaretle', // İlgili kod satırını ve işlemi yürütür
                style: TextStyle(color: Colors.white, fontSize: 12), // style özelliğini yapılandırır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
      body: SafeArea( // İçeriği telefonun çentik ve sistem çubuğu alanlarından korur
        child: invitationsAsync.when( // İlgili kod satırını ve işlemi yürütür
          loading: () => // İlgili kod satırını ve işlemi yürütür
              const LoadingWidget(message: 'Bildirimler yükleniyor...'), // Sabit/final değişken veya nesne tanımını başlatır
          error: (err, _) => AppErrorWidget( // İlgili kod satırını ve işlemi yürütür
            message: err.toString(), // message özelliğini yapılandırır
            onRetry: () => triggerGlobalRefresh(ref), // onRetry özelliğini yapılandırır
          ), // Açık olan kod/bileşen bloğunu kapatır
          data: (invitations) { // data özelliğini yapılandırır
            return notificationsAsync.when( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
              loading: () => const LoadingWidget(), // loading özelliğini yapılandırır
              error: (err, _) => AppErrorWidget(message: err.toString()), // error özelliğini yapılandırır
              data: (notifications) { // data özelliğini yapılandırır
                // "Tümünü Okundu İşaretle" butonuna tıklanmadığı sürece bildirim kayıtları görünür kalır;
                // tıklandığında yalnızca bu bölüm gizlenir, "Gelen Takım Davetleri" ise her zaman kalır.
                final visibleNotifications = // Sabit/final değişken veya nesne tanımını başlatır
                    notifications.where((n) => !n.isRead).toList(); // İlgili kod satırını ve işlemi yürütür

                if (invitations.isEmpty && visibleNotifications.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                  return const EmptyStateWidget( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                    icon: Icons.notifications_off_outlined, // icon özelliğini yapılandırır
                    title: 'Henüz Bildiriminiz Yok', // title özelliğini yapılandırır
                    subtitle: // İlgili kod satırını ve işlemi yürütür
                        'Size gelen takım davetleri ve davet yanıt bildirimleri burada görüntülenecektir.', // İlgili kod satırını ve işlemi yürütür
                  ); // Açık olan kod/bileşen bloğunu kapatır
                } // Açık olan kod/bileşen bloğunu kapatır

                return RefreshIndicator( // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                  onRefresh: () async => triggerGlobalRefresh(ref), // onRefresh özelliğini yapılandırır
                  child: ListView( // Kaydırılabilir liste görünümü oluşturur
                    padding: const EdgeInsets.all(16), // padding özelliğini yapılandırır
                    children: [ // İlgili kod satırını ve işlemi yürütür
                      if (invitations.isNotEmpty) ...[ // Koşulun sağlanıp sağlanmadığını kontrol eder
                        Text( // Ekrana metin bileşeni yazdırır
                          'Gelen Takım Davetleri (${invitations.length})', // İlgili kod satırını ve işlemi yürütür
                          style: theme.textTheme.titleMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                            fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                        const SizedBox(height: 8), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                        ...invitations.map( // İlgili kod satırını ve işlemi yürütür
                          (inv) => InvitationCard( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                            key: Key('incoming_invitation_${inv.id}'), // key özelliğini yapılandırır
                            invitation: inv, // invitation özelliğini yapılandırır
                            onAccept: inv.isPending // İlgili kod satırını ve işlemi yürütür
                                ? () => // İlgili kod satırını ve işlemi yürütür
                                    _handleAcceptInvitation(context, ref, inv.id) // İlgili kod satırını ve işlemi yürütür
                                : null, //  özelliğini yapılandırır
                            onReject: inv.isPending // İlgili kod satırını ve işlemi yürütür
                                ? () => // İlgili kod satırını ve işlemi yürütür
                                    _handleRejectInvitation(context, ref, inv.id) // İlgili kod satırını ve işlemi yürütür
                                : null, //  özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                        const SizedBox(height: 16), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                      ], // Açık olan kod/bileşen bloğunu kapatır
                      if (visibleNotifications.isNotEmpty) ...[ // Koşulun sağlanıp sağlanmadığını kontrol eder
                        Text( // Ekrana metin bileşeni yazdırır
                          'Tüm Bildirim Kayıtları (${visibleNotifications.length})', // İlgili kod satırını ve işlemi yürütür
                          style: theme.textTheme.titleMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                            fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                        const SizedBox(height: 8), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                        ...visibleNotifications.map((n) { // İlgili kod satırını ve işlemi yürütür
                          final IconData icon; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                          final Color iconColor; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                          switch (n.type) { // Değere göre çoklu durum kontrolü (switch) başlatır
                            case NotificationType.teamInvitation: // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
                              icon = Icons.mail_outline_rounded; // İlgili kod satırını ve işlemi yürütür
                              iconColor = AppColors.info; // İlgili kod satırını ve işlemi yürütür
                            case NotificationType.invitationAccepted: // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
                              icon = Icons.check_circle_outline_rounded; // İlgili kod satırını ve işlemi yürütür
                              iconColor = AppColors.success; // İlgili kod satırını ve işlemi yürütür
                            case NotificationType.invitationRejected: // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
                              icon = Icons.cancel_outlined; // İlgili kod satırını ve işlemi yürütür
                              iconColor = AppColors.error; // İlgili kod satırını ve işlemi yürütür
                            case NotificationType.teamInfo: // Belirtilen durum eşleştiğinde çalışacak dalı tanımlar
                              icon = Icons.info_outline_rounded; // İlgili kod satırını ve işlemi yürütür
                              iconColor = theme.colorScheme.primary; // İlgili kod satırını ve işlemi yürütür
                          } // Açık olan kod/bileşen bloğunu kapatır

                          return Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                            child: ListTile( // İlgili kod satırını ve işlemi yürütür
                              leading: CircleAvatar( // İlgili kod satırını ve işlemi yürütür
                                backgroundColor: // İlgili kod satırını ve işlemi yürütür
                                    iconColor.withValues(alpha: 0.15), // iconColor.withValues(alpha özelliğini yapılandırır
                                child: Icon(icon, color: iconColor), // Ekranda vektörel ikon gösterir
                              ), // Açık olan kod/bileşen bloğunu kapatır
                              title: Text( // Ekrana metin bileşeni yazdırır
                                n.title, // İlgili kod satırını ve işlemi yürütür
                                style: const TextStyle( // İlgili kod satırını ve işlemi yürütür
                                  fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                              subtitle: Column( // Alt bileşenleri dikey eksende alt alta dizer
                                crossAxisAlignment: CrossAxisAlignment.start, // crossAxisAlignment özelliğini yapılandırır
                                children: [ // İlgili kod satırını ve işlemi yürütür
                                  const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                                  Text(n.body), // Ekrana metin bileşeni yazdırır
                                  const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                                  Text( // Ekrana metin bileşeni yazdırır
                                    _formatDateTime(n.createdAt), // İlgili kod satırını ve işlemi yürütür
                                    style: theme.textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
                                      fontSize: 11, // fontSize özelliğini yapılandırır
                                      color: // İlgili kod satırını ve işlemi yürütür
                                          theme.colorScheme.onSurfaceVariant, // İlgili kod satırını ve işlemi yürütür
                                    ), // Açık olan kod/bileşen bloğunu kapatır
                                  ), // Açık olan kod/bileşen bloğunu kapatır
                                ], // Açık olan kod/bileşen bloğunu kapatır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                              trailing: Container( // Boyut, dolgulu alan (padding) ve arka plan dekorasyonu sağlayan kutu oluşturur
                                width: 10, // width özelliğini yapılandırır
                                height: 10, // height özelliğini yapılandırır
                                decoration: const BoxDecoration( // İlgili kod satırını ve işlemi yürütür
                                  color: AppColors.pitchGreen, // color özelliğini yapılandırır
                                  shape: BoxShape.circle, // shape özelliğini yapılandırır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ); // Açık olan kod/bileşen bloğunu kapatır
                        }), // İlgili kod satırını ve işlemi yürütür
                      ], // Açık olan kod/bileşen bloğunu kapatır
                    ], // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ); // Açık olan kod/bileşen bloğunu kapatır
              }, // Açık olan kod/bileşen bloğunu kapatır
            ); // Açık olan kod/bileşen bloğunu kapatır
          }, // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  String _formatDateTime(DateTime dt) { // İlgili kod satırını ve işlemi yürütür
    final d = dt.day.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final m = dt.month.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final y = dt.year; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final h = dt.hour.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final min = dt.minute.toString().padLeft(2, '0'); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return '$d.$m.$y $h:$min'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

