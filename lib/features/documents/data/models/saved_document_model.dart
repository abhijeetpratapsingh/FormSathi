import 'package:hive/hive.dart';

import '../../../../core/enums/document_category.dart';
import '../../../../core/services/hive_type_ids.dart';
import '../../domain/entities/saved_document.dart';

@HiveType(typeId: HiveTypeIds.savedDocument)
class SavedDocumentModel extends HiveObject {
  SavedDocumentModel({
    required this.id,
    required this.title,
    required this.categoryName,
    required this.localPath,
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
  final String localPath;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final DateTime updatedAt;

  factory SavedDocumentModel.fromEntity(SavedDocument entity) => SavedDocumentModel(
        id: entity.id,
        title: entity.title,
        categoryName: entity.category.name,
        localPath: entity.localPath,
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
        localPath: localPath,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
