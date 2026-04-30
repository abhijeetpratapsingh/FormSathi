import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/services/app_directories_service.dart';
import 'package:formsathi/core/services/local_file_service.dart';

void main() {
  test('tryDeleteFile deletes existing file and reports success', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'formsathi_delete_test',
    );
    addTearDown(() => tempDir.delete(recursive: true));
    final file = File('${tempDir.path}/target.txt');
    await file.writeAsString('data');

    final service = LocalFileService(AppDirectoriesService());
    final deleted = await service.tryDeleteFile(file.path);

    expect(deleted, isTrue);
    expect(await file.exists(), isFalse);
  });
}
