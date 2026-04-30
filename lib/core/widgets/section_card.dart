import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSizes.md),
    this.gradient,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final Gradient? gradient;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = BoxDecoration(
      color: backgroundColor ?? theme.cardColor,
      gradient: gradient,
      borderRadius: AppSizes.cardRadius,
      border: gradient == null
          ? Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.55))
          : null,
    );

    return Container(
      decoration: decoration,
      child: Padding(padding: padding, child: child),
    );
  }
}
