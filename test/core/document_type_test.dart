import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/enums/document_side.dart';
import 'package:formsathi/core/enums/document_type.dart';
import 'package:formsathi/core/enums/export_preset.dart';

void main() {
  test('identity document types require front and back sides', () {
    expect(DocumentType.aadhaar.requiresSide, isTrue);
    expect(DocumentType.pan.requiresSide, isTrue);
    expect(
      DocumentType.aadhaar.allowedSides,
      containsAll([DocumentSide.front, DocumentSide.back]),
    );
  });

  test('document types expose expected smart export presets', () {
    expect(
      DocumentType.signature.exportPresets,
      contains(ExportPreset.signatureUnder20kb),
    );
    expect(
      DocumentType.passportPhoto.exportPresets,
      contains(ExportPreset.passportPhotoUnder50kb),
    );
    expect(
      DocumentType.certificate.exportPresets,
      contains(ExportPreset.certificatePdfUnder300kb),
    );
  });

  test('unknown document type names fall back to other', () {
    expect(DocumentType.fromName('missing'), DocumentType.other);
    expect(DocumentType.fromName(null), DocumentType.other);
  });
}
