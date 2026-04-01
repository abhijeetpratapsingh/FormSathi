import '../entities/saved_document.dart';
import '../repositories/documents_repository.dart';

class UpdateDocumentUseCase {
  UpdateDocumentUseCase(this._repository);

  final DocumentsRepository _repository;

  Future<void> call(SavedDocument document) => _repository.updateDocument(document);
}
