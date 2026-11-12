import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/app_logo_widget.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../legal/presentation/legal_document_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _acceptedUserAgreement = false;
  bool _acceptedKvkk = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _openLegalDocument(String docType) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LegalDocumentScreen(documentType: docType),
      ),
    );
    if (result == true && mounted) {
      setState(() {
        if (docType == 'user_agreement') {
          _acceptedUserAgreement = true;
        } else if (docType == 'kvkk') {
          _acceptedKvkk = true;
        }
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_acceptedUserAgreement) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kayıt olabilmek için Kullanıcı Sözleşmesi\'ni onaylamalısınız.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (!_acceptedKvkk) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Kayıt olabilmek için KVKK Aydınlatma Metni\'ni onaylamalısınız.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final success = await ref.read(authProvider.notifier).register(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          acceptedUserAgreement: _acceptedUserAgreement,
          acceptedKvkk: _acceptedKvkk,
        );

    if (!mounted) return;

    if (success) {
      triggerGlobalRefresh(ref);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Hesabınız başarıyla oluşturuldu! Şimdi giriş yapabilirsiniz.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
      if (context.canPop()) {
        context.pop();
      } else {
        context.go('/login');
      }
    } else {
      final error =
          ref.read(authProvider).error ?? 'Kayıt sırasında hata oluştu.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap Oluştur'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppLogoWidget(
                      size: 68,
                      showTitle: false,
                      showSubtitle: false,
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Yeni Oyuncu Kaydı',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '7v7 ile takım kurmak ve maçlara katılmak için tüm alanları doldurunuz.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              key: const Key('register_first_name_field'),
                              controller: _firstNameController,
                              label: 'Ad',
                              hint: 'Adınız',
                              prefixIcon: Icons.person_outline,
                              textInputAction: TextInputAction.next,
                              validator: (v) =>
                                  Validators.validateRequired(v, 'Ad'),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              key: const Key('register_last_name_field'),
                              controller: _lastNameController,
                              label: 'Soyad',
                              hint: 'Soyadınız',
                              prefixIcon: Icons.badge_outlined,
                              textInputAction: TextInputAction.next,
                              validator: (v) =>
                                  Validators.validateRequired(v, 'Soyad'),
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              key: const Key('register_email_field'),
                              controller: _emailController,
                              label: 'E-posta',
                              hint: 'ornek@gmail.com',
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: Validators.validateEmail,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              key: const Key('register_phone_field'),
                              controller: _phoneController,
                              label: 'Telefon Numarası',
                              hint: '05XXXXXXXXX',
                              prefixIcon: Icons.phone_android_outlined,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              validator: Validators.validatePhone,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              key: const Key('register_password_field'),
                              controller: _passwordController,
                              label: 'Şifre',
                              hint: 'En az 4 karakter',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              validator: Validators.validatePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              key: const Key('register_submit_button'),
                              label: 'Hesap Oluştur',
                              icon: Icons.person_add_alt_1_rounded,
                              isLoading: authState.isLoading,
                              onPressed: _handleRegister,
                            ),
                            const SizedBox(height: 16),
                            const Divider(),
                            // 1. Kullanıcı Sözleşmesi Onay Alanı
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  key: const Key('checkbox_user_agreement'),
                                  value: _acceptedUserAgreement,
                                  onChanged: (val) {
                                    setState(() {
                                      _acceptedUserAgreement = val ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: InkWell(
                                    key: const Key('link_user_agreement'),
                                    onTap: () =>
                                        _openLegalDocument('user_agreement'),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: RichText(
                                        text: TextSpan(
                                          style: theme.textTheme.bodyMedium,
                                          children: [
                                            TextSpan(
                                              text: 'Kullanıcı Sözleşmesi: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                            const TextSpan(
                                              text:
                                                  'Sözleşmeyi okudum ve anladım',
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // 2. KVKK Aydınlatma Metni Onay Alanı
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  key: const Key('checkbox_kvkk'),
                                  value: _acceptedKvkk,
                                  onChanged: (val) {
                                    setState(() {
                                      _acceptedKvkk = val ?? false;
                                    });
                                  },
                                ),
                                Expanded(
                                  child: InkWell(
                                    key: const Key('link_kvkk'),
                                    onTap: () => _openLegalDocument('kvkk'),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      child: RichText(
                                        text: TextSpan(
                                          style: theme.textTheme.bodyMedium,
                                          children: [
                                            TextSpan(
                                              text: 'KVKK Aydınlatma Metni: ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            ),
                                            const TextSpan(
                                              text:
                                                  'KVKK metnini okudum ve anladım',
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

