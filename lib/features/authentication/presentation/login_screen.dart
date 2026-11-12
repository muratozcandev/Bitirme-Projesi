// Kullanıcıların e-posta ve şifre ile uygulamaya giriş yaptığı ekrandır.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/app_logo_widget.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authProvider.notifier).login(
          identifier: _identifierController.text,
          password: _passwordController.text,
        );

    if (!mounted) return;

    if (success) {
      triggerGlobalRefresh(ref);
      context.go('/team-creation');
    } else {
      final error = ref.read(authProvider).error ?? 'Giriş yapılamadı.';
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppLogoWidget(
                      size: 96,
                      showTitle: true,
                      showSubtitle: true,
                    ),
                    const SizedBox(height: 28),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Giriş Yap',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Kayıtlı e-posta adresiniz ve şifreniz ile giriş yapabilirsiniz.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 18),
                            CustomTextField(
                              key: const Key('login_identifier_field'),
                              controller: _identifierController,
                              label: 'E-posta Adresi',
                              hint: 'E-posta adresinizi giriniz',
                              prefixIcon: Icons.alternate_email_rounded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (val) {
                                final trimmed = (val ?? '').trim();
                                if (trimmed.isEmpty) {
                                  return 'E-posta adresi boş bırakılamaz.';
                                }
                                if (!trimmed.contains('@') ||
                                    Validators.isPhone(trimmed)) {
                                  return 'Telefonla giriş geçici olarak devre dışıdır. Lütfen e-posta giriniz.';
                                }
                                return Validators.validateEmail(trimmed);
                              },
                            ),
                            const SizedBox(height: 14),
                            CustomTextField(
                              key: const Key('login_password_field'),
                              controller: _passwordController,
                              label: 'Şifre',
                              hint: 'Şifrenizi giriniz',
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleLogin(),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Şifre boş bırakılamaz.';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                key: const Key('toggle_password_visibility'),
                                tooltip: _obscurePassword
                                    ? 'Şifreyi Göster'
                                    : 'Şifreyi Gizle',
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
                              key: const Key('login_submit_button'),
                              label: 'Giriş Yap',
                              icon: Icons.login_rounded,
                              isLoading: authState.isLoading,
                              onPressed: _handleLogin,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hesabın yok mu?',
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextButton(
                          key: const Key('go_to_register_button'),
                          onPressed: () => context.push('/register'),
                          child: const Text(
                            'Hesap oluştur',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
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
