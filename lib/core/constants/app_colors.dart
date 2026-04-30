import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFF175CD3);
  static const Color accent = Color(0xFF0F766E);
  static const Color background = Color(0xFFF7F9FC);
  static final Color foreground = const HSLColor.fromAHSL(
    1,
    222.2,
    0.84,
    0.049,
  ).toColor();
  static const Color secondary = Color(0xFFEFF4FF);
  static const Color muted = Color(0xFFF1F5F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF8FAFC);
  static const Color success = Color(0xFF15803D);
  static const Color successContainer = Color(0xFFE8F7EE);
  static const Color warning = Color(0xFFB45309);
  static const Color warningContainer = Color(0xFFFFF3D6);
  static const Color infoContainer = Color(0xFFEFF6FF);
  static const Color destructive = Color(0xFFB42318);
  static const Color destructiveContainer = Color(0xFFFEE4E2);
  static const Color border = Color(0xFFD7DEE8);
  static const Color ring = Color(0xFF2563EB);

  static LinearGradient primaryGradient() => AppGradients.primary;
}

class AppGradients {
  const AppGradients._();

  static const LinearGradient primary = LinearGradient(
    colors: [Color(0xFF175CD3), AppColors.accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
