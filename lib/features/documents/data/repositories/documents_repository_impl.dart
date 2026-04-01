import '../../domain/entities/saved_document.dart';
import '../../domain/repositories/documents_repository.dart';
import '../datasources/documents_local_data_source.dart';
import '../models/saved_document_model.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  DocumentsRepositoryImpl(this._localDataSource);

  final DocumentsLocalDataSource _localDataSource;

  @override
  Future<void> deleteDocument(String id) => _localDataSource.deleteDocument(id);

  @override
  Future<List<SavedDocument>> getDocuments() async {
    final items = _localDataSource.getDocuments().map((item) => item.toEntity()).toList();
    items.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return items;
  }

  @override
  Future<void> saveDocument(SavedDocument document) {
    return _localDataSource.saveDocument(SavedDocumentModel.fromEntity(document));
  }

  @override
  Future<void> updateDocument(SavedDocument document) {
    return _localDataSource.saveDocument(SavedDocumentModel.fromEntity(document));
  }
}
