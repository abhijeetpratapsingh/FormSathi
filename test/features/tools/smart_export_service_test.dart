import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/enums/document_category.dart';
import 'package:formsathi/core/enums/document_type.dart';
import 'package:formsathi/core/enums/export_preset.dart';
import 'package:formsathi/core/enums/processed_file_type.dart';
import 'package:formsathi/core/services/export_orchestration_service.dart';
import 'package:formsathi/features/documents/domain/entities/saved_document.dart';
import 'package:formsathi/features/tools/domain/entities/export_request.dart';
import 'package:formsathi/features/tools/domain/entities/processed_file.dart';
import 'package:formsathi/features/tools/domain/repositories/tools_repository.dart';
import 'package:formsathi/features/tools/domain/usecases/export_saved_document_usecase.dart';

void main() {
  test(
    'exports signature under 20KB and persists processed metadata',
    () async {
      final repository = FakeToolsRepository();
      final useCase = ExportSavedDocumentUseCase(
        exportService: FakeExportService(bytes: 18 * 1024),
        toolsRepository: repository,
      );

      final result = await useCase(
        document: _document(DocumentType.signature),
        preset: ExportPreset.signatureUnder20kb,
      );

      expect(result.type, ProcessedFileType.compressed);
      expect(result.fileSizeBytes, lessThanOrEqualTo(20 * 1024));
      expect(result.presetId, ExportPreset.signatureUnder20kb.name);
      expect(repository.files.single, result);
    },
  );

  test('exports passport photo under 50KB', () async {
    final useCase = ExportSavedDocumentUseCase(
      exportService: FakeExportService(bytes: 42 * 1024),
      toolsRepository: FakeToolsRepository(),
    );

    final result = await useCase(
      document: _document(DocumentType.passportPhoto),
      preset: ExportPreset.passportPhotoUnder50kb,
    );

    expect(result.fileSizeBytes, lessThanOrEqualTo(50 * 1024));
    expect(result.metadata['title'], ExportPreset.passportPhotoUnder50kb.label);
  });
}

SavedDocument _document(DocumentType type) {
  final now = DateTime(2026);
  return SavedDocument(
    id: 'doc-${type.name}',
    title: type.label,
    category: type == DocumentType.signature
        ? DocumentCategory.signature
        : DocumentCategory.passportPhoto,
    documentType: type,
    localPath: '/tmp/${type.name}.jpg',
    createdAt: now,
    updatedAt: now,
  );
}

class FakeExportService implements ExportOrchestrationService {
  FakeExportService({required this.bytes});

  final int bytes;

  @override
  Future<OrchestratedExportResult> exportImage({
    required String sourcePath,
    required ExportPreset preset,
    CropRect? cropRect,
  }) async {
    return OrchestratedExportResult(
      localPath: '/tmp/${preset.name}.jpg',
      fileSizeBytes: bytes,
      metadata: {'preset': preset.name},
      width: preset.defaultWidth,
      height: preset.defaultHeight,
    );
  }

  @override
  Future<OrchestratedExportResult> exportPdf({
    required List<SavedDocument> documents,
    required ExportPreset preset,
    required String title,
  }) async {
    throw UnimplementedError();
  }
}

class FakeToolsRepository implements ToolsRepository {
  final files = <ProcessedFile>[];

  @override
  Future<void> clearProcessedFiles() async => files.clear();

  @override
  Future<void> deleteProcessedFile(String id) async {
    files.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<ProcessedFile>> getProcessedFiles() async => files;

  @override
  Future<void> saveProcessedFile(ProcessedFile file) async {
    files.add(file);
  }
}
