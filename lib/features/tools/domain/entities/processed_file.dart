import 'package:equatable/equatable.dart';

import '../../../../core/enums/processed_file_type.dart';

class ProcessedFile extends Equatable {
  const ProcessedFile({
    required this.id,
    required this.type,
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

  final String id;
  final ProcessedFileType type;
  final String localPath;
  final DateTime createdAt;
  final Map<String, String> metadata;
  final String? sourceDocumentId;
  final String? presetId;
  final int fileSizeBytes;
  final int? width;
  final int? height;
  final int? pageCount;
  final String failureMessage;

  @override
  List<Object?> get props => [
    id,
    type,
    localPath,
    createdAt,
    metadata,
    sourceDocumentId,
    presetId,
    fileSizeBytes,
    width,
    height,
    pageCount,
    failureMessage,
  ];
}
