import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../domain/entities/saved_document.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({
    required this.document,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
    super.key,
    this.compact = false,
  });

  final SavedDocument document;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = _safeSize(document.localPath);
    final image = _documentImage(document.localPath);

    final content = compact
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: document.id,
                child: _Thumbnail(image: image),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _Info(
                  document: document,
                  size: size,
                  onRename: onRename,
                  onDelete: onDelete,
                ),
              ),
            ],
          )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Hero(
                tag: document.id,
                child: _Thumbnail(image: image, fullWidth: true),
              ),
              const SizedBox(height: AppSizes.md),
              _Info(
                document: document,
                size: size,
                onRename: onRename,
                onDelete: onDelete,
              ),
            ],
          );

    return InkWell(
      onTap: onTap,
      borderRadius: AppSizes.cardRadius,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: content,
        ),
      ),
    );
  }

  Widget? _documentImage(String path) {
    final file = File(path);
    if (!file.existsSync()) return null;
    return Image.file(
      file,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }

  int _safeSize(String path) {
    final file = File(path);
    if (!file.existsSync()) return 0;
    return file.lengthSync();
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.image, this.fullWidth = false});

  final Widget? image;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = fullWidth ? 130.0 : 82.0;
    final width = fullWidth ? double.infinity : 82.0;
    return ClipRRect(
      borderRadius: AppSizes.cardRadius,
      child: Container(
        color: theme.colorScheme.surfaceContainerHighest,
        height: height,
        width: width,
        alignment: Alignment.center,
        child: image ??
            Icon(
              Icons.insert_drive_file_rounded,
              size: 32,
              color: theme.colorScheme.primary,
            ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({
    required this.document,
    required this.size,
    required this.onRename,
    required this.onDelete,
  });

  final SavedDocument document;
  final int size;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          document.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MetaChip(label: document.category.label),
            _MetaChip(label: FileSizeFormatter.format(size)),
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        Text(
          document.updatedAt.toDisplayDate(),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            TextButton.icon(
              onPressed: onRename,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Rename'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
            ),
          ],
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(label),
      labelStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: theme.colorScheme.outline),
      backgroundColor: Colors.white,
    );
  }
}
