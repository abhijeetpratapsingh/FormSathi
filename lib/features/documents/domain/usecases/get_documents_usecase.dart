import '../entities/saved_document.dart';
import '../repositories/documents_repository.dart';

class GetDocumentsUseCase {
  GetDocumentsUseCase(this._repository);

  final DocumentsRepository _repository;

  Future<List<SavedDocument>> call() => _repository.getDocuments();
}
