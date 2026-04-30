import 'package:uuid/uuid.dart';

import '../../../../core/enums/export_preset.dart';
import '../../../../core/enums/processed_file_type.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/export_orchestration_service.dart';
import '../../../documents/domain/entities/saved_document.dart';
import '../entities/processed_file.dart';
import '../repositories/tools_repository.dart';

class ExportSavedDocumentUseCase {
  ExportSavedDocumentUseCase({
    required ExportOrchestrationService exportService,
    required ToolsRepository toolsRepository,
  }) : _exportService = exportService,
       _toolsRepository = toolsRepository;

  final ExportOrchestrationService _exportService;
  final ToolsRepository _toolsRepository;
  final Uuid _uuid = const Uuid();

  Future<ProcessedFile> call({
    required SavedDocument document,
    required ExportPreset preset,
    List<SavedDocument> relatedDocuments = const [],
  }) async {
    if (!preset.supports(document.documentType)) {
      throw AppException('${preset.label} is not available for this document.');
    }

    final result = switch (preset.outputKind) {
      ExportOutputKind.image => await _exportService.exportImage(
        sourcePath: document.localPath,
        preset: preset,
      ),
      ExportOutputKind.pdf => await _exportService.exportPdf(
        documents: relatedDocuments.isEmpty
            ? [document]
            : [document, ...relatedDocuments],
        preset: preset,
        title: document.title,
      ),
    };

    final processed = ProcessedFile(
      id: _uuid.v4(),
      type: preset.outputKind == ExportOutputKind.pdf
          ? ProcessedFileType.pdf
          : ProcessedFileType.compressed,
      localPath: result.localPath,
      createdAt: DateTime.now(),
      metadata: {
        ...result.metadata,
        'title': preset.label,
        'sourceTitle': document.title,
      },
      sourceDocumentId: document.id,
      presetId: preset.name,
      fileSizeBytes: result.fileSizeBytes,
      width: result.width,
      height: result.height,
      pageCount: result.pageCount,
    );
    await _toolsRepository.saveProcessedFile(processed);
    return processed;
  }
}
