import '../entities/saved_document.dart';
import '../repositories/documents_repository.dart';

class SaveDocumentUseCase {
  SaveDocumentUseCase(this._repository);

  final DocumentsRepository _repository;

  Future<void> call(SavedDocument document) => _repository.saveDocument(document);
}
