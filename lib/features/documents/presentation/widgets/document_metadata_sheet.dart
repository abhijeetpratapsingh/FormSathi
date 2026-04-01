import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/document_category.dart';

class DocumentMetadataSheet extends StatefulWidget {
  const DocumentMetadataSheet({
    required this.initialTitle,
    required this.initialCategory,
    super.key,
  });

  final String initialTitle;
  final DocumentCategory initialCategory;

  @override
  State<DocumentMetadataSheet> createState() => _DocumentMetadataSheetState();
}

class _DocumentMetadataSheetState extends State<DocumentMetadataSheet> {
  late final TextEditingController _titleController;
  late DocumentCategory _category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _category = widget.initialCategory;
  }

  @override
  void dispose() {
    _titleController.dispose();
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
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
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
              const SizedBox(height: AppSizes.lg),
              FilledButton(
                onPressed: () {
                  final title = _titleController.text.trim();
                  Navigator.of(context).pop<DocumentMetadataResult>(
                    DocumentMetadataResult(title: title, category: _category),
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
  });

  final String title;
  final DocumentCategory category;
}
