import 'document_side.dart';
import 'export_preset.dart';

enum DocumentType {
  signature('Signature'),
  passportPhoto('Passport Photo'),
  aadhaar('Aadhaar'),
  pan('PAN'),
  marksheet('Marksheet'),
  certificate('Certificate'),
  resume('Resume'),
  other('Other');

  const DocumentType(this.label);

  final String label;

  bool get supportsCamera => this != resume;
  bool get supportsGallery => this != resume;
  bool get supportsFileImport => this == resume || this == other;

  bool get requiresSide => this == aadhaar || this == pan;

  String get defaultTitle => label;

  List<DocumentSide> get allowedSides {
    if (!requiresSide) return const [DocumentSide.none];
    return const [DocumentSide.front, DocumentSide.back];
  }

  List<ExportPreset> get exportPresets => switch (this) {
    DocumentType.signature => const [ExportPreset.signatureUnder20kb],
    DocumentType.passportPhoto => const [ExportPreset.passportPhotoUnder50kb],
    DocumentType.aadhaar => const [ExportPreset.aadhaarPdf],
    DocumentType.pan => const [ExportPreset.panPdf],
    DocumentType.marksheet => const [ExportPreset.marksheetPdfUnder300kb],
    DocumentType.certificate => const [ExportPreset.certificatePdfUnder300kb],
    DocumentType.resume => const [],
    DocumentType.other => const [],
  };

  static DocumentType fromName(String? name) {
    return DocumentType.values.firstWhere(
      (item) => item.name == name,
      orElse: () => DocumentType.other,
    );
  }
}
