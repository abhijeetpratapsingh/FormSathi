import '../repositories/documents_repository.dart';

class DeleteDocumentUseCase {
  DeleteDocumentUseCase(this._repository);

  final DocumentsRepository _repository;

  Future<void> call(String id) => _repository.deleteDocument(id);
}
