import 'dart:io';

import 'package:path/path.dart' as p;

import '../enums/processed_file_type.dart';
import '../errors/app_exception.dart';
import 'app_directories_service.dart';

class LocalFileService {
  LocalFileService(this._directoriesService);

  final AppDirectoriesService _directoriesService;

  Future<String> saveDocumentCopy({
    required String sourcePath,
    required String fileName,
  }) async {
    return _copyFile(sourcePath, p.join(_directoriesService.documentsDirectory.path, fileName));
  }

  Future<String> saveProcessedCopy({
    required String sourcePath,
    required String fileName,
    required ProcessedFileType type,
  }) async {
    final directory = switch (type) {
      ProcessedFileType.resized => _directoriesService.resizedDirectory,
      ProcessedFileType.compressed => _directoriesService.compressedDirectory,
      ProcessedFileType.pdf => _directoriesService.pdfDirectory,
    };
    return _copyFile(sourcePath, p.join(directory.path, fileName));
  }

  Future<String> writeBytes({
    required List<int> bytes,
    required String fileName,
    required ProcessedFileType type,
  }) async {
    final directory = switch (type) {
      ProcessedFileType.resized => _directoriesService.resizedDirectory,
      ProcessedFileType.compressed => _directoriesService.compressedDirectory,
      ProcessedFileType.pdf => _directoriesService.pdfDirectory,
    };
    final file = File(p.join(directory.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<int> fileSize(String path) async {
    final file = File(path);
    if (!await file.exists()) return 0;
    return file.length();
  }

  Future<String> _copyFile(String sourcePath, String destinationPath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw AppException('Selected file is no longer available.');
    }
    final destination = File(destinationPath);
    await source.copy(destination.path);
    return destination.path;
  }
}
