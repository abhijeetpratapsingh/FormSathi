import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/services/image_processing_service.dart';
import 'package:image/image.dart' as img;

void main() {
  test('processForTarget returns image under requested byte target', () async {
    final tempDir = await Directory.systemTemp.createTemp(
      'formsathi_image_test',
    );
    addTearDown(() => tempDir.delete(recursive: true));
    final source = File('${tempDir.path}/source.jpg');
    final image = img.Image(width: 600, height: 400);
    await source.writeAsBytes(img.encodeJpg(image, quality: 95));

    final result = await ImageProcessingService().processForTarget(
      sourcePath: source.path,
      targetBytes: 50 * 1024,
      width: 300,
      height: 200,
    );

    expect(result.bytes.length, lessThanOrEqualTo(50 * 1024));
    expect(result.metadata['dimensions'], '300x200');
  });
}
