import 'package:path/path.dart' as p;

import '../../features/documents/domain/entities/saved_document.dart';
import '../../features/tools/domain/entities/export_request.dart';
import '../enums/export_preset.dart';
import '../enums/processed_file_type.dart';
import '../errors/app_exception.dart';
import 'image_processing_service.dart';
import 'local_file_service.dart';
import 'pdf_service.dart';

class ExportOrchestrationService {
  ExportOrchestrationService({
    required ImageProcessingService imageProcessingService,
    required PdfService pdfService,
    required LocalFileService localFileService,
  }) : _imageProcessingService = imageProcessingService,
       _pdfService = pdfService,
       _localFileService = localFileService;

  final ImageProcessingService _imageProcessingService;
  final PdfService _pdfService;
  final LocalFileService _localFileService;

  Future<OrchestratedExportResult> exportImage({
    required String sourcePath,
    required ExportPreset preset,
    CropRect? cropRect,
  }) async {
    final result = await _imageProcessingService.processForTarget(
      sourcePath: sourcePath,
      targetBytes: preset.targetBytes ?? 100 * 1024,
      width: preset.defaultWidth,
      height: preset.defaultHeight,
      cropRect: cropRect,
      qualityFloor: preset.qualityFloor,
    );
    final fileName =
        '${_safeName(p.basenameWithoutExtension(sourcePath))}_${preset.name}_${DateTime.now().millisecondsSinceEpoch}${result.extension}';
    final path = await _localFileService.writeBytes(
      bytes: result.bytes,
      fileName: fileName,
      type: ProcessedFileType.compressed,
    );
    return OrchestratedExportResult(
      localPath: path,
      fileSizeBytes: result.bytes.length,
      metadata: result.metadata,
    );
  }

  Future<OrchestratedExportResult> exportPdf({
    required List<SavedDocument> documents,
    required ExportPreset preset,
    required String title,
  }) async {
    if (documents.isEmpty) {
      throw AppException('Select at least one document to export.');
    }
    final bytes = await _pdfService.createPdf(
      imagePaths: documents
          .map((item) => item.localPath)
          .toList(growable: false),
      title: title,
      targetBytes: preset.targetBytes,
    );
    final fileName =
        '${_safeName(title)}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final path = await _localFileService.writeBytes(
      bytes: bytes,
      fileName: fileName,
      type: ProcessedFileType.pdf,
    );
    return OrchestratedExportResult(
      localPath: path,
      fileSizeBytes: bytes.length,
      pageCount: documents.length,
      metadata: {
        'preset': preset.name,
        'title': title,
        'pages': '${documents.length}',
      },
    );
  }

  String _safeName(String input) {
    final sanitized = input
        .trim()
        .replaceAll(RegExp(r'[^a-zA-Z0-9_\- ]'), '')
        .replaceAll(' ', '_');
    return sanitized.isEmpty ? 'formsathi_export' : sanitized;
  }
}

class OrchestratedExportResult {
  const OrchestratedExportResult({
    required this.localPath,
    required this.fileSizeBytes,
    required this.metadata,
    this.width,
    this.height,
    this.pageCount,
  });

  final String localPath;
  final int fileSizeBytes;
  final Map<String, String> metadata;
  final int? width;
  final int? height;
  final int? pageCount;
}
