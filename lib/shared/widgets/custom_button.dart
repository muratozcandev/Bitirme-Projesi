// Uygulama genelinde kullanılan özelleştirilmiş ortak buton bileşenidir.

import 'package:flutter/material.dart';

/// Yüklenme durumu (loading indicator), opsiyonel ikon desteği
/// ve dolu/çerçeveli (outlined) stil seçenekleri sunan genişletilebilir buton.
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isOutlined = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // Yüklenme durumunda döner gösterge, aksi halde ikon ve metin içeriği
    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );

    // Çerçeveli (outlined) buton varyantı
    if (isOutlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        ),
      );
    }

    // Dolu (elevated) buton varyantı
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: backgroundColor != null || foregroundColor != null
            ? ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
              )
            : null,
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }
}
