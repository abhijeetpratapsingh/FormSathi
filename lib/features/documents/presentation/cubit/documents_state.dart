import 'package:equatable/equatable.dart';

import '../../../../core/enums/document_category.dart';
import '../../domain/entities/saved_document.dart';

enum DocumentsViewMode { grid, list }

class DocumentsState extends Equatable {
  const DocumentsState({
    this.documents = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.viewMode = DocumentsViewMode.grid,
    this.isLoading = false,
    this.isProcessing = false,
    this.feedbackMessage,
    this.errorMessage,
  });

  final List<SavedDocument> documents;
  final DocumentCategory? selectedCategory;
  final String searchQuery;
  final DocumentsViewMode viewMode;
  final bool isLoading;
  final bool isProcessing;
  final String? feedbackMessage;
  final String? errorMessage;

  List<SavedDocument> get filteredDocuments {
    final query = searchQuery.trim().toLowerCase();
    return documents.where((document) {
      final matchesCategory =
          selectedCategory == null || document.category == selectedCategory;
      final matchesSearch = query.isEmpty ||
          document.title.toLowerCase().contains(query) ||
          document.category.label.toLowerCase().contains(query);
      return matchesCategory && matchesSearch;
    }).toList(growable: false);
  }

  DocumentsState copyWith({
    List<SavedDocument>? documents,
    DocumentCategory? selectedCategory,
    bool clearSelectedCategory = false,
    String? searchQuery,
    DocumentsViewMode? viewMode,
    bool? isLoading,
    bool? isProcessing,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return DocumentsState(
      documents: documents ?? this.documents,
      selectedCategory:
          clearSelectedCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      viewMode: viewMode ?? this.viewMode,
      isLoading: isLoading ?? this.isLoading,
      isProcessing: isProcessing ?? this.isProcessing,
      feedbackMessage:
          clearFeedbackMessage ? null : (feedbackMessage ?? this.feedbackMessage),
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        documents,
        selectedCategory,
        searchQuery,
        viewMode,
        isLoading,
        isProcessing,
        feedbackMessage,
        errorMessage,
      ];
}
