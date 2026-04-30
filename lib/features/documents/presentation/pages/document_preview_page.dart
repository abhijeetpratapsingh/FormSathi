import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/di.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/export_preset.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../tools/domain/usecases/export_saved_document_usecase.dart';
import '../../../tools/presentation/cubit/smart_export_cubit.dart';
import '../../../tools/presentation/cubit/smart_export_state.dart';
import '../../../tools/presentation/widgets/export_result_sheet.dart';
import '../../domain/entities/saved_document.dart';
import '../cubit/documents_cubit.dart';
import '../cubit/documents_state.dart';

class DocumentPreviewPage extends StatelessWidget {
  const DocumentPreviewPage({required this.documentId, super.key});

  final String documentId;

  @override
  Widget build(BuildContext context) {
    final documentsCubit = context.read<DocumentsCubit>();
    return BlocProvider(
      create: (_) =>
          SmartExportCubit(exportUseCase: sl<ExportSavedDocumentUseCase>()),
      child: BlocListener<SmartExportCubit, SmartExportState>(
        listener: (context, exportState) {
          if (exportState.result != null) {
            showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              builder: (_) => ExportResultSheet(file: exportState.result!),
            );
            context.read<SmartExportCubit>().clearResult();
          } else if (exportState.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(exportState.errorMessage!)));
          }
        },
        child: BlocBuilder<DocumentsCubit, DocumentsState>(
          bloc: documentsCubit,
          builder: (context, state) {
            final document = _currentDocument(state.documents);
            if (document == null) {
              return const Scaffold(
                body: Center(child: Text('Document not found')),
              );
            }

            return _DocumentPreviewContent(
              state: state,
              document: document,
              onRename: () =>
                  _renameDocument(context, documentsCubit, document),
              onDelete: () =>
                  _deleteDocument(context, documentsCubit, document),
              onExport: (preset) =>
                  context.read<SmartExportCubit>().exportDocument(
                    document: document,
                    preset: preset,
                    relatedDocuments: _relatedSideDocuments(
                      state.documents,
                      document,
                    ),
                  ),
              onShareOriginal: () => _shareOriginal(document),
            );
          },
        ),
      ),
    );
  }

  SavedDocument? _currentDocument(List<SavedDocument> documents) {
    for (final document in documents) {
      if (document.id == documentId) return document;
    }
    return null;
  }

  List<SavedDocument> _relatedSideDocuments(
    List<SavedDocument> documents,
    SavedDocument document,
  ) {
    if (!document.documentType.requiresSide) return const [];
    return documents
        .where(
          (item) =>
              item.id != document.id &&
              item.documentType == document.documentType &&
              item.side != document.side,
        )
        .take(1)
        .toList(growable: false);
  }

  void _shareOriginal(SavedDocument document) {
    SharePlus.instance.share(ShareParams(files: [XFile(document.localPath)]));
  }

  Future<void> _renameDocument(
    BuildContext context,
    DocumentsCubit cubit,
    SavedDocument document,
  ) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _RenameDocumentDialog(initialTitle: document.title),
    );
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
          content: Text(
            'This will remove "${document.title}" from your device.',
          ),
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

class _DocumentPreviewContent extends StatelessWidget {
  const _DocumentPreviewContent({
    required this.state,
    required this.document,
    required this.onRename,
    required this.onDelete,
    required this.onExport,
    required this.onShareOriginal,
  });

  final DocumentsState state;
  final SavedDocument document;
  final VoidCallback onRename;
  final VoidCallback onDelete;
  final ValueChanged<ExportPreset> onExport;
  final VoidCallback onShareOriginal;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SmartExportCubit, SmartExportState>(
      builder: (context, exportState) {
        final busy = state.isProcessing || exportState.isProcessing;
        return Scaffold(
          appBar: AppBar(
            title: Text(document.title),
            actions: [
              IconButton(
                tooltip: 'Rename',
                onPressed: busy ? null : onRename,
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                tooltip: 'Delete',
                onPressed: busy ? null : onDelete,
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
                  if (busy) const LinearProgressIndicator(minHeight: 2),
                  if (busy) const SizedBox(height: AppSizes.md),
                  Hero(
                    tag: document.id,
                    child: ClipRRect(
                      borderRadius: AppSizes.cardRadius,
                      child: Container(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        height: 320,
                        alignment: Alignment.center,
                        child: _previewImage(document.localPath),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.lg),
                  _TypedMetadataCard(document: document),
                  const SizedBox(height: AppSizes.lg),
                  if (document.documentType.exportPresets.isNotEmpty) ...[
                    Text(
                      'Smart exports',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSizes.sm),
                    for (final preset in document.documentType.exportPresets)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.sm),
                        child: FilledButton.icon(
                          onPressed: busy ? null : () => onExport(preset),
                          icon: const Icon(Icons.auto_awesome_outlined),
                          label: Text(preset.label),
                        ),
                      ),
                    const SizedBox(height: AppSizes.md),
                  ],
                  FilledButton.tonalIcon(
                    onPressed: busy ? null : onShareOriginal,
                    icon: const Icon(Icons.ios_share_rounded),
                    label: const Text('Share original'),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  FilledButton.icon(
                    onPressed: busy ? null : onRename,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Rename'),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  FilledButton.tonalIcon(
                    onPressed: busy ? null : onDelete,
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

  Widget _previewImage(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      return const Icon(Icons.broken_image_outlined, size: 48);
    }
    return Image.file(
      file,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.insert_drive_file_outlined, size: 48),
    );
  }
}

class _TypedMetadataCard extends StatelessWidget {
  const _TypedMetadataCard({required this.document});

  final SavedDocument document;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MetaRow(label: 'Title', value: document.title),
            const SizedBox(height: AppSizes.md),
            _MetaRow(label: 'Type', value: document.documentType.label),
            const SizedBox(height: AppSizes.md),
            _MetaRow(label: 'Category', value: document.category.label),
            const SizedBox(height: AppSizes.md),
            if (document.side.label != 'None') ...[
              _MetaRow(label: 'Side', value: document.side.label),
              const SizedBox(height: AppSizes.md),
            ],
            _MetaRow(
              label: 'Size',
              value: FileSizeFormatter.format(document.fileSizeBytes),
            ),
            const SizedBox(height: AppSizes.md),
            if (document.width != null && document.height != null) ...[
              _MetaRow(
                label: 'Dimensions',
                value: '${document.width} x ${document.height}',
              ),
              const SizedBox(height: AppSizes.md),
            ],
            if (document.notes.isNotEmpty) ...[
              _MetaRow(label: 'Notes', value: document.notes),
              const SizedBox(height: AppSizes.md),
            ],
            _MetaRow(
              label: 'Created',
              value: document.createdAt.toDateTimeLabel(),
            ),
            const SizedBox(height: AppSizes.md),
            _MetaRow(
              label: 'Updated',
              value: document.updatedAt.toDateTimeLabel(),
            ),
            const SizedBox(height: AppSizes.md),
            _MetaRow(label: 'Local path', value: document.localPath),
          ],
        ),
      ),
    );
  }
}

class _RenameDocumentDialog extends StatefulWidget {
  const _RenameDocumentDialog({required this.initialTitle});

  final String initialTitle;

  @override
  State<_RenameDocumentDialog> createState() => _RenameDocumentDialogState();
}

class _RenameDocumentDialogState extends State<_RenameDocumentDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialTitle);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename document'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Document title'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, required this.value});

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
        SelectableText(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
