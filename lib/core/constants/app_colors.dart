import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static final Color primary = const HSLColor.fromAHSL(
    1,
    221,
    0.90,
    0.62,
  ).toColor();
  static final Color accent = const HSLColor.fromAHSL(
    1,
    265,
    0.90,
    0.65,
  ).toColor();
  static final Color background = const HSLColor.fromAHSL(
    1,
    0,
    0.0,
    1.0,
  ).toColor();
  static final Color foreground = const HSLColor.fromAHSL(
    1,
    222.2,
    0.84,
    0.049,
  ).toColor();
  static final Color secondary = const HSLColor.fromAHSL(
    1,
    215,
    0.33,
    0.96,
  ).toColor();
  static final Color muted = const HSLColor.fromAHSL(
    1,
    215,
    0.30,
    0.96,
  ).toColor();
  static final Color destructive = const HSLColor.fromAHSL(
    1,
    0,
    0.842,
    0.602,
  ).toColor();
  static final Color border = const HSLColor.fromAHSL(
    1,
    215,
    0.25,
    0.88,
  ).toColor();
  static final Color ring = const HSLColor.fromAHSL(
    1,
    215,
    0.88,
    0.55,
  ).toColor();

  static LinearGradient primaryGradient() => AppGradients.primary;
}

class AppGradients {
  const AppGradients._();

  static final LinearGradient primary = LinearGradient(
    colors: [
      const HSLColor.fromAHSL(1, 240, 0.89, 0.69).toColor(),
      AppColors.accent,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
