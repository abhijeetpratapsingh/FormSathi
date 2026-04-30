import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/enums/document_category.dart';
import '../../../../core/enums/document_side.dart';
import '../../../../core/enums/document_type.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/local_file_service.dart';
import '../../domain/entities/saved_document.dart';
import '../../domain/usecases/delete_document_usecase.dart';
import '../../domain/usecases/get_documents_usecase.dart';
import '../../domain/usecases/save_document_usecase.dart';
import '../../domain/usecases/update_document_usecase.dart';
import 'documents_state.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit({
    required GetDocumentsUseCase getDocumentsUseCase,
    required SaveDocumentUseCase saveDocumentUseCase,
    required UpdateDocumentUseCase updateDocumentUseCase,
    required DeleteDocumentUseCase deleteDocumentUseCase,
    required LocalFileService localFileService,
  }) : _getDocumentsUseCase = getDocumentsUseCase,
       _saveDocumentUseCase = saveDocumentUseCase,
       _updateDocumentUseCase = updateDocumentUseCase,
       _deleteDocumentUseCase = deleteDocumentUseCase,
       _localFileService = localFileService,
       super(const DocumentsState());

  final GetDocumentsUseCase _getDocumentsUseCase;
  final SaveDocumentUseCase _saveDocumentUseCase;
  final UpdateDocumentUseCase _updateDocumentUseCase;
  final DeleteDocumentUseCase _deleteDocumentUseCase;
  final LocalFileService _localFileService;
  final Uuid _uuid = const Uuid();

  Future<void> loadDocuments() async {
    emit(
      state.copyWith(
        isLoading: true,
        clearFeedbackMessage: true,
        clearErrorMessage: true,
      ),
    );
    try {
      final documents = await _getDocumentsUseCase();
      emit(state.copyWith(documents: documents, isLoading: false));
    } catch (error) {
      emit(
        state.copyWith(isLoading: false, errorMessage: _resolveError(error)),
      );
    }
  }

  void setSearchQuery(String value) {
    emit(state.copyWith(searchQuery: value));
  }

  void setCategoryFilter(DocumentCategory? category) {
    if (category == null) {
      emit(state.copyWith(clearSelectedCategory: true));
      return;
    }
    emit(state.copyWith(selectedCategory: category));
  }

  void setTypeFilter(DocumentType? type) {
    if (type == null) {
      emit(state.copyWith(clearSelectedTypeFilter: true));
      return;
    }
    emit(state.copyWith(selectedTypeFilter: type));
  }

  void selectDocumentType(DocumentType type) {
    emit(
      state.copyWith(
        selectedType: type,
        selectedSide: type.requiresSide
            ? DocumentSide.front
            : DocumentSide.none,
        selectedNotes: '',
        clearSelectedSourcePath: true,
        clearFeedbackMessage: true,
        clearErrorMessage: true,
      ),
    );
  }

  void selectSourcePath(String sourcePath) {
    emit(state.copyWith(selectedSourcePath: sourcePath));
  }

  void updateDraftMetadata({DocumentSide? side, String? notes}) {
    emit(state.copyWith(selectedSide: side, selectedNotes: notes));
  }

  void clearDraft() {
    emit(
      state.copyWith(
        clearSelectedType: true,
        clearSelectedSourcePath: true,
        selectedSide: DocumentSide.none,
        selectedNotes: '',
      ),
    );
  }

  void toggleViewMode() {
    emit(
      state.copyWith(
        viewMode: state.viewMode == DocumentsViewMode.grid
            ? DocumentsViewMode.list
            : DocumentsViewMode.grid,
      ),
    );
  }

  Future<void> addDocument({
    required String sourcePath,
    required String title,
    required DocumentCategory category,
  }) async {
    await addTypedDocument(
      sourcePath: sourcePath,
      title: title,
      documentType: _documentTypeForCategory(category),
      side: DocumentSide.none,
    );
  }

  Future<void> addTypedDocument({
    required String sourcePath,
    required String title,
    required DocumentType documentType,
    DocumentSide? side,
    String notes = '',
  }) async {
    emit(
      state.copyWith(
        isProcessing: true,
        clearFeedbackMessage: true,
        clearErrorMessage: true,
      ),
    );
    String? copiedPath;
    try {
      final category = _categoryForDocumentType(documentType);
      final normalizedTitle = _normalizeTitle(title, category);
      final fileMetadata = await _localFileService.metadata(sourcePath);
      final fileName = _buildFileName(documentType, sourcePath);
      copiedPath = await _localFileService.saveDocumentCopy(
        sourcePath: sourcePath,
        fileName: fileName,
      );
      final now = DateTime.now();
      final document = SavedDocument(
        id: _uuid.v4(),
        title: normalizedTitle,
        category: category,
        documentType: documentType,
        localPath: copiedPath,
        originalFileName: fileMetadata.originalFileName,
        mimeType: fileMetadata.mimeType,
        fileSizeBytes: fileMetadata.fileSizeBytes,
        width: fileMetadata.width,
        height: fileMetadata.height,
        pageCount: fileMetadata.mimeType == 'application/pdf' ? 1 : null,
        side: side ?? DocumentSide.none,
        notes: notes.trim(),
        createdAt: now,
        updatedAt: now,
      );
      await _saveDocumentUseCase(document);
      final updatedDocuments = [...state.documents, document]
        ..sort(_sortByRecent);
      emit(
        state.copyWith(
          documents: updatedDocuments,
          isProcessing: false,
          clearSelectedType: true,
          clearSelectedSourcePath: true,
          selectedSide: DocumentSide.none,
          selectedNotes: '',
          feedbackMessage: 'Document saved',
        ),
      );
    } catch (error) {
      if (copiedPath != null) {
        try {
          await _localFileService.deleteFile(copiedPath);
        } catch (_) {
          // Ignore cleanup failures so the original error is preserved.
        }
      }
      emit(
        state.copyWith(isProcessing: false, errorMessage: _resolveError(error)),
      );
    }
  }

  Future<void> renameDocument({
    required SavedDocument document,
    required String newTitle,
  }) async {
    final normalizedTitle = _normalizeTitle(newTitle, document.category);
    if (normalizedTitle == document.title) {
      emit(state.copyWith(feedbackMessage: 'No changes made'));
      return;
    }
    emit(
      state.copyWith(
        isProcessing: true,
        clearFeedbackMessage: true,
        clearErrorMessage: true,
      ),
    );
    try {
      final updated = document.copyWith(
        title: normalizedTitle,
        updatedAt: DateTime.now(),
      );
      await _updateDocumentUseCase(updated);
      _replaceDocument(updated);
      emit(
        state.copyWith(
          isProcessing: false,
          feedbackMessage: 'Document renamed',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isProcessing: false, errorMessage: _resolveError(error)),
      );
    }
  }

  Future<void> deleteDocument(SavedDocument document) async {
    emit(
      state.copyWith(
        isProcessing: true,
        clearFeedbackMessage: true,
        clearErrorMessage: true,
      ),
    );
    try {
      await _deleteDocumentUseCase(document.id);
      await _localFileService.deleteFile(document.localPath);
      final updatedDocuments = state.documents
          .where((item) => item.id != document.id)
          .toList(growable: false);
      emit(
        state.copyWith(
          documents: updatedDocuments,
          isProcessing: false,
          feedbackMessage: 'Document deleted',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(isProcessing: false, errorMessage: _resolveError(error)),
      );
    }
  }

  void clearFeedback() {
    if (state.feedbackMessage != null || state.errorMessage != null) {
      emit(state.copyWith(clearFeedbackMessage: true, clearErrorMessage: true));
    }
  }

  void _replaceDocument(SavedDocument document) {
    final nextDocuments =
        state.documents
            .map((item) {
              if (item.id == document.id) {
                return document;
              }
              return item;
            })
            .toList(growable: false)
          ..sort(_sortByRecent);

    emit(state.copyWith(documents: nextDocuments));
  }

  String _normalizeTitle(String title, DocumentCategory category) {
    final trimmed = title.trim();
    if (trimmed.isNotEmpty) return trimmed;
    return category.label;
  }

  String _buildFileName(DocumentType documentType, String sourcePath) {
    final extension = _extractExtension(sourcePath);
    final baseLabel = documentType.label;
    final safeLabel = baseLabel
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    final platform = Platform.operatingSystem;
    final device = _sanitizeDeviceName(Platform.localHostname);
    final date = _formatDate(DateTime.now());
    final baseName = safeLabel.isEmpty ? 'document' : safeLabel;
    return '$baseName-$platform-$device-$date$extension';
  }

  DocumentCategory _categoryForDocumentType(DocumentType type) {
    return switch (type) {
      DocumentType.signature => DocumentCategory.signature,
      DocumentType.passportPhoto => DocumentCategory.passportPhoto,
      DocumentType.aadhaar => DocumentCategory.aadhaar,
      DocumentType.pan => DocumentCategory.pan,
      DocumentType.marksheet => DocumentCategory.marksheet,
      DocumentType.certificate => DocumentCategory.certificate,
      DocumentType.resume => DocumentCategory.other,
      DocumentType.other => DocumentCategory.other,
    };
  }

  DocumentType _documentTypeForCategory(DocumentCategory category) {
    return switch (category) {
      DocumentCategory.signature => DocumentType.signature,
      DocumentCategory.passportPhoto => DocumentType.passportPhoto,
      DocumentCategory.aadhaar => DocumentType.aadhaar,
      DocumentCategory.pan => DocumentType.pan,
      DocumentCategory.marksheet => DocumentType.marksheet,
      DocumentCategory.certificate => DocumentType.certificate,
      DocumentCategory.idProof => DocumentType.other,
      DocumentCategory.other => DocumentType.other,
    };
  }

  String _formatDate(DateTime dateTime) {
    final year = dateTime.year.toString();
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    return '$year$month$day';
  }

  String _sanitizeDeviceName(String input) {
    final safe = input
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
    return safe.isEmpty ? 'device' : safe;
  }

  String _extractExtension(String path) {
    final fileName = path.split('/').last;
    final index = fileName.lastIndexOf('.');
    if (index == -1 || index == fileName.length - 1) {
      return '.jpg';
    }
    return fileName.substring(index);
  }

  int _sortByRecent(SavedDocument a, SavedDocument b) =>
      b.updatedAt.compareTo(a.updatedAt);

  String _resolveError(Object error) {
    if (error is AppException) return error.message;
    return 'Something went wrong. Please try again.';
  }
}
