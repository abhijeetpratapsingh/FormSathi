import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/document_side.dart';
import '../../../../core/enums/document_type.dart';
import '../../../../core/services/local_file_service.dart';
import '../../../../core/utils/file_size_formatter.dart';

class DocumentMetadataReviewSheet extends StatefulWidget {
  const DocumentMetadataReviewSheet({
    required this.documentType,
    required this.sourcePath,
    required this.metadata,
    required this.initialTitle,
    super.key,
  });

  final DocumentType documentType;
  final String sourcePath;
  final FileMetadata metadata;
  final String initialTitle;

  @override
  State<DocumentMetadataReviewSheet> createState() =>
      _DocumentMetadataReviewSheetState();
}

class _DocumentMetadataReviewSheetState
    extends State<DocumentMetadataReviewSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late DocumentSide _side;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _notesController = TextEditingController();
    _side = widget.documentType.requiresSide
        ? DocumentSide.front
        : DocumentSide.none;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dimensions = widget.metadata.width == null
        ? 'Unknown'
        : '${widget.metadata.width} x ${widget.metadata.height}';
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSizes.md,
            right: AppSizes.md,
            top: AppSizes.md,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Review document',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSizes.md),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Type'),
                child: Text(widget.documentType.label),
              ),
              const SizedBox(height: AppSizes.md),
              if (widget.documentType.requiresSide) ...[
                DropdownButtonFormField<DocumentSide>(
                  initialValue: _side,
                  decoration: const InputDecoration(labelText: 'Side'),
                  items: [
                    for (final side in widget.documentType.allowedSides)
                      DropdownMenuItem(value: side, child: Text(side.label)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _side = value);
                  },
                ),
                const SizedBox(height: AppSizes.md),
              ],
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Expiry, exam name, page detail',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: AppSizes.md),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: const Icon(Icons.storage_rounded, size: 18),
                    label: Text(
                      FileSizeFormatter.format(widget.metadata.fileSizeBytes),
                    ),
                  ),
                  Chip(
                    avatar: const Icon(Icons.aspect_ratio_rounded, size: 18),
                    label: Text(dimensions),
                  ),
                  Chip(
                    avatar: const Icon(Icons.insert_drive_file, size: 18),
                    label: Text(widget.metadata.mimeType),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(
                    DocumentMetadataReviewResult(
                      title: _titleController.text.trim(),
                      side: _side,
                      notes: _notesController.text.trim(),
                    ),
                  );
                },
                child: const Text('Save document'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentMetadataReviewResult {
  const DocumentMetadataReviewResult({
    required this.title,
    required this.side,
    required this.notes,
  });

  final String title;
  final DocumentSide side;
  final String notes;
}
