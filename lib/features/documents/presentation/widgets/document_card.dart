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
                  compactActions: true,
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
                compactActions: true,
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
    final height = fullWidth ? 110.0 : 82.0;
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
    required this.compactActions,
  });

  final SavedDocument document;
  final int size;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final bool compactActions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateText = document.updatedAt.toDisplayDate();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          document.title,
          maxLines: compactActions ? 1 : 2,
          overflow: TextOverflow.ellipsis,
          style: (compactActions ? theme.textTheme.titleSmall : theme.textTheme.titleMedium)
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        if (!compactActions) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(label: document.category.label, compact: false),
              _MetaChip(label: FileSizeFormatter.format(size), compact: false),
            ],
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            dateText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _ActionButton(
                icon: Icons.edit_outlined,
                label: 'Rename',
                onPressed: onRename,
                compact: false,
              ),
              _ActionButton(
                icon: Icons.delete_outline,
                label: 'Delete',
                onPressed: onDelete,
                compact: false,
              ),
            ],
          ),
        ] else
          _CompactMenu(
            onRename: onRename,
            onDelete: onDelete,
          ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.compact});

  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(label),
      labelStyle: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
      visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
      side: BorderSide(color: theme.colorScheme.outline),
      backgroundColor: Colors.white,
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: compact ? 16 : 18),
      label: Text(label, style: theme.textTheme.labelMedium),
      style: TextButton.styleFrom(
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        visualDensity: compact ? VisualDensity.compact : VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: const Size(0, 32),
      ),
    );
  }
}

class _CompactMenu extends StatelessWidget {
  const _CompactMenu({
    required this.onRename,
    required this.onDelete,
  });

  final VoidCallback onRename;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      onSelected: (value) {
        if (value == 'rename') {
          onRename();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'rename',
          child: Text('Rename'),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Text('Delete'),
        ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            'Actions',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
