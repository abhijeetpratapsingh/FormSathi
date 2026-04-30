import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import '../enums/image_quality_option.dart';
import '../enums/resize_preset.dart';
import '../errors/app_exception.dart';
import '../../features/tools/domain/entities/export_request.dart';

class ImageProcessingService {
  Future<ProcessedImageResult> compressImage({
    required String sourcePath,
    required ImageQualityOption quality,
    int? targetBytes,
  }) async {
    final decoded = await _decode(sourcePath);
    final bytes = targetBytes == null
        ? img.encodeJpg(decoded, quality: quality.quality)
        : _encodeUnderTarget(
            decoded,
            targetBytes: targetBytes,
            initialQuality: quality.quality,
          );
    return ProcessedImageResult(
      bytes: bytes,
      extension: '.jpg',
      metadata: {
        'quality': quality.label,
        'sourceName': p.basename(sourcePath),
        if (targetBytes != null) 'targetBytes': '$targetBytes',
        'finalBytes': '${bytes.length}',
      },
    );
  }

  Future<ProcessedImageResult> resizeImage({
    required String sourcePath,
    required ResizePreset preset,
    int? customWidth,
    int? customHeight,
    int? targetBytes,
    CropRect? cropRect,
  }) async {
    var decoded = await _decode(sourcePath);
    if (cropRect != null && cropRect.isValid) {
      decoded = img.copyCrop(
        decoded,
        x: cropRect.left,
        y: cropRect.top,
        width: cropRect.width,
        height: cropRect.height,
      );
    }
    final presetTarget = targetBytes ?? preset.targetBytes;
    final resized = switch (preset) {
      ResizePreset.passportSize => img.copyResize(
        decoded,
        width: customWidth ?? 413,
        height: customHeight ?? 531,
      ),
      ResizePreset.signatureSize => img.copyResize(
        decoded,
        width: customWidth ?? 600,
        height: customHeight ?? 200,
      ),
      _ when customWidth != null || customHeight != null => img.copyResize(
        decoded,
        width: customWidth,
        height: customHeight,
      ),
      _ => img.copyResize(decoded, width: decoded.width),
    };

    if (presetTarget == null) {
      final bytes = img.encodeJpg(resized, quality: 88);
      return ProcessedImageResult(
        bytes: bytes,
        extension: '.jpg',
        metadata: {
          'preset': preset.label,
          'dimensions': '${resized.width}x${resized.height}',
          'sourceName': p.basename(sourcePath),
          'finalBytes': '${bytes.length}',
        },
      );
    }

    final best = _encodeUnderTarget(resized, targetBytes: presetTarget);

    return ProcessedImageResult(
      bytes: best,
      extension: '.jpg',
      metadata: {
        'preset': preset.label,
        'dimensions': '${resized.width}x${resized.height}',
        'sourceName': p.basename(sourcePath),
        'target': '$presetTarget',
        'finalBytes': '${best.length}',
      },
    );
  }

  Future<ProcessedImageResult> processForTarget({
    required String sourcePath,
    required int targetBytes,
    int? width,
    int? height,
    CropRect? cropRect,
    int qualityFloor = 30,
  }) async {
    var decoded = await _decode(sourcePath);
    if (cropRect != null && cropRect.isValid) {
      decoded = img.copyCrop(
        decoded,
        x: cropRect.left,
        y: cropRect.top,
        width: cropRect.width,
        height: cropRect.height,
      );
    }
    final targetImage = (width != null || height != null)
        ? img.copyResize(decoded, width: width, height: height)
        : decoded;
    final bytes = _encodeUnderTarget(
      targetImage,
      targetBytes: targetBytes,
      qualityFloor: qualityFloor,
    );
    if (bytes.length > targetBytes) {
      throw AppException(
        'The file could not be reduced to the selected size without losing too much quality.',
      );
    }
    return ProcessedImageResult(
      bytes: bytes,
      extension: '.jpg',
      metadata: {
        'targetBytes': '$targetBytes',
        'finalBytes': '${bytes.length}',
        'dimensions': '${targetImage.width}x${targetImage.height}',
        'sourceName': p.basename(sourcePath),
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

  List<int> _encodeUnderTarget(
    img.Image source, {
    required int targetBytes,
    int initialQuality = 88,
    int qualityFloor = 25,
  }) {
    var width = source.width;
    var height = source.height;
    var quality = initialQuality;
    var current = source;
    var best = img.encodeJpg(current, quality: quality);

    while (best.length > targetBytes &&
        (quality > qualityFloor || width > 320)) {
      if (quality > qualityFloor) {
        quality -= 7;
      } else {
        width = (width * 0.9).round();
        height = (height * 0.9).round();
        current = img.copyResize(source, width: width, height: height);
      }
      best = img.encodeJpg(current, quality: quality.clamp(qualityFloor, 95));
    }
    return best;
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
