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
    this.sourceDocumentId,
    this.presetId,
    this.fileSizeBytes = 0,
    this.width,
    this.height,
    this.pageCount,
    this.failureMessage = '',
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
  @HiveField(5)
  final String? sourceDocumentId;
  @HiveField(6)
  final String? presetId;
  @HiveField(7)
  final int fileSizeBytes;
  @HiveField(8)
  final int? width;
  @HiveField(9)
  final int? height;
  @HiveField(10)
  final int? pageCount;
  @HiveField(11)
  final String failureMessage;

  factory ProcessedFileModel.fromEntity(ProcessedFile entity) =>
      ProcessedFileModel(
        id: entity.id,
        typeName: entity.type.name,
        localPath: entity.localPath,
        createdAt: entity.createdAt,
        metadata: entity.metadata,
        sourceDocumentId: entity.sourceDocumentId,
        presetId: entity.presetId,
        fileSizeBytes: entity.fileSizeBytes,
        width: entity.width,
        height: entity.height,
        pageCount: entity.pageCount,
        failureMessage: entity.failureMessage,
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
    sourceDocumentId: sourceDocumentId,
    presetId: presetId,
    fileSizeBytes: fileSizeBytes,
    width: width,
    height: height,
    pageCount: pageCount,
    failureMessage: failureMessage,
  );
}
