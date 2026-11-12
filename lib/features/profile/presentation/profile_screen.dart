import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import 'package:go_router/go_router.dart'; // GoRouter sayfa yönlendirme paketini içe aktarır
import '../../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/notification_icon.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class ProfileScreen extends ConsumerWidget { // Riverpod sağlayıcılarını dinleyebilen ProfileScreen görsel bileşenini tanımlar
  const ProfileScreen({super.key}); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context, WidgetRef ref) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final user = ref.watch(authProvider).user; // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    final isDark = user?.themeMode == 'dark'; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    if (user == null) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      return const Scaffold( // Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur
        body: Center(child: CircularProgressIndicator()), // İçindeki bileşeni yatay ve dikey olarak ortalar
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır

    return Scaffold( // Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur
      appBar: AppBar( // Ekranın üst başlık çubuğunu (AppBar) oluşturur
        title: const Text('Profil'), // Ekrana metin bileşeni yazdırır
        actions: const [ // İlgili kod satırını ve işlemi yürütür
          NotificationIcon(), // Ekranda vektörel ikon gösterir
          SizedBox(width: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
      body: SafeArea( // İçeriği telefonun çentik ve sistem çubuğu alanlarından korur
        child: SingleChildScrollView( // İçeriğin ekrana sığmadığında dikey/yatay kaydırılabilmesini sağlar
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16), // padding özelliğini yapılandırır
          child: Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
            child: ConstrainedBox( // İlgili kod satırını ve işlemi yürütür
              constraints: const BoxConstraints(maxWidth: 520), // constraints özelliğini yapılandırır
              child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
                children: [ // İlgili kod satırını ve işlemi yürütür
                  // Profil Üst Kartı
                  Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                    child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
                      padding: const EdgeInsets.all(20), // padding özelliğini yapılandırır
                      child: Row( // Alt bileşenleri yatay eksende yan yana dizer
                        children: [ // İlgili kod satırını ve işlemi yürütür
                          CircleAvatar( // İlgili kod satırını ve işlemi yürütür
                            radius: 34, // radius özelliğini yapılandırır
                            backgroundColor: theme.colorScheme.primary, // backgroundColor özelliğini yapılandırır
                            child: Text( // Ekrana metin bileşeni yazdırır
                              user.initials, // İlgili kod satırını ve işlemi yürütür
                              style: const TextStyle( // İlgili kod satırını ve işlemi yürütür
                                color: Colors.white, // color özelliğini yapılandırır
                                fontSize: 22, // fontSize özelliğini yapılandırır
                                fontWeight: FontWeight.w900, // fontWeight özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          const SizedBox(width: 16), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                          Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                            child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                              crossAxisAlignment: CrossAxisAlignment.start, // crossAxisAlignment özelliğini yapılandırır
                              children: [ // İlgili kod satırını ve işlemi yürütür
                                Text( // Ekrana metin bileşeni yazdırır
                                  user.fullName, // İlgili kod satırını ve işlemi yürütür
                                  style: theme.textTheme.titleLarge?.copyWith( // İlgili kod satırını ve işlemi yürütür
                                    fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                                  ), // Açık olan kod/bileşen bloğunu kapatır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                                const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                                Text( // Ekrana metin bileşeni yazdırır
                                  user.email, // İlgili kod satırını ve işlemi yürütür
                                  style: theme.textTheme.bodyMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                                    color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
                                  ), // Açık olan kod/bileşen bloğunu kapatır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                              ], // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ], // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur

                  // Kayıt Sırasında Girilen Kişisel Bilgiler
                  Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                    child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
                      padding: const EdgeInsets.all(16), // padding özelliğini yapılandırır
                      child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                        crossAxisAlignment: CrossAxisAlignment.start, // crossAxisAlignment özelliğini yapılandırır
                        children: [ // İlgili kod satırını ve işlemi yürütür
                          Text( // Ekrana metin bileşeni yazdırır
                            'Kişisel Bilgiler', // İlgili kod satırını ve işlemi yürütür
                            style: theme.textTheme.titleMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                              fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                          _ProfileDetailTile( // İlgili kod satırını ve işlemi yürütür
                            icon: Icons.person_outline_rounded, // icon özelliğini yapılandırır
                            label: 'Ad', // label özelliğini yapılandırır
                            value: user.firstName, // value özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          const Divider(), // Sabit/final değişken veya nesne tanımını başlatır
                          _ProfileDetailTile( // İlgili kod satırını ve işlemi yürütür
                            icon: Icons.badge_outlined, // icon özelliğini yapılandırır
                            label: 'Soyad', // label özelliğini yapılandırır
                            value: user.lastName, // value özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          const Divider(), // Sabit/final değişken veya nesne tanımını başlatır
                          _ProfileDetailTile( // İlgili kod satırını ve işlemi yürütür
                            icon: Icons.email_outlined, // icon özelliğini yapılandırır
                            label: 'E-posta', // label özelliğini yapılandırır
                            value: user.email, // value özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          const Divider(), // Sabit/final değişken veya nesne tanımını başlatır
                          _ProfileDetailTile( // İlgili kod satırını ve işlemi yürütür
                            icon: Icons.phone_android_outlined, // icon özelliğini yapılandırır
                            label: 'Telefon Numarası', // label özelliğini yapılandırır
                            value: user.phone, // value özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ], // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur

                  // Tema Ayarları (Light Mode / Dark Mode)
                  Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                    child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
                      padding: const EdgeInsets.all(16), // padding özelliğini yapılandırır
                      child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                        crossAxisAlignment: CrossAxisAlignment.start, // crossAxisAlignment özelliğini yapılandırır
                        children: [ // İlgili kod satırını ve işlemi yürütür
                          Text( // Ekrana metin bileşeni yazdırır
                            'Görünüm ve Tema Ayarları', // İlgili kod satırını ve işlemi yürütür
                            style: theme.textTheme.titleMedium?.copyWith( // İlgili kod satırını ve işlemi yürütür
                              fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                          const SizedBox(height: 8), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                          SwitchListTile( // İlgili kod satırını ve işlemi yürütür
                            key: const Key('profile_theme_switch'), // key özelliğini yapılandırır
                            contentPadding: EdgeInsets.zero, // contentPadding özelliğini yapılandırır
                            secondary: CircleAvatar( // İlgili kod satırını ve işlemi yürütür
                              backgroundColor: // İlgili kod satırını ve işlemi yürütür
                                  theme.colorScheme.primaryContainer, // İlgili kod satırını ve işlemi yürütür
                              child: Icon( // Ekranda vektörel ikon gösterir
                                isDark // İlgili kod satırını ve işlemi yürütür
                                    ? Icons.dark_mode_rounded // İlgili kod satırını ve işlemi yürütür
                                    : Icons.light_mode_rounded, //  özelliğini yapılandırır
                                color: theme.colorScheme.onPrimaryContainer, // color özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            title: Text( // Ekrana metin bileşeni yazdırır
                              isDark // İlgili kod satırını ve işlemi yürütür
                                  ? 'Koyu Tema (Dark Mode)' // İlgili kod satırını ve işlemi yürütür
                                  : 'Açık Tema (Light Mode)', //  özelliğini yapılandırır
                              style: const TextStyle( // İlgili kod satırını ve işlemi yürütür
                                fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            subtitle: const Text( // Ekrana metin bileşeni yazdırır
                              'Tema tercihiniz hesabınıza özel olarak kaydedilir.', // İlgili kod satırını ve işlemi yürütür
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            value: isDark, // value özelliğini yapılandırır
                            onChanged: (value) { // onChanged özelliğini yapılandırır
                              ref // İlgili kod satırını ve işlemi yürütür
                                  .read(authProvider.notifier) // İlgili kod satırını ve işlemi yürütür
                                  .toggleThemeMode(value); // İlgili kod satırını ve işlemi yürütür
                            }, // Açık olan kod/bileşen bloğunu kapatır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ], // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                  const SizedBox(height: 18), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur

                  // Çıkış Yap Butonu
                  OutlinedButton.icon( // Tıklanabilir aksiyon butonunu oluşturur
                    key: const Key('profile_logout_button'), // key özelliğini yapılandırır
                    style: OutlinedButton.styleFrom( // Tıklanabilir aksiyon butonunu oluşturur
                      foregroundColor: AppColors.error, // foregroundColor özelliğini yapılandırır
                      side: const BorderSide(color: AppColors.error, width: 1.5), // side özelliğini yapılandırır
                      padding: const EdgeInsets.symmetric(vertical: 14), // padding özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    onPressed: () async { // onPressed özelliğini yapılandırır
                      await ref.read(authProvider.notifier).logout(); // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
                      if (context.mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                        context.go('/login'); // Belirtilen rotaya doğrudan geçiş yapar (navigasyon geçmişini sıfırlar)
                      } // Açık olan kod/bileşen bloğunu kapatır
                    }, // Açık olan kod/bileşen bloğunu kapatır
                    icon: const Icon(Icons.logout_rounded), // Ekranda vektörel ikon gösterir
                    label: const Text( // Ekrana metin bileşeni yazdırır
                      'Hesaptan Çıkış Yap', // İlgili kod satırını ve işlemi yürütür
                      style: TextStyle(fontWeight: FontWeight.w800), // style özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ], // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

class _ProfileDetailTile extends StatelessWidget { // Durumsuz (Stateless) _ProfileDetailTile görsel bileşenini tanımlar
  final IconData icon; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String label; // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final String value; // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  const _ProfileDetailTile({ // Sabit/final değişken veya nesne tanımını başlatır
    required this.icon, // icon parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.label, // label parametresinin dışarıdan zorunlu olarak verilmesini sağlar
    required this.value, // value parametresinin dışarıdan zorunlu olarak verilmesini sağlar
  }); // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
    return Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
      padding: const EdgeInsets.symmetric(vertical: 6), // padding özelliğini yapılandırır
      child: Row( // Alt bileşenleri yatay eksende yan yana dizer
        children: [ // İlgili kod satırını ve işlemi yürütür
          Icon(icon, color: theme.colorScheme.primary, size: 22), // Ekranda vektörel ikon gösterir
          const SizedBox(width: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
          Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
            child: Column( // Alt bileşenleri dikey eksende alt alta dizer
              crossAxisAlignment: CrossAxisAlignment.start, // crossAxisAlignment özelliğini yapılandırır
              children: [ // İlgili kod satırını ve işlemi yürütür
                Text( // Ekrana metin bileşeni yazdırır
                  label, // İlgili kod satırını ve işlemi yürütür
                  style: theme.textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
                    color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
                    fontWeight: FontWeight.w600, // fontWeight özelliğini yapılandırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
                const SizedBox(height: 2), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                Text( // Ekrana metin bileşeni yazdırır
                  value, // İlgili kod satırını ve işlemi yürütür
                  style: theme.textTheme.bodyLarge?.copyWith( // İlgili kod satırını ve işlemi yürütür
                    fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                  ), // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ], // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ], // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır

