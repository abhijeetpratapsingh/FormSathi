import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/enums/document_category.dart';
import '../../domain/entities/saved_document.dart';
import '../cubit/documents_cubit.dart';
import '../cubit/documents_state.dart';
import '../widgets/document_card.dart';
import '../widgets/document_category_filter_bar.dart';
import '../widgets/document_empty_state.dart';
import '../widgets/document_metadata_sheet.dart';
import '../widgets/document_view_mode_toggle.dart';
import 'document_preview_page.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({
    required this.cubit,
    super.key,
  });

  final DocumentsCubit cubit;

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    widget.cubit.loadDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: BlocConsumer<DocumentsCubit, DocumentsState>(
        listenWhen: (previous, current) =>
            previous.feedbackMessage != current.feedbackMessage ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          final messenger = ScaffoldMessenger.of(context);
          if (state.feedbackMessage != null) {
            messenger.showSnackBar(SnackBar(content: Text(state.feedbackMessage!)));
            context.read<DocumentsCubit>().clearFeedback();
          } else if (state.errorMessage != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
            context.read<DocumentsCubit>().clearFeedback();
          }
        },
        builder: (context, state) {
          final cubit = context.read<DocumentsCubit>();
          return Scaffold(
            appBar: AppBar(
              title: const Text('My Documents'),
              actions: [
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: state.isLoading ? null : cubit.loadDocuments,
                  icon: const Icon(Icons.refresh_rounded),
                ),
                const SizedBox(width: 4),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: state.isProcessing ? null : () => _showAddSheet(context, cubit),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add'),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionCard(
                      gradient: AppColors.primaryGradient(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Documents',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppStrings.documentsEmpty,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    TextField(
                      onChanged: cubit.setSearchQuery,
                      decoration: const InputDecoration(
                        hintText: 'Search documents',
                        prefixIcon: Icon(Icons.search_rounded),
                      ),
                    ),
                    const SizedBox(height: AppSizes.md),
                    Row(
                      children: [
                        Expanded(
                          child: DocumentViewModeToggle(
                            viewMode: state.viewMode,
                            onToggle: cubit.toggleViewMode,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.md),
                    DocumentCategoryFilterBar(
                      selectedCategory: state.selectedCategory,
                      onSelected: cubit.setCategoryFilter,
                    ),
                    const SizedBox(height: AppSizes.md),
                    if (state.isLoading) const LinearProgressIndicator(minHeight: 2),
                    if (state.isLoading) const SizedBox(height: AppSizes.md),
                    if (state.isProcessing) const LinearProgressIndicator(minHeight: 2),
                    if (state.isProcessing) const SizedBox(height: AppSizes.md),
                    Expanded(
                      child: _buildContent(context, state, cubit),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, DocumentsState state, DocumentsCubit cubit) {
    final documents = state.filteredDocuments;
    if (state.isLoading && state.documents.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (documents.isEmpty) {
      return DocumentEmptyState(
        searching: state.searchQuery.isNotEmpty || state.selectedCategory != null,
      );
    }

    if (state.viewMode == DocumentsViewMode.list) {
      return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: documents.length,
        separatorBuilder: (context, index) => const SizedBox(height: AppSizes.md),
        itemBuilder: (context, index) {
          final document = documents[index];
          return DocumentCard(
            document: document,
            compact: true,
            onTap: () => _openPreview(context, document, cubit),
            onRename: () => _renameDocument(context, document, cubit),
            onDelete: () => _deleteDocument(context, document, cubit),
          );
        },
      );
    }

    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.md,
        crossAxisSpacing: AppSizes.md,
        childAspectRatio: 0.6,
      ),
      itemCount: documents.length,
      itemBuilder: (context, index) {
        final document = documents[index];
        return DocumentCard(
          document: document,
          onTap: () => _openPreview(context, document, cubit),
          onRename: () => _renameDocument(context, document, cubit),
          onDelete: () => _deleteDocument(context, document, cubit),
        );
      },
    );
  }

  Future<void> _showAddSheet(BuildContext context, DocumentsCubit cubit) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_rounded),
                  title: const Text('Camera'),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_rounded),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission is required to capture images.')),
        );
        return;
      }
    }

    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 100,
    );
    if (picked == null) return;

    if (!context.mounted) return;
    final metadata = await showModalBottomSheet<DocumentMetadataResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final initialTitle = _fallbackTitleFromPath(picked.path);
        return DocumentMetadataSheet(
          initialTitle: initialTitle,
          initialCategory: DocumentCategory.other,
        );
      },
    );

    if (metadata == null) return;
    await cubit.addDocument(
      sourcePath: picked.path,
      title: metadata.title,
      category: metadata.category,
    );
  }

  Future<void> _renameDocument(
    BuildContext context,
    SavedDocument document,
    DocumentsCubit cubit,
  ) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return _RenameDocumentDialog(initialTitle: document.title);
      },
    );

    if (!context.mounted || result == null) return;
    await cubit.renameDocument(document: document, newTitle: result);
  }

  Future<void> _deleteDocument(
    BuildContext context,
    SavedDocument document,
    DocumentsCubit cubit,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete document?'),
          content: Text('This will remove "${document.title}" from local storage.'),
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
  }

  void _openPreview(BuildContext context, SavedDocument document, DocumentsCubit cubit) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: DocumentPreviewPage(
            documentId: document.id,
          ),
        ),
      ),
    );
  }

  String _fallbackTitleFromPath(String path) {
    final fileName = path.split('/').last;
    final index = fileName.lastIndexOf('.');
    return index == -1 ? fileName : fileName.substring(0, index);
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
