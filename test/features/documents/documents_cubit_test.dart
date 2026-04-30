import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/enums/document_category.dart';
import 'package:formsathi/core/enums/document_side.dart';
import 'package:formsathi/core/enums/document_type.dart';
import 'package:formsathi/core/enums/processed_file_type.dart';
import 'package:formsathi/core/services/local_file_service.dart';
import 'package:formsathi/features/documents/domain/entities/saved_document.dart';
import 'package:formsathi/features/documents/domain/repositories/documents_repository.dart';
import 'package:formsathi/features/documents/domain/usecases/delete_document_usecase.dart';
import 'package:formsathi/features/documents/domain/usecases/get_documents_usecase.dart';
import 'package:formsathi/features/documents/domain/usecases/save_document_usecase.dart';
import 'package:formsathi/features/documents/domain/usecases/update_document_usecase.dart';
import 'package:formsathi/features/documents/presentation/cubit/documents_cubit.dart';
import 'package:formsathi/features/documents/presentation/cubit/documents_state.dart';

void main() {
  test('documents default to list view', () {
    expect(const DocumentsState().viewMode, DocumentsViewMode.list);
  });

  test('type-first add flow saves metadata and clears draft', () async {
    final temp = await Directory.systemTemp.createTemp('formsathi_docs_test');
    addTearDown(() => temp.delete(recursive: true));
    final source = File('${temp.path}/aadhaar-front.jpg')
      ..writeAsBytesSync([1, 2, 3, 4]);
    final repository = FakeDocumentsRepository();
    final cubit = DocumentsCubit(
      getDocumentsUseCase: GetDocumentsUseCase(repository),
      saveDocumentUseCase: SaveDocumentUseCase(repository),
      updateDocumentUseCase: UpdateDocumentUseCase(repository),
      deleteDocumentUseCase: DeleteDocumentUseCase(repository),
      localFileService: FakeLocalFileService(temp),
    );
    addTearDown(cubit.close);

    cubit.selectDocumentType(DocumentType.aadhaar);
    cubit.selectSourcePath(source.path);
    await cubit.addTypedDocument(
      sourcePath: source.path,
      title: 'Aadhaar front',
      documentType: DocumentType.aadhaar,
      side: DocumentSide.front,
      notes: 'Primary ID',
    );

    expect(repository.documents, hasLength(1));
    final saved = repository.documents.single;
    expect(saved.documentType, DocumentType.aadhaar);
    expect(saved.category, DocumentCategory.aadhaar);
    expect(saved.side, DocumentSide.front);
    expect(saved.notes, 'Primary ID');
    expect(saved.fileSizeBytes, 4);
    expect(cubit.state.selectedType, isNull);
    expect(cubit.state.selectedSourcePath, isNull);
  });

  test('document type filter matches typed records', () {
    final date = DateTime(2026);
    final state = DocumentsCubitTestData.stateWith(
      SavedDocument(
        id: '1',
        title: 'Signature',
        category: DocumentCategory.signature,
        documentType: DocumentType.signature,
        localPath: '/tmp/sign.jpg',
        createdAt: date,
        updatedAt: date,
      ),
    ).copyWith(selectedTypeFilter: DocumentType.signature);

    expect(state.filteredDocuments, hasLength(1));
  });
}

class FakeDocumentsRepository implements DocumentsRepository {
  final List<SavedDocument> documents = [];

  @override
  Future<void> clearDocuments() async => documents.clear();

  @override
  Future<void> deleteDocument(String id) async {
    documents.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<SavedDocument>> getDocuments() async => documents;

  @override
  Future<void> migrateCategoryOnlyDocuments() async {}

  @override
  Future<void> saveDocument(SavedDocument document) async {
    documents.add(document);
  }

  @override
  Future<void> updateDocument(SavedDocument document) async {
    final index = documents.indexWhere((item) => item.id == document.id);
    if (index == -1) {
      documents.add(document);
    } else {
      documents[index] = document;
    }
  }
}

class FakeLocalFileService implements LocalFileService {
  FakeLocalFileService(this.directory);

  final Directory directory;

  @override
  Future<String> saveDocumentCopy({
    required String sourcePath,
    required String fileName,
  }) async {
    final destination = File('${directory.path}/$fileName');
    await File(sourcePath).copy(destination.path);
    return destination.path;
  }

  @override
  Future<FileMetadata> metadata(String path) async {
    final file = File(path);
    return FileMetadata(
      fileSizeBytes: await file.length(),
      originalFileName: file.uri.pathSegments.last,
      mimeType: 'image/jpeg',
    );
  }

  @override
  Future<void> deleteFile(String path) async {}

  @override
  Future<int> fileSize(String path) async => File(path).length();

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
  }) async {
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }
}

class DocumentsCubitTestData {
  static DocumentsState stateWith(SavedDocument document) {
    return DocumentsState(documents: [document]);
  }
}
