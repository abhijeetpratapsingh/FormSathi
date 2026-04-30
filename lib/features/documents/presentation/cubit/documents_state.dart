import 'package:equatable/equatable.dart';

import '../../../../core/enums/document_category.dart';
import '../../../../core/enums/document_side.dart';
import '../../../../core/enums/document_type.dart';
import '../../domain/entities/saved_document.dart';

enum DocumentsViewMode { grid, list }

class DocumentsState extends Equatable {
  const DocumentsState({
    this.documents = const [],
    this.selectedCategory,
    this.selectedTypeFilter,
    this.searchQuery = '',
    this.viewMode = DocumentsViewMode.grid,
    this.isLoading = false,
    this.isProcessing = false,
    this.isMigrating = false,
    this.selectedType,
    this.selectedSourcePath,
    this.selectedSide = DocumentSide.none,
    this.selectedNotes = '',
    this.feedbackMessage,
    this.errorMessage,
  });

  final List<SavedDocument> documents;
  final DocumentCategory? selectedCategory;
  final DocumentType? selectedTypeFilter;
  final String searchQuery;
  final DocumentsViewMode viewMode;
  final bool isLoading;
  final bool isProcessing;
  final bool isMigrating;
  final DocumentType? selectedType;
  final String? selectedSourcePath;
  final DocumentSide selectedSide;
  final String selectedNotes;
  final String? feedbackMessage;
  final String? errorMessage;

  List<SavedDocument> get filteredDocuments {
    final query = searchQuery.trim().toLowerCase();
    return documents
        .where((document) {
          final matchesCategory =
              selectedCategory == null || document.category == selectedCategory;
          final matchesType =
              selectedTypeFilter == null ||
              document.documentType == selectedTypeFilter;
          final matchesSearch =
              query.isEmpty ||
              document.title.toLowerCase().contains(query) ||
              document.category.label.toLowerCase().contains(query) ||
              document.documentType.label.toLowerCase().contains(query) ||
              document.notes.toLowerCase().contains(query);
          return matchesCategory && matchesType && matchesSearch;
        })
        .toList(growable: false);
  }

  DocumentsState copyWith({
    List<SavedDocument>? documents,
    DocumentCategory? selectedCategory,
    bool clearSelectedCategory = false,
    DocumentType? selectedTypeFilter,
    bool clearSelectedTypeFilter = false,
    String? searchQuery,
    DocumentsViewMode? viewMode,
    bool? isLoading,
    bool? isProcessing,
    bool? isMigrating,
    DocumentType? selectedType,
    bool clearSelectedType = false,
    String? selectedSourcePath,
    bool clearSelectedSourcePath = false,
    DocumentSide? selectedSide,
    String? selectedNotes,
    String? feedbackMessage,
    bool clearFeedbackMessage = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return DocumentsState(
      documents: documents ?? this.documents,
      selectedCategory: clearSelectedCategory
          ? null
          : (selectedCategory ?? this.selectedCategory),
      selectedTypeFilter: clearSelectedTypeFilter
          ? null
          : (selectedTypeFilter ?? this.selectedTypeFilter),
      searchQuery: searchQuery ?? this.searchQuery,
      viewMode: viewMode ?? this.viewMode,
      isLoading: isLoading ?? this.isLoading,
      isProcessing: isProcessing ?? this.isProcessing,
      isMigrating: isMigrating ?? this.isMigrating,
      selectedType: clearSelectedType
          ? null
          : (selectedType ?? this.selectedType),
      selectedSourcePath: clearSelectedSourcePath
          ? null
          : (selectedSourcePath ?? this.selectedSourcePath),
      selectedSide: selectedSide ?? this.selectedSide,
      selectedNotes: selectedNotes ?? this.selectedNotes,
      feedbackMessage: clearFeedbackMessage
          ? null
          : (feedbackMessage ?? this.feedbackMessage),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    documents,
    selectedCategory,
    selectedTypeFilter,
    searchQuery,
    viewMode,
    isLoading,
    isProcessing,
    isMigrating,
    selectedType,
    selectedSourcePath,
    selectedSide,
    selectedNotes,
    feedbackMessage,
    errorMessage,
  ];
}
