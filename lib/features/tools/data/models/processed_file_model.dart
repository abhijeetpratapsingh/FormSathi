import 'package:hive/hive.dart';

import '../../../../core/enums/processed_file_type.dart';
import '../../../../core/services/hive_type_ids.dart';
import '../../domain/entities/processed_file.dart';

@HiveType(typeId: HiveTypeIds.processedFile)
class ProcessedFileModel extends HiveObject {
  ProcessedFileModel({
    required this.id,
    required this.typeName,
    required this.localPath,
    required this.createdAt,
    required this.metadata,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String typeName;
  @HiveField(2)
  final String localPath;
  @HiveField(3)
  final DateTime createdAt;
  @HiveField(4)
  final Map<String, String> metadata;

  factory ProcessedFileModel.fromEntity(ProcessedFile entity) => ProcessedFileModel(
        id: entity.id,
        typeName: entity.type.name,
        localPath: entity.localPath,
        createdAt: entity.createdAt,
        metadata: entity.metadata,
      );

  ProcessedFile toEntity() => ProcessedFile(
        id: id,
        type: ProcessedFileType.values.firstWhere(
          (item) => item.name == typeName,
          orElse: () => ProcessedFileType.resized,
        ),
        localPath: localPath,
        createdAt: createdAt,
        metadata: metadata,
      );
}
