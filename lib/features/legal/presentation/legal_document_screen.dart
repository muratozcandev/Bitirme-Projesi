// Yasal metinleri (Kullanıcı Sözleşmesi ve KVKK) okuma ve onaylama ekranıdır.

import 'package:flutter/material.dart';
import '../data/legal_texts.dart';

class LegalDocumentScreen extends StatelessWidget {
  final String documentType;

  const LegalDocumentScreen({
    super.key,
    required this.documentType,
  });

  bool get _isKvkk => documentType == 'kvkk';

  @override
  Widget build(BuildContext context) {
    final title =
        _isKvkk ? LegalTexts.kvkkTitle : LegalTexts.userAgreementTitle;
    final content =
        _isKvkk ? LegalTexts.kvkkContent : LegalTexts.userAgreementContent;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Lütfen metni dikkatlice inceleyiniz. Onay kutucuğunu işaretleyerek kayıt işlemini tamamlayabilirsiniz.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: SelectableText(
                      content,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.55,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Okudum ve Anladım'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
