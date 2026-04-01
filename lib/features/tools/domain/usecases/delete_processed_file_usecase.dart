import '../../../../core/services/local_file_service.dart';
import '../repositories/tools_repository.dart';

class DeleteProcessedFileUseCase {
  const DeleteProcessedFileUseCase({
    required ToolsRepository repository,
    required LocalFileService localFileService,
  })  : _repository = repository,
        _localFileService = localFileService;

  final ToolsRepository _repository;
  final LocalFileService _localFileService;

  Future<void> call(String id) async {
    final items = await _repository.getProcessedFiles();
    final file = items.where((item) => item.id == id).toList();
    if (file.isEmpty) {
      return;
    }
    final target = file.first;
    await _localFileService.deleteFile(target.localPath);
    await _repository.deleteProcessedFile(id);
  }
}
