import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import 'package:go_router/go_router.dart'; // GoRouter sayfa yönlendirme paketini içe aktarır
import '../../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../core/utils/validators.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/app_logo_widget.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/custom_button.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/custom_text_field.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class LoginScreen extends ConsumerStatefulWidget { // Riverpod destekli durum bilgili (Stateful) LoginScreen ekran bileşenini tanımlar
  const LoginScreen({super.key}); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  ConsumerState<LoginScreen> createState() => _LoginScreenState(); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

class _LoginScreenState extends ConsumerState<LoginScreen> { // _LoginScreenState ekranının Riverpod destekli durum (State) sınıfını tanımlar
  final _formKey = GlobalKey<FormState>(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final _identifierController = TextEditingController(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final _passwordController = TextEditingController(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  bool _obscurePassword = true; // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  void dispose() { // İlgili kod satırını ve işlemi yürütür
    _identifierController.dispose(); // Bellek sızıntısını önlemek için kontrolcüyü temizler
    _passwordController.dispose(); // Bellek sızıntısını önlemek için kontrolcüyü temizler
    super.dispose(); // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleLogin() async { // İlgili kod satırını ve işlemi yürütür
    if (!_formKey.currentState!.validate()) return; // Koşulun sağlanıp sağlanmadığını kontrol eder

    final success = await ref.read(authProvider.notifier).login( // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
          identifier: _identifierController.text, // identifier özelliğini yapılandırır
          password: _passwordController.text, // password özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır

    if (!mounted) return; // Koşulun sağlanıp sağlanmadığını kontrol eder

    if (success) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      triggerGlobalRefresh(ref); // İlgili kod satırını ve işlemi yürütür
      context.go('/team-creation'); // Belirtilen rotaya doğrudan geçiş yapar (navigasyon geçmişini sıfırlar)
    } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
      final error = ref.read(authProvider).error ?? 'Giriş yapılamadı.'; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: Text(error), // Ekrana metin bileşeni yazdırır
          backgroundColor: AppColors.error, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  Widget build(BuildContext context) { // Ekranın veya bileşenin görsel arayüz ağacını oluşturur
    final authState = ref.watch(authProvider); // İlgili Riverpod sağlayıcısını dinler ve değiştiğinde bileşeni yeniden çizer
    final theme = Theme.of(context); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

    return Scaffold( // Sayfanın temel iskeletini (üst çubuk, gövde, alt menü) oluşturur
      body: SafeArea( // İçeriği telefonun çentik ve sistem çubuğu alanlarından korur
        child: Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
          child: SingleChildScrollView( // İçeriğin ekrana sığmadığında dikey/yatay kaydırılabilmesini sağlar
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), // padding özelliğini yapılandırır
            child: ConstrainedBox( // İlgili kod satırını ve işlemi yürütür
              constraints: const BoxConstraints(maxWidth: 440), // constraints özelliğini yapılandırır
              child: Form( // İlgili kod satırını ve işlemi yürütür
                key: _formKey, // key özelliğini yapılandırır
                child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                  crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
                  children: [ // İlgili kod satırını ve işlemi yürütür
                    const AppLogoWidget( // Sabit/final değişken veya nesne tanımını başlatır
                      size: 96, // size özelliğini yapılandırır
                      showTitle: true, // showTitle özelliğini yapılandırır
                      showSubtitle: true, // showSubtitle özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    const SizedBox(height: 28), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                    Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                      child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
                        padding: const EdgeInsets.all(20), // padding özelliğini yapılandırır
                        child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                          crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
                          children: [ // İlgili kod satırını ve işlemi yürütür
                            Text( // Ekrana metin bileşeni yazdırır
                              'Giriş Yap', // İlgili kod satırını ve işlemi yürütür
                              style: theme.textTheme.titleLarge?.copyWith( // İlgili kod satırını ve işlemi yürütür
                                fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 6), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            Text( // Ekrana metin bileşeni yazdırır
                              'Kayıtlı e-posta adresiniz ve şifreniz ile giriş yapabilirsiniz.', // İlgili kod satırını ve işlemi yürütür
                              style: theme.textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
                                color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 18), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            CustomTextField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
                              key: const Key('login_identifier_field'), // key özelliğini yapılandırır
                              controller: _identifierController, // controller özelliğini yapılandırır
                              label: 'E-posta Adresi', // label özelliğini yapılandırır
                              hint: 'E-posta adresinizi giriniz', // hint özelliğini yapılandırır
                              prefixIcon: Icons.alternate_email_rounded, // prefixIcon özelliğini yapılandırır
                              keyboardType: TextInputType.emailAddress, // keyboardType özelliğini yapılandırır
                              textInputAction: TextInputAction.next, // textInputAction özelliğini yapılandırır
                              validator: (val) { // validator özelliğini yapılandırır
                                final trimmed = (val ?? '').trim(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
                                if (trimmed.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                                  return 'E-posta adresi boş bırakılamaz.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                                } // Açık olan kod/bileşen bloğunu kapatır
                                if (!trimmed.contains('@') || // Koşulun sağlanıp sağlanmadığını kontrol eder
                                    Validators.isPhone(trimmed)) { // İlgili kod satırını ve işlemi yürütür
                                  return 'Telefonla giriş geçici olarak devre dışıdır. Lütfen e-posta giriniz.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                                } // Açık olan kod/bileşen bloğunu kapatır
                                return Validators.validateEmail(trimmed); // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                              }, // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 14), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            CustomTextField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
                              key: const Key('login_password_field'), // key özelliğini yapılandırır
                              controller: _passwordController, // controller özelliğini yapılandırır
                              label: 'Şifre', // label özelliğini yapılandırır
                              hint: 'Şifrenizi giriniz', // hint özelliğini yapılandırır
                              prefixIcon: Icons.lock_outline_rounded, // prefixIcon özelliğini yapılandırır
                              obscureText: _obscurePassword, // obscureText özelliğini yapılandırır
                              textInputAction: TextInputAction.done, // textInputAction özelliğini yapılandırır
                              onFieldSubmitted: (_) => _handleLogin(), // onFieldSubmitted özelliğini yapılandırır
                              validator: (val) { // validator özelliğini yapılandırır
                                if (val == null || val.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                                  return 'Şifre boş bırakılamaz.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                                } // Açık olan kod/bileşen bloğunu kapatır
                                return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                              }, // Açık olan kod/bileşen bloğunu kapatır
                              suffixIcon: IconButton( // Tıklanabilir aksiyon butonunu oluşturur
                                key: const Key('toggle_password_visibility'), // key özelliğini yapılandırır
                                tooltip: _obscurePassword // İlgili kod satırını ve işlemi yürütür
                                    ? 'Şifreyi Göster' // İlgili kod satırını ve işlemi yürütür
                                    : 'Şifreyi Gizle', //  özelliğini yapılandırır
                                icon: Icon( // Ekranda vektörel ikon gösterir
                                  _obscurePassword // İlgili kod satırını ve işlemi yürütür
                                      ? Icons.visibility_outlined // İlgili kod satırını ve işlemi yürütür
                                      : Icons.visibility_off_outlined, //  özelliğini yapılandırır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                                onPressed: () { // onPressed özelliğini yapılandırır
                                  setState(() { // Yerel durumu güncelleyerek ekranın yeniden çizilmesini tetikler
                                    _obscurePassword = !_obscurePassword; // İlgili kod satırını ve işlemi yürütür
                                  }); // İlgili kod satırını ve işlemi yürütür
                                }, // Açık olan kod/bileşen bloğunu kapatır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 20), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            CustomButton( // Tıklanabilir aksiyon butonunu oluşturur
                              key: const Key('login_submit_button'), // key özelliğini yapılandırır
                              label: 'Giriş Yap', // label özelliğini yapılandırır
                              icon: Icons.login_rounded, // icon özelliğini yapılandırır
                              isLoading: authState.isLoading, // isLoading özelliğini yapılandırır
                              onPressed: _handleLogin, // onPressed özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ], // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    const SizedBox(height: 16), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                    Row( // Alt bileşenleri yatay eksende yan yana dizer
                      mainAxisAlignment: MainAxisAlignment.center, // mainAxisAlignment özelliğini yapılandırır
                      children: [ // İlgili kod satırını ve işlemi yürütür
                        Text( // Ekrana metin bileşeni yazdırır
                          'Hesabın yok mu?', // İlgili kod satırını ve işlemi yürütür
                          style: theme.textTheme.bodyMedium, // style özelliğini yapılandırır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                        TextButton( // Tıklanabilir aksiyon butonunu oluşturur
                          key: const Key('go_to_register_button'), // key özelliğini yapılandırır
                          onPressed: () => context.push('/register'), // Yeni ekranı mevcut ekranın üzerine açar (geri dönülebilir)
                          child: const Text( // Ekrana metin bileşeni yazdırır
                            'Hesap oluştur', // İlgili kod satırını ve işlemi yürütür
                            style: TextStyle(fontWeight: FontWeight.w800), // style özelliğini yapılandırır
                          ), // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ], // Açık olan kod/bileşen bloğunu kapatır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                  ], // Açık olan kod/bileşen bloğunu kapatır
                ), // Açık olan kod/bileşen bloğunu kapatır
              ), // Açık olan kod/bileşen bloğunu kapatır
            ), // Açık olan kod/bileşen bloğunu kapatır
          ), // Açık olan kod/bileşen bloğunu kapatır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır
} // Açık olan kod/bileşen bloğunu kapatır
