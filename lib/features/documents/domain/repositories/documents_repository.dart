import '../entities/saved_document.dart';

abstract class DocumentsRepository {
  Future<List<SavedDocument>> getDocuments();
  Future<void> saveDocument(SavedDocument document);
  Future<void> updateDocument(SavedDocument document);
  Future<void> deleteDocument(String id);
  Future<void> clearDocuments();
  Future<void> migrateCategoryOnlyDocuments();
}
