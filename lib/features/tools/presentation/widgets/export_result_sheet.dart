import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../domain/entities/processed_file.dart';

class ExportResultSheet extends StatelessWidget {
  const ExportResultSheet({required this.file, super.key});

  final ProcessedFile file;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Export ready',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(file.metadata['title'] ?? file.type.label),
            const SizedBox(height: AppSizes.md),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(FileSizeFormatter.format(file.fileSizeBytes))),
                if (file.pageCount != null)
                  Chip(label: Text('${file.pageCount} page')),
              ],
            ),
            const SizedBox(height: AppSizes.lg),
            FilledButton.icon(
              onPressed: () {
                SharePlus.instance.share(
                  ShareParams(files: [XFile(file.localPath)]),
                );
              },
              icon: const Icon(Icons.ios_share_rounded),
              label: const Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}
