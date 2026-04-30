import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/app/di.dart';
import 'package:formsathi/core/enums/document_category.dart';
import 'package:formsathi/core/enums/document_type.dart';
import 'package:formsathi/core/enums/export_preset.dart';
import 'package:formsathi/core/enums/processed_file_type.dart';
import 'package:formsathi/core/services/export_orchestration_service.dart';
import 'package:formsathi/core/services/local_file_service.dart';
import 'package:formsathi/features/documents/domain/entities/saved_document.dart';
import 'package:formsathi/features/documents/domain/repositories/documents_repository.dart';
import 'package:formsathi/features/documents/domain/usecases/delete_document_usecase.dart';
import 'package:formsathi/features/documents/domain/usecases/get_documents_usecase.dart';
import 'package:formsathi/features/documents/domain/usecases/save_document_usecase.dart';
import 'package:formsathi/features/documents/domain/usecases/update_document_usecase.dart';
import 'package:formsathi/features/documents/presentation/cubit/documents_cubit.dart';
import 'package:formsathi/features/documents/presentation/pages/document_preview_page.dart';
import 'package:formsathi/features/tools/domain/entities/processed_file.dart';
import 'package:formsathi/features/tools/domain/entities/export_request.dart';
import 'package:formsathi/features/tools/domain/repositories/tools_repository.dart';
import 'package:formsathi/features/tools/domain/usecases/export_saved_document_usecase.dart';

void main() {
  setUp(() async {
    await sl.reset();
    sl.registerLazySingleton(
      () => ExportSavedDocumentUseCase(
        exportService: FakePreviewExportService(),
        toolsRepository: FakeToolsRepository(),
      ),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('document preview exposes smart export action', (tester) async {
    final now = DateTime(2026);
    final document = SavedDocument(
      id: 'signature',
      title: 'Signature',
      category: DocumentCategory.signature,
      documentType: DocumentType.signature,
      localPath: '/tmp/signature.jpg',
      createdAt: now,
      updatedAt: now,
    );
    final repository = FakeDocumentsRepository([document]);
    final documentsCubit = DocumentsCubit(
      getDocumentsUseCase: GetDocumentsUseCase(repository),
      saveDocumentUseCase: SaveDocumentUseCase(repository),
      updateDocumentUseCase: UpdateDocumentUseCase(repository),
      deleteDocumentUseCase: DeleteDocumentUseCase(repository),
      localFileService: FakeLocalFileService(),
    );
    addTearDown(documentsCubit.close);
    await documentsCubit.loadDocuments();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DocumentsCubit>.value(
          value: documentsCubit,
          child: const DocumentPreviewPage(documentId: 'signature'),
        ),
      ),
    );

    expect(find.text(ExportPreset.signatureUnder20kb.label), findsOneWidget);
  });
}

class FakeDocumentsRepository implements DocumentsRepository {
  FakeDocumentsRepository(this.documents);

  final List<SavedDocument> documents;

  @override
  Future<void> clearDocuments() async => documents.clear();

  @override
  Future<void> deleteDocument(String id) async {}

  @override
  Future<List<SavedDocument>> getDocuments() async => documents;

  @override
  Future<void> migrateCategoryOnlyDocuments() async {}

  @override
  Future<void> saveDocument(SavedDocument document) async {}

  @override
  Future<void> updateDocument(SavedDocument document) async {}
}

class FakeLocalFileService implements LocalFileService {
  @override
  Future<void> deleteFile(String path) async {}

  @override
  Future<int> fileSize(String path) async => 0;

  @override
  Future<FileMetadata> metadata(String path) async {
    return const FileMetadata(
      fileSizeBytes: 0,
      originalFileName: 'file.jpg',
      mimeType: 'image/jpeg',
    );
  }

  @override
  Future<String> saveDocumentCopy({
    required String sourcePath,
    required String fileName,
  }) async => sourcePath;

  @override
  Future<String> saveProcessedCopy({
    required String sourcePath,
    required String fileName,
    required ProcessedFileType type,
  }) async => sourcePath;

  @override
  Future<bool> tryDeleteFile(String path) async => true;

  @override
  Future<String> writeBytes({
    required List<int> bytes,
    required String fileName,
    required ProcessedFileType type,
  }) async => '/tmp/$fileName';
}

class FakePreviewExportService implements ExportOrchestrationService {
  @override
  Future<OrchestratedExportResult> exportImage({
    required String sourcePath,
    required ExportPreset preset,
    CropRect? cropRect,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 20));
    return OrchestratedExportResult(
      localPath: '/tmp/export.jpg',
      fileSizeBytes: 1024,
      metadata: {'preset': preset.name},
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
  @override
  Future<void> clearProcessedFiles() async {}

  @override
  Future<void> deleteProcessedFile(String id) async {}

  @override
  Future<List<ProcessedFile>> getProcessedFiles() async => const [];

  @override
  Future<void> saveProcessedFile(ProcessedFile file) async {}
}
