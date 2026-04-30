import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final primary = AppColors.primary;
    final accent = AppColors.accent;
    final background = AppColors.background;
    final foreground = AppColors.foreground;
    final secondarySurface = AppColors.secondary;
    final muted = AppColors.muted;
    final destructive = AppColors.destructive;
    final border = AppColors.border;
    final ring = AppColors.ring;

    final colorScheme =
        ColorScheme(
          brightness: Brightness.light,
          primary: primary,
          onPrimary: Colors.white,
          secondary: accent,
          onSecondary: Colors.white,
          tertiary: secondarySurface,
          onTertiary: foreground,
          error: destructive,
          onError: Colors.white,
          surface: background,
          onSurface: foreground,
          surfaceContainerHighest: muted,
          onSurfaceVariant: foreground.withValues(alpha: 0.7),
          outline: border,
        ).copyWith(
          primaryContainer: secondarySurface,
          onPrimaryContainer: foreground,
          secondaryContainer: secondarySurface,
          onSecondaryContainer: foreground,
          tertiaryContainer: muted,
          onTertiaryContainer: foreground,
        );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      fontFamily: 'Plus Jakarta Sans',
      textTheme: Typography.blackMountainView.apply(
        fontFamily: 'Plus Jakarta Sans',
        fontFamilyFallback: const ['ui-sans-serif', 'system-ui', 'sans-serif'],
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.cardRadius,
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.55)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppSizes.fieldRadius,
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.fieldRadius,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSizes.fieldRadius,
          borderSide: BorderSide(color: ring, width: 1.4),
        ),
      ),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: foreground,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      iconTheme: IconThemeData(color: foreground.withValues(alpha: 0.9)),
      dividerTheme: DividerThemeData(color: border),
      chipTheme: base.chipTheme.copyWith(
        shape: const RoundedRectangleBorder(borderRadius: AppSizes.fieldRadius),
        side: BorderSide(color: border),
        backgroundColor: secondarySurface,
        labelStyle: base.textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppSizes.fieldRadius,
          ),
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppSizes.fieldRadius,
          ),
          side: BorderSide(color: border),
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppSizes.fieldRadius,
          ),
          foregroundColor: primary,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: AppSizes.fieldRadius),
      ),
    );
  }
}
