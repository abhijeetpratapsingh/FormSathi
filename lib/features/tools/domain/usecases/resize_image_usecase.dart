import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../../core/enums/processed_file_type.dart';
import '../../../../core/enums/resize_preset.dart';
import '../../../../core/services/image_processing_service.dart';
import '../../../../core/services/local_file_service.dart';
import '../entities/processed_file.dart';
import '../repositories/tools_repository.dart';

class ResizeImageUseCase {
  const ResizeImageUseCase({
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
    required ResizePreset preset,
  }) async {
    final result = await _processingService.resizeImage(
      sourcePath: sourcePath,
      preset: preset,
    );
    final baseName = _sanitizeFileName(p.basenameWithoutExtension(sourcePath));
    final extension = result.extension;
    final fileName = '${baseName}_${preset.name}_${DateTime.now().millisecondsSinceEpoch}$extension';
    final path = await _localFileService.writeBytes(
      bytes: result.bytes,
      fileName: fileName,
      type: ProcessedFileType.resized,
    );
    final processed = ProcessedFile(
      id: _uuid.v4(),
      type: ProcessedFileType.resized,
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
