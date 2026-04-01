import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import '../enums/image_quality_option.dart';
import '../enums/resize_preset.dart';
import '../errors/app_exception.dart';

class ImageProcessingService {
  Future<ProcessedImageResult> compressImage({
    required String sourcePath,
    required ImageQualityOption quality,
  }) async {
    final decoded = await _decode(sourcePath);
    final bytes = img.encodeJpg(decoded, quality: quality.quality);
    return ProcessedImageResult(
      bytes: bytes,
      extension: '.jpg',
      metadata: {
        'quality': quality.label,
        'sourceName': p.basename(sourcePath),
      },
    );
  }

  Future<ProcessedImageResult> resizeImage({
    required String sourcePath,
    required ResizePreset preset,
  }) async {
    final decoded = await _decode(sourcePath);
    final resized = switch (preset) {
      ResizePreset.passportSize => img.copyResize(decoded, width: 413, height: 531),
      ResizePreset.signatureSize => img.copyResize(decoded, width: 600, height: 200),
      _ => img.copyResize(decoded, width: decoded.width),
    };

    if (preset.targetBytes == null) {
      final bytes = img.encodeJpg(resized, quality: 88);
      return ProcessedImageResult(
        bytes: bytes,
        extension: '.jpg',
        metadata: {
          'preset': preset.label,
          'dimensions': '${resized.width}x${resized.height}',
          'sourceName': p.basename(sourcePath),
        },
      );
    }

    var width = decoded.width;
    var height = decoded.height;
    var quality = 88;
    List<int> best = img.encodeJpg(decoded, quality: quality);
    img.Image current = decoded;

    while (best.length > preset.targetBytes! && (quality > 25 || width > 500)) {
      if (quality > 35) {
        quality -= 8;
      } else {
        width = (width * 0.92).round();
        height = (height * 0.92).round();
        current = img.copyResize(decoded, width: width, height: height);
      }
      best = img.encodeJpg(current, quality: quality);
    }

    return ProcessedImageResult(
      bytes: best,
      extension: '.jpg',
      metadata: {
        'preset': preset.label,
        'dimensions': '${current.width}x${current.height}',
        'sourceName': p.basename(sourcePath),
        'target': '${preset.targetBytes}',
      },
    );
  }

  Future<img.Image> _decode(String path) async {
    final bytes = await File(path).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw AppException('Unable to process the selected image.');
    }
    return decoded;
  }
}

class ProcessedImageResult {
  const ProcessedImageResult({
    required this.bytes,
    required this.extension,
    required this.metadata,
  });

  final List<int> bytes;
  final String extension;
  final Map<String, String> metadata;
}
