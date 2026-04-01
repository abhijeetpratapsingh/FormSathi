import '../entities/processed_file.dart';
import '../repositories/tools_repository.dart';

class LoadRecentProcessedFilesUseCase {
  const LoadRecentProcessedFilesUseCase(this._repository);

  final ToolsRepository _repository;

  Future<List<ProcessedFile>> call() => _repository.getProcessedFiles();
}
