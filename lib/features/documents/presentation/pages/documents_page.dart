import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/document_type.dart';
import '../../../../core/services/local_file_service.dart';
import '../../../../core/widgets/app_top_header.dart';
import '../../domain/entities/saved_document.dart';
import '../cubit/documents_cubit.dart';
import '../cubit/documents_state.dart';
import '../widgets/document_card.dart';
import '../widgets/document_category_filter_bar.dart';
import '../widgets/document_empty_state.dart';
import '../widgets/document_metadata_review_sheet.dart';
import '../widgets/document_source_picker_sheet.dart';
import '../widgets/document_type_picker_sheet.dart';
import '../widgets/document_view_mode_toggle.dart';
import 'document_preview_page.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({required this.cubit, super.key});

  final DocumentsCubit cubit;

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    widget.cubit.loadDocuments();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
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
            messenger.showSnackBar(
              SnackBar(content: Text(state.feedbackMessage!)),
            );
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
            appBar: AppTopHeader(
              title: 'Docs',
              automaticallyImplyLeading: false,
              titleWidget: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: _isSearchExpanded
                    ? _TopSearchField(
                        key: const ValueKey('documents-top-search'),
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: cubit.setSearchQuery,
                        onClose: () => _collapseSearch(cubit),
                      )
                    : const Text(
                        'Docs',
                        key: ValueKey('documents-title'),
                      ),
              ),
              titleSpacing: _isSearchExpanded ? AppSizes.md : null,
              secondaryActions: _isSearchExpanded
                  ? []
                  : [
                      IconButton(
                        tooltip: 'Search documents',
                        onPressed: () => _expandSearch(),
                        constraints: const BoxConstraints(
                          minWidth: AppSizes.minTouchTarget,
                          minHeight: AppSizes.minTouchTarget,
                        ),
                        icon: const Icon(Icons.search_rounded, size: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: AppSizes.sm),
                        child: DocumentViewModeToggle(
                          viewMode: state.viewMode,
                          onToggle: cubit.toggleViewMode,
                        ),
                      ),
                    ],
            ),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Add document',
              onPressed: state.isProcessing
                  ? null
                  : () => _showAddSheet(context, cubit),
              elevation: 3,
              shape: const CircleBorder(),
              child: const Icon(Icons.add_rounded),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DocumentCategoryFilterBar(
                      selectedType: state.selectedTypeFilter,
                      onSelected: cubit.setTypeFilter,
                    ),
                    const SizedBox(height: AppSizes.md),
                    if (state.isLoading)
                      const LinearProgressIndicator(minHeight: 2),
                    if (state.isLoading) const SizedBox(height: AppSizes.md),
                    if (state.isProcessing)
                      const LinearProgressIndicator(minHeight: 2),
                    if (state.isProcessing) const SizedBox(height: AppSizes.md),
                    Expanded(child: _buildContent(context, state, cubit)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _expandSearch() {
    _searchController.text = widget.cubit.state.searchQuery;
    setState(() {
      _isSearchExpanded = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _searchFocusNode.requestFocus();
    });
  }

  void _collapseSearch(DocumentsCubit cubit) {
    _searchController.clear();
    cubit.setSearchQuery('');
    _searchFocusNode.unfocus();
    setState(() {
      _isSearchExpanded = false;
    });
  }

  Widget _buildContent(
    BuildContext context,
    DocumentsState state,
    DocumentsCubit cubit,
  ) {
    final documents = state.filteredDocuments;
    if (state.isLoading && state.documents.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (documents.isEmpty) {
      return DocumentEmptyState(
        searching:
            state.searchQuery.isNotEmpty || state.selectedTypeFilter != null,
      );
    }

    if (state.viewMode == DocumentsViewMode.list) {
      return ListView.separated(
        padding: const EdgeInsets.only(bottom: AppSizes.xl * 3),
        physics: const BouncingScrollPhysics(),
        itemCount: documents.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSizes.md),
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
      padding: const EdgeInsets.only(bottom: AppSizes.xl * 3),
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
    final type = await showModalBottomSheet<DocumentType>(
      context: context,
      showDragHandle: true,
      builder: (context) => const DocumentTypePickerSheet(),
    );
    if (type == null) return;
    cubit.selectDocumentType(type);

    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final source = await showModalBottomSheet<DocumentSourceChoice>(
      context: context,
      showDragHandle: true,
      builder: (context) => DocumentSourcePickerSheet(documentType: type),
    );
    if (source == null) return;

    final sourcePath = await _pickSourcePath(messenger, type, source);
    if (sourcePath == null) return;
    cubit.selectSourcePath(sourcePath);

    final fileMetadata = await LocalFileServiceMetadataReader.read(sourcePath);
    if (!context.mounted) return;
    final metadata = await showModalBottomSheet<DocumentMetadataReviewResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return DocumentMetadataReviewSheet(
          documentType: type,
          sourcePath: sourcePath,
          metadata: fileMetadata,
          initialTitle: type.defaultTitle,
        );
      },
    );

    if (metadata == null) return;
    cubit.updateDraftMetadata(side: metadata.side, notes: metadata.notes);
    await cubit.addTypedDocument(
      sourcePath: sourcePath,
      title: metadata.title,
      documentType: type,
      side: metadata.side,
      notes: metadata.notes,
    );
  }

  Future<String?> _pickSourcePath(
    ScaffoldMessengerState messenger,
    DocumentType type,
    DocumentSourceChoice source,
  ) async {
    if (source == DocumentSourceChoice.file) {
      final result = await FilePicker.pickFiles(
        type: type == DocumentType.resume ? FileType.custom : FileType.any,
        allowedExtensions: type == DocumentType.resume ? const ['pdf'] : null,
      );
      return result?.files.single.path;
    }

    final imageSource = source == DocumentSourceChoice.camera
        ? ImageSource.camera
        : ImageSource.gallery;
    if (imageSource == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to capture images.'),
          ),
        );
        return null;
      }
    }

    final picked = await _imagePicker.pickImage(
      source: imageSource,
      imageQuality: 100,
    );
    return picked?.path;
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
          content: Text(
            'This will remove "${document.title}" from local storage.',
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
  }

  void _openPreview(
    BuildContext context,
    SavedDocument document,
    DocumentsCubit cubit,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: DocumentPreviewPage(documentId: document.id),
        ),
      ),
    );
  }
}

class _TopSearchField extends StatelessWidget {
  const _TopSearchField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClose,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.minTouchTarget,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search documents',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: IconButton(
            tooltip: 'Close search',
            onPressed: onClose,
            constraints: const BoxConstraints(
              minWidth: AppSizes.minTouchTarget,
              minHeight: AppSizes.minTouchTarget,
            ),
            icon: const Icon(Icons.close_rounded),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.sm),
        ),
      ),
    );
  }
}

class LocalFileServiceMetadataReader {
  const LocalFileServiceMetadataReader._();

  static Future<FileMetadata> read(String path) async {
    final file = File(path);
    final bytes = await file.readAsBytes();
    return FileMetadata(
      fileSizeBytes: bytes.length,
      originalFileName: file.uri.pathSegments.last,
      mimeType: _mimeType(path),
    );
  }

  static String _mimeType(String path) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
    return 'application/octet-stream';
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
