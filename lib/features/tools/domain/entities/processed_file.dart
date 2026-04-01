import 'package:equatable/equatable.dart';

import '../../../../core/enums/processed_file_type.dart';

class ProcessedFile extends Equatable {
  const ProcessedFile({
    required this.id,
    required this.type,
    required this.localPath,
    required this.createdAt,
    required this.metadata,
  });

  final String id;
  final ProcessedFileType type;
  final String localPath;
  final DateTime createdAt;
  final Map<String, String> metadata;

  @override
  List<Object?> get props => [id, type, localPath, createdAt, metadata];
}
