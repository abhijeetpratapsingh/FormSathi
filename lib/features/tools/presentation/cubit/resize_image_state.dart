import 'package:equatable/equatable.dart';

import '../../../../core/enums/resize_preset.dart';
import '../../domain/entities/processed_file.dart';

class ResizeImageState extends Equatable {
  const ResizeImageState({
    this.sourcePath,
    this.originalBytes,
    this.outputBytes,
    this.outputPath,
    this.preset = ResizePreset.passportSize,
    this.customWidth,
    this.customHeight,
    this.customTargetBytes,
    this.processedFile,
    this.isPicking = false,
    this.isProcessing = false,
    this.errorMessage,
  });

  final String? sourcePath;
  final int? originalBytes;
  final int? outputBytes;
  final String? outputPath;
  final ResizePreset preset;
  final int? customWidth;
  final int? customHeight;
  final int? customTargetBytes;
  final ProcessedFile? processedFile;
  final bool isPicking;
  final bool isProcessing;
  final String? errorMessage;

  bool get hasSource => sourcePath != null;
  bool get hasResult => outputPath != null;

  ResizeImageState copyWith({
    String? sourcePath,
    int? originalBytes,
    int? outputBytes,
    String? outputPath,
    ResizePreset? preset,
    int? customWidth,
    bool clearCustomWidth = false,
    int? customHeight,
    bool clearCustomHeight = false,
    int? customTargetBytes,
    bool clearCustomTargetBytes = false,
    ProcessedFile? processedFile,
    bool? isPicking,
    bool? isProcessing,
    String? errorMessage,
    bool clearResult = false,
    bool clearSource = false,
  }) {
    return ResizeImageState(
      sourcePath: clearSource ? null : (sourcePath ?? this.sourcePath),
      originalBytes: originalBytes ?? this.originalBytes,
      outputBytes: clearResult ? null : (outputBytes ?? this.outputBytes),
      outputPath: clearResult ? null : (outputPath ?? this.outputPath),
      preset: preset ?? this.preset,
      customWidth: clearCustomWidth ? null : (customWidth ?? this.customWidth),
      customHeight: clearCustomHeight
          ? null
          : (customHeight ?? this.customHeight),
      customTargetBytes: clearCustomTargetBytes
          ? null
          : (customTargetBytes ?? this.customTargetBytes),
      processedFile: clearResult ? null : (processedFile ?? this.processedFile),
      isPicking: isPicking ?? this.isPicking,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    sourcePath,
    originalBytes,
    outputBytes,
    outputPath,
    preset,
    customWidth,
    customHeight,
    customTargetBytes,
    processedFile,
    isPicking,
    isProcessing,
    errorMessage,
  ];
}
