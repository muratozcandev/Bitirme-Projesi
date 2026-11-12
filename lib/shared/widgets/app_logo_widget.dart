import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';

class AppLogoWidget extends StatelessWidget {
  final double size;
  final bool showTitle;
  final bool showSubtitle;

  const AppLogoWidget({
    super.key,
    this.size = 92,
    this.showTitle = true,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.24),
            boxShadow: [
              BoxShadow(
                color: AppColors.pitchGreen.withValues(alpha: 0.28),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.primaryDarkGreen,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_soccer,
                      color: AppColors.pitchLightGreen,
                      size: size * 0.42,
                    ),
                    Text(
                      '7v7',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: size * 0.24,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (showTitle) ...[
          const SizedBox(height: 12),
          Text(
            '7v7',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
        if (showSubtitle) ...[
          const SizedBox(height: 4),
          Text(
            '7\'ye 7 Halı Saha Maç Organizasyonu',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

