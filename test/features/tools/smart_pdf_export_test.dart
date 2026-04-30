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
  test('exports Aadhaar as PDF output', () async {
    final useCase = ExportSavedDocumentUseCase(
      exportService: FakePdfExportService(bytes: 120 * 1024),
      toolsRepository: FakeToolsRepository(),
    );

    final result = await useCase(
      document: _document(DocumentType.aadhaar, DocumentCategory.aadhaar),
      preset: ExportPreset.aadhaarPdf,
    );

    expect(result.type, ProcessedFileType.pdf);
    expect(result.pageCount, 1);
    expect(result.presetId, ExportPreset.aadhaarPdf.name);
  });

  test('exports certificate PDF under 300KB', () async {
    final useCase = ExportSavedDocumentUseCase(
      exportService: FakePdfExportService(bytes: 280 * 1024),
      toolsRepository: FakeToolsRepository(),
    );

    final result = await useCase(
      document: _document(
        DocumentType.certificate,
        DocumentCategory.certificate,
      ),
      preset: ExportPreset.certificatePdfUnder300kb,
    );

    expect(result.fileSizeBytes, lessThanOrEqualTo(300 * 1024));
    expect(
      result.metadata['title'],
      ExportPreset.certificatePdfUnder300kb.label,
    );
  });
}

SavedDocument _document(DocumentType type, DocumentCategory category) {
  final now = DateTime(2026);
  return SavedDocument(
    id: 'doc-${type.name}',
    title: type.label,
    category: category,
    documentType: type,
    localPath: '/tmp/${type.name}.jpg',
    createdAt: now,
    updatedAt: now,
  );
}

class FakePdfExportService implements ExportOrchestrationService {
  FakePdfExportService({required this.bytes});

  final int bytes;

  @override
  Future<OrchestratedExportResult> exportImage({
    required String sourcePath,
    required ExportPreset preset,
    CropRect? cropRect,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<OrchestratedExportResult> exportPdf({
    required List<SavedDocument> documents,
    required ExportPreset preset,
    required String title,
  }) async {
    return OrchestratedExportResult(
      localPath: '/tmp/${preset.name}.pdf',
      fileSizeBytes: bytes,
      pageCount: documents.length,
      metadata: {'preset': preset.name},
    );
  }
}

class FakeToolsRepository implements ToolsRepository {
  final files = <ProcessedFile>[];

  @override
  Future<void> clearProcessedFiles() async => files.clear();

  @override
  Future<void> deleteProcessedFile(String id) async {}

  @override
  Future<List<ProcessedFile>> getProcessedFiles() async => files;

  @override
  Future<void> saveProcessedFile(ProcessedFile file) async {
    files.add(file);
  }
}
