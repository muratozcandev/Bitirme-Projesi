import 'package:flutter/material.dart'; // Flutter Material tasarım bileşenlerini içe aktarır
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod durum yönetimi (state management) paketini içe aktarır
import 'package:go_router/go_router.dart'; // GoRouter sayfa yönlendirme paketini içe aktarır
import '../../../app/theme/app_theme.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../core/utils/validators.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/providers/app_providers.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/app_logo_widget.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/custom_button.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../../shared/widgets/custom_text_field.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır
import '../../legal/presentation/legal_document_screen.dart'; // İlgili proje modülünü veya bağımlılığını içe aktarır

class RegisterScreen extends ConsumerStatefulWidget { // Riverpod destekli durum bilgili (Stateful) RegisterScreen ekran bileşenini tanımlar
  const RegisterScreen({super.key}); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState(); // İlgili kod satırını ve işlemi yürütür
} // Açık olan kod/bileşen bloğunu kapatır

class _RegisterScreenState extends ConsumerState<RegisterScreen> { // _RegisterScreenState ekranının Riverpod destekli durum (State) sınıfını tanımlar
  final _formKey = GlobalKey<FormState>(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final _firstNameController = TextEditingController(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final _lastNameController = TextEditingController(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final _emailController = TextEditingController(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final _phoneController = TextEditingController(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar
  final _passwordController = TextEditingController(); // Değişmez (sabit/final) alanı veya değişkeni tanımlar

  bool _obscurePassword = true; // İlgili kod satırını ve işlemi yürütür
  bool _acceptedUserAgreement = false; // İlgili kod satırını ve işlemi yürütür
  bool _acceptedKvkk = false; // İlgili kod satırını ve işlemi yürütür

  @override // Üst sınıftan gelen metodu geçersiz kıldığını (override) belirtir
  void dispose() { // İlgili kod satırını ve işlemi yürütür
    _firstNameController.dispose(); // Bellek sızıntısını önlemek için kontrolcüyü temizler
    _lastNameController.dispose(); // Bellek sızıntısını önlemek için kontrolcüyü temizler
    _emailController.dispose(); // Bellek sızıntısını önlemek için kontrolcüyü temizler
    _phoneController.dispose(); // Bellek sızıntısını önlemek için kontrolcüyü temizler
    _passwordController.dispose(); // Bellek sızıntısını önlemek için kontrolcüyü temizler
    super.dispose(); // Üst sınıfın (super) ilgili metodunu veya anahtarını çağırır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _openLegalDocument(String docType) async { // İlgili kod satırını ve işlemi yürütür
    final result = await Navigator.of(context).push<bool>( // Sabit/final değişken veya nesne tanımını başlatır
      MaterialPageRoute( // İlgili kod satırını ve işlemi yürütür
        builder: (_) => LegalDocumentScreen(documentType: docType), // builder özelliğini yapılandırır
      ), // Açık olan kod/bileşen bloğunu kapatır
    ); // Açık olan kod/bileşen bloğunu kapatır
    if (result == true && mounted) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      setState(() { // Yerel durumu güncelleyerek ekranın yeniden çizilmesini tetikler
        if (docType == 'user_agreement') { // Koşulun sağlanıp sağlanmadığını kontrol eder
          _acceptedUserAgreement = true; // İlgili kod satırını ve işlemi yürütür
        } else if (docType == 'kvkk') { // Önceki koşul sağlanmadıysa alternatif koşulu kontrol eder
          _acceptedKvkk = true; // İlgili kod satırını ve işlemi yürütür
        } // Açık olan kod/bileşen bloğunu kapatır
      }); // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır
  } // Açık olan kod/bileşen bloğunu kapatır

  Future<void> _handleRegister() async { // İlgili kod satırını ve işlemi yürütür
    if (!_formKey.currentState!.validate()) return; // Koşulun sağlanıp sağlanmadığını kontrol eder

    if (!_acceptedUserAgreement) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: Text( // Ekrana metin bileşeni yazdırır
            'Kayıt olabilmek için Kullanıcı Sözleşmesi\'ni onaylamalısınız.', // İlgili kod satırını ve işlemi yürütür
          ), // Açık olan kod/bileşen bloğunu kapatır
          backgroundColor: AppColors.error, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
      return; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    if (!_acceptedKvkk) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: Text( // Ekrana metin bileşeni yazdırır
            'Kayıt olabilmek için KVKK Aydınlatma Metni\'ni onaylamalısınız.', // İlgili kod satırını ve işlemi yürütür
          ), // Açık olan kod/bileşen bloğunu kapatır
          backgroundColor: AppColors.error, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
      return; // İlgili kod satırını ve işlemi yürütür
    } // Açık olan kod/bileşen bloğunu kapatır

    final success = await ref.read(authProvider.notifier).register( // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
          firstName: _firstNameController.text, // firstName özelliğini yapılandırır
          lastName: _lastNameController.text, // lastName özelliğini yapılandırır
          email: _emailController.text, // email özelliğini yapılandırır
          phone: _phoneController.text, // phone özelliğini yapılandırır
          password: _passwordController.text, // password özelliğini yapılandırır
          acceptedUserAgreement: _acceptedUserAgreement, // acceptedUserAgreement özelliğini yapılandırır
          acceptedKvkk: _acceptedKvkk, // acceptedKvkk özelliğini yapılandırır
        ); // Açık olan kod/bileşen bloğunu kapatır

    if (!mounted) return; // Koşulun sağlanıp sağlanmadığını kontrol eder

    if (success) { // Koşulun sağlanıp sağlanmadığını kontrol eder
      triggerGlobalRefresh(ref); // İlgili kod satırını ve işlemi yürütür
      ScaffoldMessenger.of(context).showSnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
        const SnackBar( // Ekranın altında bilgilendirme veya hata mesajı (SnackBar) gösterir
          content: Text( // Ekrana metin bileşeni yazdırır
            'Hesabınız başarıyla oluşturuldu! Şimdi giriş yapabilirsiniz.', // İlgili kod satırını ve işlemi yürütür
          ), // Açık olan kod/bileşen bloğunu kapatır
          backgroundColor: AppColors.success, // backgroundColor özelliğini yapılandırır
        ), // Açık olan kod/bileşen bloğunu kapatır
      ); // Açık olan kod/bileşen bloğunu kapatır
      if (context.canPop()) { // Koşulun sağlanıp sağlanmadığını kontrol eder
        context.pop(); // Açık olan pencereyi veya üst ekranı kapatıp önceki ekrana döner
      } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
        context.go('/login'); // Belirtilen rotaya doğrudan geçiş yapar (navigasyon geçmişini sıfırlar)
      } // Açık olan kod/bileşen bloğunu kapatır
    } else { // Koşul sağlanmadığında çalışacak alternatif bloğu başlatır
      final error = // Sabit/final değişken veya nesne tanımını başlatır
          ref.read(authProvider).error ?? 'Kayıt sırasında hata oluştu.'; // İlgili Riverpod sağlayıcısının anlık değerini veya kontrolcüsünü okur
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
      appBar: AppBar( // Ekranın üst başlık çubuğunu (AppBar) oluşturur
        title: const Text('Hesap Oluştur'), // Ekrana metin bileşeni yazdırır
      ), // Açık olan kod/bileşen bloğunu kapatır
      body: SafeArea( // İçeriği telefonun çentik ve sistem çubuğu alanlarından korur
        child: Center( // İçindeki bileşeni yatay ve dikey olarak ortalar
          child: SingleChildScrollView( // İçeriğin ekrana sığmadığında dikey/yatay kaydırılabilmesini sağlar
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // padding özelliğini yapılandırır
            child: ConstrainedBox( // İlgili kod satırını ve işlemi yürütür
              constraints: const BoxConstraints(maxWidth: 460), // constraints özelliğini yapılandırır
              child: Form( // İlgili kod satırını ve işlemi yürütür
                key: _formKey, // key özelliğini yapılandırır
                child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                  crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
                  children: [ // İlgili kod satırını ve işlemi yürütür
                    const AppLogoWidget( // Sabit/final değişken veya nesne tanımını başlatır
                      size: 68, // size özelliğini yapılandırır
                      showTitle: false, // showTitle özelliğini yapılandırır
                      showSubtitle: false, // showSubtitle özelliğini yapılandırır
                    ), // Açık olan kod/bileşen bloğunu kapatır
                    const SizedBox(height: 16), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                    Card( // Köşeleri yuvarlatılmış ve gölgeli bilgi kartı kutusu oluşturur
                      child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
                        padding: const EdgeInsets.all(18), // padding özelliğini yapılandırır
                        child: Column( // Alt bileşenleri dikey eksende alt alta dizer
                          crossAxisAlignment: CrossAxisAlignment.stretch, // crossAxisAlignment özelliğini yapılandırır
                          children: [ // İlgili kod satırını ve işlemi yürütür
                            Text( // Ekrana metin bileşeni yazdırır
                              'Yeni Oyuncu Kaydı', // İlgili kod satırını ve işlemi yürütür
                              style: theme.textTheme.titleLarge?.copyWith( // İlgili kod satırını ve işlemi yürütür
                                fontWeight: FontWeight.w800, // fontWeight özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 4), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            Text( // Ekrana metin bileşeni yazdırır
                              '7v7 ile takım kurmak ve maçlara katılmak için tüm alanları doldurunuz.', // İlgili kod satırını ve işlemi yürütür
                              style: theme.textTheme.bodySmall?.copyWith( // İlgili kod satırını ve işlemi yürütür
                                color: theme.colorScheme.onSurfaceVariant, // color özelliğini yapılandırır
                              ), // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 16), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            CustomTextField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
                              key: const Key('register_first_name_field'), // key özelliğini yapılandırır
                              controller: _firstNameController, // controller özelliğini yapılandırır
                              label: 'Ad', // label özelliğini yapılandırır
                              hint: 'Adınız', // hint özelliğini yapılandırır
                              prefixIcon: Icons.person_outline, // prefixIcon özelliğini yapılandırır
                              textInputAction: TextInputAction.next, // textInputAction özelliğini yapılandırır
                              validator: (v) => // İlgili kod satırını ve işlemi yürütür
                                  Validators.validateRequired(v, 'Ad'), // İlgili kod satırını ve işlemi yürütür
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            CustomTextField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
                              key: const Key('register_last_name_field'), // key özelliğini yapılandırır
                              controller: _lastNameController, // controller özelliğini yapılandırır
                              label: 'Soyad', // label özelliğini yapılandırır
                              hint: 'Soyadınız', // hint özelliğini yapılandırır
                              prefixIcon: Icons.badge_outlined, // prefixIcon özelliğini yapılandırır
                              textInputAction: TextInputAction.next, // textInputAction özelliğini yapılandırır
                              validator: (v) => // İlgili kod satırını ve işlemi yürütür
                                  Validators.validateRequired(v, 'Soyad'), // İlgili kod satırını ve işlemi yürütür
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            CustomTextField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
                              key: const Key('register_email_field'), // key özelliğini yapılandırır
                              controller: _emailController, // controller özelliğini yapılandırır
                              label: 'E-posta', // label özelliğini yapılandırır
                              hint: 'ornek@gmail.com', // hint özelliğini yapılandırır
                              prefixIcon: Icons.email_outlined, // prefixIcon özelliğini yapılandırır
                              keyboardType: TextInputType.emailAddress, // keyboardType özelliğini yapılandırır
                              textInputAction: TextInputAction.next, // textInputAction özelliğini yapılandırır
                              validator: Validators.validateEmail, // validator özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            CustomTextField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
                              key: const Key('register_phone_field'), // key özelliğini yapılandırır
                              controller: _phoneController, // controller özelliğini yapılandırır
                              label: 'Telefon Numarası', // label özelliğini yapılandırır
                              hint: '05XXXXXXXXX', // hint özelliğini yapılandırır
                              prefixIcon: Icons.phone_android_outlined, // prefixIcon özelliğini yapılandırır
                              keyboardType: TextInputType.phone, // keyboardType özelliğini yapılandırır
                              textInputAction: TextInputAction.next, // textInputAction özelliğini yapılandırır
                              validator: Validators.validatePhone, // validator özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 12), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            CustomTextField( // Kullanıcıdan metin girdisi alan form alanını oluşturur
                              key: const Key('register_password_field'), // key özelliğini yapılandırır
                              controller: _passwordController, // controller özelliğini yapılandırır
                              label: 'Şifre', // label özelliğini yapılandırır
                              hint: 'En az 6 karakter', // hint özelliğini yapılandırır
                              prefixIcon: Icons.lock_outline, // prefixIcon özelliğini yapılandırır
                              obscureText: _obscurePassword, // obscureText özelliğini yapılandırır
                              textInputAction: TextInputAction.done, // textInputAction özelliğini yapılandırır
                              validator: (v) { // validator özelliğini yapılandırır
                                if (v == null || v.isEmpty) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                                  return 'Şifre boş bırakılamaz.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                                } // Açık olan kod/bileşen bloğunu kapatır
                                if (v.length < 6) { // Koşulun sağlanıp sağlanmadığını kontrol eder
                                  return 'Şifre en az 6 karakter olmalıdır.'; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                                } // Açık olan kod/bileşen bloğunu kapatır
                                return null; // Hesaplanan değeri veya bileşeni çağrıldığı yere döndürür
                              }, // Açık olan kod/bileşen bloğunu kapatır
                              suffixIcon: IconButton( // Tıklanabilir aksiyon butonunu oluşturur
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
                              key: const Key('register_submit_button'), // key özelliğini yapılandırır
                              label: 'Hesap Oluştur', // label özelliğini yapılandırır
                              icon: Icons.person_add_alt_1_rounded, // icon özelliğini yapılandırır
                              isLoading: authState.isLoading, // isLoading özelliğini yapılandırır
                              onPressed: _handleRegister, // onPressed özelliğini yapılandırır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            const SizedBox(height: 16), // Sabit genişlik/yükseklik veya bileşenler arası boşluk oluşturur
                            const Divider(), // Sabit/final değişken veya nesne tanımını başlatır
                            // 1. Kullanıcı Sözleşmesi Onay Alanı
                            Row( // Alt bileşenleri yatay eksende yan yana dizer
                              crossAxisAlignment: CrossAxisAlignment.center, // crossAxisAlignment özelliğini yapılandırır
                              children: [ // İlgili kod satırını ve işlemi yürütür
                                Checkbox( // İlgili kod satırını ve işlemi yürütür
                                  key: const Key('checkbox_user_agreement'), // key özelliğini yapılandırır
                                  value: _acceptedUserAgreement, // value özelliğini yapılandırır
                                  onChanged: (val) { // onChanged özelliğini yapılandırır
                                    setState(() { // Yerel durumu güncelleyerek ekranın yeniden çizilmesini tetikler
                                      _acceptedUserAgreement = val ?? false; // İlgili kod satırını ve işlemi yürütür
                                    }); // İlgili kod satırını ve işlemi yürütür
                                  }, // Açık olan kod/bileşen bloğunu kapatır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                                Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                                  child: InkWell( // İlgili kod satırını ve işlemi yürütür
                                    key: const Key('link_user_agreement'), // key özelliğini yapılandırır
                                    onTap: () => // İlgili kod satırını ve işlemi yürütür
                                        _openLegalDocument('user_agreement'), // İlgili kod satırını ve işlemi yürütür
                                    child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
                                      padding: const EdgeInsets.symmetric( // İlgili kod satırını ve işlemi yürütür
                                          vertical: 6), // vertical özelliğini yapılandırır
                                      child: RichText( // Ekrana metin bileşeni yazdırır
                                        text: TextSpan( // İlgili kod satırını ve işlemi yürütür
                                          style: theme.textTheme.bodyMedium, // style özelliğini yapılandırır
                                          children: [ // İlgili kod satırını ve işlemi yürütür
                                            TextSpan( // İlgili kod satırını ve işlemi yürütür
                                              text: 'Kullanıcı Sözleşmesi: ', // text özelliğini yapılandırır
                                              style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                                fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                                                color: // İlgili kod satırını ve işlemi yürütür
                                                    theme.colorScheme.primary, // İlgili kod satırını ve işlemi yürütür
                                              ), // Açık olan kod/bileşen bloğunu kapatır
                                            ), // Açık olan kod/bileşen bloğunu kapatır
                                            const TextSpan( // Sabit/final değişken veya nesne tanımını başlatır
                                              text: // İlgili kod satırını ve işlemi yürütür
                                                  'Sözleşmeyi okudum ve anladım', // İlgili kod satırını ve işlemi yürütür
                                              style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                                decoration: // İlgili kod satırını ve işlemi yürütür
                                                    TextDecoration.underline, // İlgili kod satırını ve işlemi yürütür
                                              ), // Açık olan kod/bileşen bloğunu kapatır
                                            ), // Açık olan kod/bileşen bloğunu kapatır
                                          ], // Açık olan kod/bileşen bloğunu kapatır
                                        ), // Açık olan kod/bileşen bloğunu kapatır
                                      ), // Açık olan kod/bileşen bloğunu kapatır
                                    ), // Açık olan kod/bileşen bloğunu kapatır
                                  ), // Açık olan kod/bileşen bloğunu kapatır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                              ], // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                            // 2. KVKK Aydınlatma Metni Onay Alanı
                            Row( // Alt bileşenleri yatay eksende yan yana dizer
                              crossAxisAlignment: CrossAxisAlignment.center, // crossAxisAlignment özelliğini yapılandırır
                              children: [ // İlgili kod satırını ve işlemi yürütür
                                Checkbox( // İlgili kod satırını ve işlemi yürütür
                                  key: const Key('checkbox_kvkk'), // key özelliğini yapılandırır
                                  value: _acceptedKvkk, // value özelliğini yapılandırır
                                  onChanged: (val) { // onChanged özelliğini yapılandırır
                                    setState(() { // Yerel durumu güncelleyerek ekranın yeniden çizilmesini tetikler
                                      _acceptedKvkk = val ?? false; // İlgili kod satırını ve işlemi yürütür
                                    }); // İlgili kod satırını ve işlemi yürütür
                                  }, // Açık olan kod/bileşen bloğunu kapatır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                                Expanded( // Mevcut boş alanı esnek şekilde dolduran kapsayıcı oluşturur
                                  child: InkWell( // İlgili kod satırını ve işlemi yürütür
                                    key: const Key('link_kvkk'), // key özelliğini yapılandırır
                                    onTap: () => _openLegalDocument('kvkk'), // onTap özelliğini yapılandırır
                                    child: Padding( // İçindeki bileşenin etrafına iç boşluk (padding) ekler
                                      padding: const EdgeInsets.symmetric( // İlgili kod satırını ve işlemi yürütür
                                          vertical: 6), // vertical özelliğini yapılandırır
                                      child: RichText( // Ekrana metin bileşeni yazdırır
                                        text: TextSpan( // İlgili kod satırını ve işlemi yürütür
                                          style: theme.textTheme.bodyMedium, // style özelliğini yapılandırır
                                          children: [ // İlgili kod satırını ve işlemi yürütür
                                            TextSpan( // İlgili kod satırını ve işlemi yürütür
                                              text: 'KVKK Aydınlatma Metni: ', // text özelliğini yapılandırır
                                              style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                                fontWeight: FontWeight.w700, // fontWeight özelliğini yapılandırır
                                                color: // İlgili kod satırını ve işlemi yürütür
                                                    theme.colorScheme.primary, // İlgili kod satırını ve işlemi yürütür
                                              ), // Açık olan kod/bileşen bloğunu kapatır
                                            ), // Açık olan kod/bileşen bloğunu kapatır
                                            const TextSpan( // Sabit/final değişken veya nesne tanımını başlatır
                                              text: // İlgili kod satırını ve işlemi yürütür
                                                  'KVKK metnini okudum ve anladım', // İlgili kod satırını ve işlemi yürütür
                                              style: TextStyle( // İlgili kod satırını ve işlemi yürütür
                                                decoration: // İlgili kod satırını ve işlemi yürütür
                                                    TextDecoration.underline, // İlgili kod satırını ve işlemi yürütür
                                              ), // Açık olan kod/bileşen bloğunu kapatır
                                            ), // Açık olan kod/bileşen bloğunu kapatır
                                          ], // Açık olan kod/bileşen bloğunu kapatır
                                        ), // Açık olan kod/bileşen bloğunu kapatır
                                      ), // Açık olan kod/bileşen bloğunu kapatır
                                    ), // Açık olan kod/bileşen bloğunu kapatır
                                  ), // Açık olan kod/bileşen bloğunu kapatır
                                ), // Açık olan kod/bileşen bloğunu kapatır
                              ], // Açık olan kod/bileşen bloğunu kapatır
                            ), // Açık olan kod/bileşen bloğunu kapatır
                          ], // Açık olan kod/bileşen bloğunu kapatır
                        ), // Açık olan kod/bileşen bloğunu kapatır
                      ), // Açık olan kod/bileşen bloğunu kapatır
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

