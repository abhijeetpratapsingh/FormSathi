import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppDirectoriesService {
  static const _root = 'app_data';
  static const _documents = 'documents';
  static const _processed = 'processed';
  static const _resized = 'resized';
  static const _compressed = 'compressed';
  static const _pdfs = 'pdfs';

  late final Directory rootDirectory;
  late final Directory documentsDirectory;
  late final Directory processedDirectory;
  late final Directory resizedDirectory;
  late final Directory compressedDirectory;
  late final Directory pdfDirectory;

  Future<void> init() async {
    final baseDir = await getApplicationDocumentsDirectory();
    rootDirectory = await _ensureDirectory('${baseDir.path}/$_root');
    documentsDirectory = await _ensureDirectory('${rootDirectory.path}/$_documents');
    processedDirectory = await _ensureDirectory('${rootDirectory.path}/$_processed');
    resizedDirectory = await _ensureDirectory('${processedDirectory.path}/$_resized');
    compressedDirectory = await _ensureDirectory('${processedDirectory.path}/$_compressed');
    pdfDirectory = await _ensureDirectory('${processedDirectory.path}/$_pdfs');
  }

  Future<Directory> _ensureDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }
}
