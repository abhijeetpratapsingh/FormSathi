import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/processed_file_type.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../domain/entities/processed_file.dart';

class RecentProcessedFileCard extends StatelessWidget {
  const RecentProcessedFileCard({
    required this.file,
    required this.onShare,
    required this.onDelete,
    super.key,
    this.onTap,
  });

  final ProcessedFile file;
  final VoidCallback onShare;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayTitle =
        file.metadata['title'] ??
        file.metadata['quality'] ??
        file.metadata['preset'] ??
        file.type.label;
    final subtitle =
        file.metadata['sourceTitle'] ??
        file.metadata['pages'] ??
        file.metadata['dimensions'] ??
        file.metadata['quality'] ??
        'Saved offline';
    final sizeHint = FileSizeFormatter.format(
      file.fileSizeBytes > 0
          ? file.fileSizeBytes
          : (File(file.localPath).existsSync()
                ? File(file.localPath).lengthSync()
                : 0),
    );

    return Card(
      child: InkWell(
        borderRadius: AppSizes.cardRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  file.type == ProcessedFileType.pdf
                      ? Icons.picture_as_pdf
                      : Icons.image_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.textTheme.bodyMedium),
                    if (file.presetId != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        file.presetId!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      '${file.createdAt.toDisplayDate()} • $sizeHint',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'share') onShare();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'share', child: Text('Share')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
