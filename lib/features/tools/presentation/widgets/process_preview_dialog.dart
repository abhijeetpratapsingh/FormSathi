import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/processed_file_type.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../domain/entities/processed_file.dart';

Future<void> showProcessedFilePreviewDialog(
  BuildContext context,
  ProcessedFile file, {
  required VoidCallback onShare,
  required VoidCallback onDelete,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      final theme = Theme.of(context);
      final isImage = _isImage(file.localPath);
      final size = FileSizeFormatter.format(File(file.localPath).existsSync() ? File(file.localPath).lengthSync() : 0);
      return Padding(
        padding: EdgeInsets.only(
          left: AppSizes.md,
          right: AppSizes.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(file.localPath),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  file.type == ProcessedFileType.pdf ? Icons.picture_as_pdf : Icons.insert_drive_file,
                  size: 72,
                  color: theme.colorScheme.primary,
                ),
              ),
            const SizedBox(height: AppSizes.md),
            Text(
              file.metadata['title'] ?? file.metadata['preset'] ?? file.metadata['quality'] ?? file.type.label,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(file.localPath, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('${file.createdAt.toDisplayDate()} • $size'),
            const SizedBox(height: AppSizes.md),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDelete();
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
      );
    },
  );
}

bool _isImage(String path) {
  final lower = path.toLowerCase();
  return lower.endsWith('.jpg') ||
      lower.endsWith('.jpeg') ||
      lower.endsWith('.png') ||
      lower.endsWith('.webp') ||
      lower.endsWith('.heic');
}
