import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../../core/enums/processed_file_type.dart';
import '../../../../core/services/local_file_service.dart';
import '../../../../core/services/pdf_service.dart';
import '../entities/processed_file.dart';
import '../repositories/tools_repository.dart';

class CreatePdfUseCase {
  const CreatePdfUseCase({
    required PdfService pdfService,
    required LocalFileService localFileService,
    required ToolsRepository repository,
    Uuid? uuid,
  })  : _pdfService = pdfService,
        _localFileService = localFileService,
        _repository = repository,
        _uuid = uuid ?? const Uuid();

  final PdfService _pdfService;
  final LocalFileService _localFileService;
  final ToolsRepository _repository;
  final Uuid _uuid;

  Future<ProcessedFile> call({
    required List<String> imagePaths,
    required String title,
  }) async {
    final result = await _pdfService.createPdf(
      imagePaths: imagePaths,
      title: title,
    );
    final baseName = _sanitizeFileName(title.isEmpty ? _pdfService.suggestedPdfName(imagePaths) : title);
    final fileName = '${baseName}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final path = await _localFileService.writeBytes(
      bytes: result,
      fileName: fileName,
      type: ProcessedFileType.pdf,
    );
    final processed = ProcessedFile(
      id: _uuid.v4(),
      type: ProcessedFileType.pdf,
      localPath: path,
      createdAt: DateTime.now(),
      metadata: {
        'title': title,
        'pages': imagePaths.length.toString(),
        'sourceImages': imagePaths.map(p.basename).join(', '),
      },
    );
    await _repository.saveProcessedFile(processed);
    return processed;
  }

  String _sanitizeFileName(String input) {
    final sanitized = input.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_\- ]'), '').replaceAll(' ', '_');
    return sanitized.isEmpty ? 'form_sathi_document' : sanitized;
  }
}
