import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(AppSizes.md),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
