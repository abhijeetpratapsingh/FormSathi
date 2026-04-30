import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/export_preset.dart';

class CropExportSheet extends StatelessWidget {
  const CropExportSheet({
    required this.preset,
    required this.onContinue,
    super.key,
  });

  final ExportPreset preset;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              preset.label,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSizes.sm),
            const Text(
              'Crop adjustment will be available before final export.',
            ),
            const SizedBox(height: AppSizes.lg),
            FilledButton(onPressed: onContinue, child: const Text('Continue')),
          ],
        ),
      ),
    );
  }
}
