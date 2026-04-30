import '../entities/processed_file.dart';

abstract class ToolsRepository {
  Future<List<ProcessedFile>> getProcessedFiles();
  Future<void> saveProcessedFile(ProcessedFile file);
  Future<void> deleteProcessedFile(String id);
  Future<void> clearProcessedFiles();
}
