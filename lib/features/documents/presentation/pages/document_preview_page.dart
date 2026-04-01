import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/entities/saved_document.dart';
import '../cubit/documents_cubit.dart';
import '../cubit/documents_state.dart';

class DocumentPreviewPage extends StatelessWidget {
  const DocumentPreviewPage({
    required this.documentId,
    super.key,
  });

  final String documentId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DocumentsCubit>();
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      bloc: cubit,
      builder: (context, state) {
        final document = _currentDocument(state.documents);
        if (document == null) {
          return const Scaffold(
            body: Center(
              child: Text('Document not found'),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(document.title),
            actions: [
              IconButton(
                tooltip: 'Rename',
                onPressed: state.isProcessing ? null : () => _renameDocument(context, cubit, document),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: state.isProcessing ? null : () => _deleteDocument(context, cubit, document),
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: document.id,
                    child: ClipRRect(
                      borderRadius: AppSizes.cardRadius,
                      child: Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        height: 320,
                        alignment: Alignment.center,
                        child: _previewImage(document.localPath),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSizes.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _MetaRow(label: 'Title', value: document.title),
                          const SizedBox(height: AppSizes.md),
                          _MetaRow(label: 'Category', value: document.category.label),
                          const SizedBox(height: AppSizes.md),
                          _MetaRow(label: 'Created', value: document.createdAt.toDateTimeLabel()),
                          const SizedBox(height: AppSizes.md),
                          _MetaRow(label: 'Updated', value: document.updatedAt.toDateTimeLabel()),
                          const SizedBox(height: AppSizes.md),
                          _MetaRow(label: 'Local path', value: document.localPath),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  FilledButton.icon(
                    onPressed: state.isProcessing
                        ? null
                        : () => _renameDocument(context, cubit, document),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Rename'),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  FilledButton.tonalIcon(
                    onPressed: state.isProcessing
                        ? null
                        : () => _deleteDocument(context, cubit, document),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  SavedDocument? _currentDocument(List<SavedDocument> documents) {
    for (final document in documents) {
      if (document.id == documentId) {
        return document;
      }
    }
    return null;
  }

  Widget _previewImage(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      return const Icon(Icons.broken_image_outlined, size: 48);
    }
    return Image.file(
      file,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image_outlined, size: 48),
    );
  }

  Future<void> _renameDocument(
    BuildContext context,
    DocumentsCubit cubit,
    SavedDocument document,
  ) async {
    final controller = TextEditingController(text: document.title);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename document'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(labelText: 'Document title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (result == null) return;
    await cubit.renameDocument(document: document, newTitle: result);
  }

  Future<void> _deleteDocument(
    BuildContext context,
    DocumentsCubit cubit,
    SavedDocument document,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete document?'),
          content: Text('This will remove "${document.title}" from your device.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton.tonal(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;
    await cubit.deleteDocument(document);
    if (cubit.state.errorMessage == null && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        SelectableText(
          value,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
