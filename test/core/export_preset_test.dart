import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/enums/crop_mode.dart';
import 'package:formsathi/core/enums/document_type.dart';
import 'package:formsathi/core/enums/export_preset.dart';

void main() {
  test('signature preset targets 20 KB image export', () {
    const preset = ExportPreset.signatureUnder20kb;

    expect(preset.targetBytes, 20 * 1024);
    expect(preset.outputKind, ExportOutputKind.image);
    expect(preset.cropMode, CropMode.signature);
    expect(preset.supports(DocumentType.signature), isTrue);
  });

  test('certificate preset targets 300 KB PDF export', () {
    const preset = ExportPreset.certificatePdfUnder300kb;

    expect(preset.targetBytes, 300 * 1024);
    expect(preset.outputKind, ExportOutputKind.pdf);
    expect(preset.supports(DocumentType.certificate), isTrue);
  });
}
