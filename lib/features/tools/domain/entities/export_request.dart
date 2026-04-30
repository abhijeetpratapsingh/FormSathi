import 'package:equatable/equatable.dart';

import '../../../../core/enums/export_preset.dart';

class CropRect extends Equatable {
  const CropRect({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final int left;
  final int top;
  final int width;
  final int height;

  bool get isValid => left >= 0 && top >= 0 && width > 0 && height > 0;

  @override
  List<Object?> get props => [left, top, width, height];
}

enum ExportSourceMode { savedDocument, standaloneTool }

class ExportRequest extends Equatable {
  const ExportRequest({
    required this.id,
    required this.sourceMode,
    this.sourceDocumentIds = const [],
    this.sourcePaths = const [],
    this.preset,
    this.customWidth,
    this.customHeight,
    this.customTargetBytes,
    this.cropRect,
    required this.requestedAt,
  });

  final String id;
  final ExportSourceMode sourceMode;
  final List<String> sourceDocumentIds;
  final List<String> sourcePaths;
  final ExportPreset? preset;
  final int? customWidth;
  final int? customHeight;
  final int? customTargetBytes;
  final CropRect? cropRect;
  final DateTime requestedAt;

  bool get hasSources => sourceDocumentIds.isNotEmpty || sourcePaths.isNotEmpty;
  bool get hasValidDimensions =>
      (customWidth == null && customHeight == null) ||
      ((customWidth ?? 0) > 0 && (customHeight ?? 0) > 0);

  @override
  List<Object?> get props => [
    id,
    sourceMode,
    sourceDocumentIds,
    sourcePaths,
    preset,
    customWidth,
    customHeight,
    customTargetBytes,
    cropRect,
    requestedAt,
  ];
}
