import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../errors/app_exception.dart';

class PdfService {
  Future<List<int>> createPdf({
    required List<String> imagePaths,
    required String title,
  }) async {
    if (imagePaths.isEmpty) {
      throw AppException('Select at least one image to create a PDF.');
    }

    final document = pw.Document(title: title);
    for (final path in imagePaths) {
      final file = File(path);
      if (!await file.exists()) {
        continue;
      }
      final bytes = await file.readAsBytes();
      final image = pw.MemoryImage(bytes);
      document.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );
    }

    final createdBytes = await document.save();
    if (createdBytes.isEmpty) {
      throw AppException('PDF generation failed. Please try again.');
    }
    return createdBytes;
  }

  String normalizeFileName(String input) {
    final sanitized = input.trim().replaceAll(RegExp(r'[^a-zA-Z0-9_\- ]'), '').replaceAll(' ', '_');
    return sanitized.isEmpty ? 'form_sathi_document' : sanitized;
  }

  String suggestedPdfName(List<String> imagePaths) {
    if (imagePaths.isEmpty) return 'form_sathi_document';
    return normalizeFileName(p.basenameWithoutExtension(imagePaths.first));
  }
}
