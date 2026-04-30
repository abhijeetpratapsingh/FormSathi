import 'package:equatable/equatable.dart';

import '../../../../core/enums/document_category.dart';
import '../../../../core/enums/document_side.dart';
import '../../../../core/enums/document_type.dart';

class SavedDocument extends Equatable {
  const SavedDocument({
    required this.id,
    required this.title,
    required this.category,
    this.documentType = DocumentType.other,
    required this.localPath,
    this.originalFileName = '',
    this.mimeType = '',
    this.fileSizeBytes = 0,
    this.width,
    this.height,
    this.pageCount,
    this.side = DocumentSide.none,
    this.notes = '',
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final DocumentCategory category;
  final DocumentType documentType;
  final String localPath;
  final String originalFileName;
  final String mimeType;
  final int fileSizeBytes;
  final int? width;
  final int? height;
  final int? pageCount;
  final DocumentSide side;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavedDocument copyWith({
    String? title,
    DocumentCategory? category,
    DocumentType? documentType,
    String? localPath,
    String? originalFileName,
    String? mimeType,
    int? fileSizeBytes,
    int? width,
    bool clearWidth = false,
    int? height,
    bool clearHeight = false,
    int? pageCount,
    bool clearPageCount = false,
    DocumentSide? side,
    String? notes,
    DateTime? updatedAt,
  }) {
    return SavedDocument(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      documentType: documentType ?? this.documentType,
      localPath: localPath ?? this.localPath,
      originalFileName: originalFileName ?? this.originalFileName,
      mimeType: mimeType ?? this.mimeType,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      width: clearWidth ? null : (width ?? this.width),
      height: clearHeight ? null : (height ?? this.height),
      pageCount: clearPageCount ? null : (pageCount ?? this.pageCount),
      side: side ?? this.side,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    category,
    documentType,
    localPath,
    originalFileName,
    mimeType,
    fileSizeBytes,
    width,
    height,
    pageCount,
    side,
    notes,
    createdAt,
    updatedAt,
  ];
}
