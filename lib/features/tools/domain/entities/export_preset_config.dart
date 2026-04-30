import 'package:equatable/equatable.dart';

import '../../../../core/enums/crop_mode.dart';
import '../../../../core/enums/document_type.dart';
import '../../../../core/enums/export_preset.dart';

class ExportPresetConfig extends Equatable {
  const ExportPresetConfig({
    required this.preset,
    required this.label,
    required this.outputKind,
    required this.documentTypes,
    required this.cropMode,
    this.targetBytes,
    this.defaultWidth,
    this.defaultHeight,
    this.qualityFloor = 30,
  });

  final ExportPreset preset;
  final String label;
  final ExportOutputKind outputKind;
  final List<DocumentType> documentTypes;
  final CropMode cropMode;
  final int? targetBytes;
  final int? defaultWidth;
  final int? defaultHeight;
  final int qualityFloor;

  factory ExportPresetConfig.fromPreset(ExportPreset preset) {
    return ExportPresetConfig(
      preset: preset,
      label: preset.label,
      outputKind: preset.outputKind,
      documentTypes: DocumentType.values
          .where(preset.supports)
          .toList(growable: false),
      cropMode: preset.cropMode,
      targetBytes: preset.targetBytes,
      defaultWidth: preset.defaultWidth,
      defaultHeight: preset.defaultHeight,
      qualityFloor: preset.qualityFloor,
    );
  }

  @override
  List<Object?> get props => [
    preset,
    label,
    outputKind,
    documentTypes,
    cropMode,
    targetBytes,
    defaultWidth,
    defaultHeight,
    qualityFloor,
  ];
}
