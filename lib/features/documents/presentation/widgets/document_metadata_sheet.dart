import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/document_category.dart';
import '../../../../core/enums/document_side.dart';
import '../../../../core/enums/document_type.dart';

class DocumentMetadataSheet extends StatefulWidget {
  const DocumentMetadataSheet({
    required this.initialTitle,
    required this.initialCategory,
    this.initialType = DocumentType.other,
    this.initialSide = DocumentSide.none,
    this.initialNotes = '',
    super.key,
  });

  final String initialTitle;
  final DocumentCategory initialCategory;
  final DocumentType initialType;
  final DocumentSide initialSide;
  final String initialNotes;

  @override
  State<DocumentMetadataSheet> createState() => _DocumentMetadataSheetState();
}

class _DocumentMetadataSheetState extends State<DocumentMetadataSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;
  late DocumentCategory _category;
  late DocumentType _type;
  late DocumentSide _side;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _notesController = TextEditingController(text: widget.initialNotes);
    _category = widget.initialCategory;
    _type = widget.initialType;
    _side = widget.initialSide;
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSizes.md,
            right: AppSizes.md,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.md,
            top: AppSizes.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Save document',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              TextField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Example: Passport Photo',
                ),
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<DocumentType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: [
                  for (final type in DocumentType.values)
                    DropdownMenuItem(value: type, child: Text(type.label)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _type = value;
                      _side = value.requiresSide
                          ? DocumentSide.front
                          : DocumentSide.none;
                    });
                  }
                },
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<DocumentCategory>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  for (final category in DocumentCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),
              if (_type.requiresSide) ...[
                const SizedBox(height: AppSizes.md),
                DropdownButtonFormField<DocumentSide>(
                  initialValue: _side,
                  decoration: const InputDecoration(labelText: 'Side'),
                  items: [
                    for (final side in _type.allowedSides)
                      DropdownMenuItem(value: side, child: Text(side.label)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _side = value);
                  },
                ),
              ],
              const SizedBox(height: AppSizes.md),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: AppSizes.lg),
              FilledButton(
                onPressed: () {
                  final title = _titleController.text.trim();
                  Navigator.of(context).pop<DocumentMetadataResult>(
                    DocumentMetadataResult(
                      title: title,
                      category: _category,
                      documentType: _type,
                      side: _side,
                      notes: _notesController.text.trim(),
                    ),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DocumentMetadataResult {
  const DocumentMetadataResult({
    required this.title,
    required this.category,
    required this.documentType,
    required this.side,
    required this.notes,
  });

  final String title;
  final DocumentCategory category;
  final DocumentType documentType;
  final DocumentSide side;
  final String notes;
}
