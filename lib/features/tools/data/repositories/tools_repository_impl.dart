import '../../domain/entities/processed_file.dart';
import '../../domain/repositories/tools_repository.dart';
import '../datasources/tools_local_data_source.dart';
import '../models/processed_file_model.dart';

class ToolsRepositoryImpl implements ToolsRepository {
  ToolsRepositoryImpl(this._localDataSource);

  final ToolsLocalDataSource _localDataSource;

  @override
  Future<void> clearProcessedFiles() => _localDataSource.clearProcessedFiles();

  @override
  Future<void> deleteProcessedFile(String id) =>
      _localDataSource.deleteProcessedFile(id);

  @override
  Future<List<ProcessedFile>> getProcessedFiles() async {
    final items = _localDataSource
        .getProcessedFiles()
        .map((item) => item.toEntity())
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  @override
  Future<void> saveProcessedFile(ProcessedFile file) {
    return _localDataSource.saveProcessedFile(
      ProcessedFileModel.fromEntity(file),
    );
  }
}
