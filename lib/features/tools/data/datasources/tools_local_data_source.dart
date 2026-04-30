import 'package:hive/hive.dart';

import '../models/processed_file_model.dart';

class ToolsLocalDataSource {
  ToolsLocalDataSource(this._box);

  final Box<ProcessedFileModel> _box;

  List<ProcessedFileModel> getProcessedFiles() =>
      _box.values.toList(growable: false);

  Future<void> saveProcessedFile(ProcessedFileModel model) =>
      _box.put(model.id, model);

  Future<void> deleteProcessedFile(String id) => _box.delete(id);

  Future<void> clearProcessedFiles() => _box.clear();
}
