import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../../core/enums/processed_file_type.dart';
import '../../../../core/enums/image_quality_option.dart';
import '../../../../core/services/image_processing_service.dart';
import '../../../../core/services/local_file_service.dart';
import '../entities/processed_file.dart';
import '../repositories/tools_repository.dart';

class CompressImageUseCase {
  const CompressImageUseCase({
    required ImageProcessingService processingService,
    required LocalFileService localFileService,
    required ToolsRepository repository,
    Uuid? uuid,
  })  : _processingService = processingService,
        _localFileService = localFileService,
        _repository = repository,
        _uuid = uuid ?? const Uuid();

  final ImageProcessingService _processingService;
  final LocalFileService _localFileService;
  final ToolsRepository _repository;
  final Uuid _uuid;

  Future<ProcessedFile> call({
    required String sourcePath,
    required ImageQualityOption quality,
  }) async {
    final result = await _processingService.compressImage(
      sourcePath: sourcePath,
      quality: quality,
    );
    final baseName = _sanitizeFileName(p.basenameWithoutExtension(sourcePath));
    final fileName = '${baseName}_compressed_${quality.name}_${DateTime.now().millisecondsSinceEpoch}${result.extension}';
    final path = await _localFileService.writeBytes(
      bytes: result.bytes,
      fileName: fileName,
      type: ProcessedFileType.compressed,
    );
    final processed = ProcessedFile(
      id: _uuid.v4(),
      type: ProcessedFileType.compressed,
      localPath: path,
      createdAt: DateTime.now(),
      metadata: {
        ...result.metadata,
        'sourcePath': sourcePath,
      },
    );
    await _repository.saveProcessedFile(processed);
    return processed;
  }

  String _sanitizeFileName(String input) {
    final sanitized = input.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_\- ]'), '').replaceAll(' ', '_');
    return sanitized.isEmpty ? 'form_sathi_image' : sanitized;
  }
}
