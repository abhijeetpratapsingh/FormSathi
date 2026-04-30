import 'package:hive/hive.dart';

import '../../../../core/enums/document_category.dart';
import '../../../../core/enums/document_side.dart';
import '../../../../core/enums/document_type.dart';
import '../../../../core/services/hive_type_ids.dart';
import '../../domain/entities/saved_document.dart';

@HiveType(typeId: HiveTypeIds.savedDocument)
class SavedDocumentModel extends HiveObject {
  SavedDocumentModel({
    required this.id,
    required this.title,
    required this.categoryName,
    this.documentTypeName = 'other',
    required this.localPath,
    this.originalFileName = '',
    this.mimeType = '',
    this.fileSizeBytes = 0,
    this.width,
    this.height,
    this.pageCount,
    this.sideName = 'none',
    this.notes = '',
    required this.createdAt,
    required this.updatedAt,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String categoryName;
  @HiveField(3)
  final String documentTypeName;
  @HiveField(4)
  final String localPath;
  @HiveField(5)
  final String originalFileName;
  @HiveField(6)
  final String mimeType;
  @HiveField(7)
  final int fileSizeBytes;
  @HiveField(8)
  final int? width;
  @HiveField(9)
  final int? height;
  @HiveField(10)
  final int? pageCount;
  @HiveField(11)
  final String sideName;
  @HiveField(12)
  final String notes;
  @HiveField(13)
  final DateTime createdAt;
  @HiveField(14)
  final DateTime updatedAt;

  factory SavedDocumentModel.fromEntity(SavedDocument entity) =>
      SavedDocumentModel(
        id: entity.id,
        title: entity.title,
        categoryName: entity.category.name,
        documentTypeName: entity.documentType.name,
        localPath: entity.localPath,
        originalFileName: entity.originalFileName,
        mimeType: entity.mimeType,
        fileSizeBytes: entity.fileSizeBytes,
        width: entity.width,
        height: entity.height,
        pageCount: entity.pageCount,
        sideName: entity.side.name,
        notes: entity.notes,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  SavedDocument toEntity() => SavedDocument(
    id: id,
    title: title,
    category: DocumentCategory.values.firstWhere(
      (item) => item.name == categoryName,
      orElse: () => DocumentCategory.other,
    ),
    documentType: DocumentType.fromName(documentTypeName),
    localPath: localPath,
    originalFileName: originalFileName,
    mimeType: mimeType,
    fileSizeBytes: fileSizeBytes,
    width: width,
    height: height,
    pageCount: pageCount,
    side: DocumentSide.fromName(sideName),
    notes: notes,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
