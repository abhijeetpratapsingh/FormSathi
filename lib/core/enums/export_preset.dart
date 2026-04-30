import 'crop_mode.dart';
import 'document_type.dart';

enum ExportOutputKind { image, pdf }

enum ExportPreset {
  signatureUnder20kb(
    label: 'Signature under 20 KB',
    outputKind: ExportOutputKind.image,
    targetBytes: 20 * 1024,
    cropMode: CropMode.signature,
    documentTypeNames: ['signature'],
    defaultWidth: 600,
    defaultHeight: 200,
    qualityFloor: 25,
  ),
  passportPhotoUnder50kb(
    label: 'Passport photo under 50 KB',
    outputKind: ExportOutputKind.image,
    targetBytes: 50 * 1024,
    cropMode: CropMode.passportAspect,
    documentTypeNames: ['passportPhoto'],
    defaultWidth: 413,
    defaultHeight: 531,
    qualityFloor: 30,
  ),
  aadhaarPdf(
    label: 'Aadhaar PDF',
    outputKind: ExportOutputKind.pdf,
    cropMode: CropMode.page,
    documentTypeNames: ['aadhaar'],
  ),
  panPdf(
    label: 'PAN PDF',
    outputKind: ExportOutputKind.pdf,
    cropMode: CropMode.page,
    documentTypeNames: ['pan'],
  ),
  marksheetPdfUnder300kb(
    label: 'Marksheet PDF under 300 KB',
    outputKind: ExportOutputKind.pdf,
    targetBytes: 300 * 1024,
    cropMode: CropMode.page,
    documentTypeNames: ['marksheet'],
  ),
  certificatePdfUnder300kb(
    label: 'Certificate PDF under 300 KB',
    outputKind: ExportOutputKind.pdf,
    targetBytes: 300 * 1024,
    cropMode: CropMode.page,
    documentTypeNames: ['certificate'],
  );

  const ExportPreset({
    required this.label,
    required this.outputKind,
    required this.cropMode,
    required this.documentTypeNames,
    this.targetBytes,
    this.defaultWidth,
    this.defaultHeight,
    this.qualityFloor = 30,
  });

  final String label;
  final ExportOutputKind outputKind;
  final int? targetBytes;
  final CropMode cropMode;
  final List<String> documentTypeNames;
  final int? defaultWidth;
  final int? defaultHeight;
  final int qualityFloor;

  bool supports(DocumentType type) => documentTypeNames.contains(type.name);

  static ExportPreset? fromName(String? name) {
    for (final preset in ExportPreset.values) {
      if (preset.name == name) return preset;
    }
    return null;
  }
}
