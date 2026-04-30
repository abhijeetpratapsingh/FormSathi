import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import 'enterprise_header_tokens.dart';

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
          surface: AppColors.surface,
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
      textTheme: Typography.blackMountainView
          .apply(
            fontFamily: 'Plus Jakarta Sans',
            fontFamilyFallback: const [
              'ui-sans-serif',
              'system-ui',
              'sans-serif',
            ],
          )
          .copyWith(
            headlineSmall: const TextStyle(
              fontSize: 22,
              height: 1.25,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
            titleLarge: const TextStyle(
              fontSize: 20,
              height: 1.3,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
            titleMedium: const TextStyle(
              fontSize: 16,
              height: 1.35,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
            bodyLarge: const TextStyle(
              fontSize: 15,
              height: 1.45,
              letterSpacing: 0,
            ),
            bodyMedium: const TextStyle(
              fontSize: 14,
              height: 1.45,
              letterSpacing: 0,
            ),
            bodySmall: const TextStyle(
              fontSize: 12,
              height: 1.35,
              letterSpacing: 0,
            ),
            labelLarge: const TextStyle(
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
            labelMedium: const TextStyle(
              fontSize: 12,
              height: 1.3,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppSizes.cardRadius,
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.55)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: 15,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: TextStyle(
          fontSize: 14,
          height: 1.45,
          color: foreground.withValues(alpha: 0.42),
          fontWeight: FontWeight.w500,
        ),
        helperStyle: TextStyle(
          fontSize: 12,
          height: 1.35,
          color: foreground.withValues(alpha: 0.58),
          fontWeight: FontWeight.w600,
        ),
        errorStyle: TextStyle(
          fontSize: 12,
          height: 1.35,
          color: destructive,
          fontWeight: FontWeight.w700,
        ),
        helperMaxLines: 2,
        errorMaxLines: 2,
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) return primary;
          return foreground.withValues(alpha: 0.54);
        }),
        suffixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) return primary;
          return foreground.withValues(alpha: 0.54);
        }),
        border: OutlineInputBorder(
          borderRadius: AppSizes.fieldRadius,
          borderSide: BorderSide(color: border.withValues(alpha: 0.9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppSizes.fieldRadius,
          borderSide: BorderSide(color: border.withValues(alpha: 0.9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppSizes.fieldRadius,
          borderSide: BorderSide(color: ring, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppSizes.fieldRadius,
          borderSide: BorderSide(color: destructive.withValues(alpha: 0.85)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppSizes.fieldRadius,
          borderSide: BorderSide(color: destructive, width: 1.6),
        ),
      ),
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        toolbarHeight: AppSizes.compactTopBarHeight,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        actionsIconTheme: IconThemeData(
          size: AppSizes.topBarActionIcon,
          color: foreground.withValues(alpha: 0.9),
        ),
        actionsPadding: const EdgeInsetsDirectional.only(end: AppSizes.md),
        titleTextStyle: EnterpriseHeaderTokens.titleTextStyle(
          base.textTheme,
          foreground,
        ),
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
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          textStyle: base.textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppSizes.fieldRadius,
          ),
          side: BorderSide(color: border),
          foregroundColor: foreground,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          textStyle: base.textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: AppSizes.fieldRadius,
          ),
          foregroundColor: primary,
          minimumSize: const Size(48, 48),
          textStyle: base.textTheme.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: AppSizes.fieldRadius),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: AppSizes.bottomNavHeight,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.secondary,
        elevation: 2,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 23,
            color: selected ? primary : foreground.withValues(alpha: 0.62),
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return base.textTheme.labelMedium?.copyWith(
            color: selected ? primary : foreground.withValues(alpha: 0.62),
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          );
        }),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppSizes.sheetRadius),
        showDragHandle: true,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: foreground.withValues(alpha: 0.72),
        titleTextStyle: base.textTheme.titleMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
        subtitleTextStyle: base.textTheme.bodySmall?.copyWith(
          color: foreground.withValues(alpha: 0.64),
        ),
        minLeadingWidth: 28,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
