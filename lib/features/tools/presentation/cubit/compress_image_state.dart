import 'package:equatable/equatable.dart';

import '../../../../core/enums/image_quality_option.dart';
import '../../domain/entities/processed_file.dart';

class CompressImageState extends Equatable {
  const CompressImageState({
    this.sourcePath,
    this.originalBytes,
    this.outputBytes,
    this.outputPath,
    this.quality = ImageQualityOption.medium,
    this.customTargetBytes,
    this.processedFile,
    this.isPicking = false,
    this.isCompressing = false,
    this.errorMessage,
  });

  final String? sourcePath;
  final int? originalBytes;
  final int? outputBytes;
  final String? outputPath;
  final ImageQualityOption quality;
  final int? customTargetBytes;
  final ProcessedFile? processedFile;
  final bool isPicking;
  final bool isCompressing;
  final String? errorMessage;

  bool get hasSource => sourcePath != null;
  bool get hasResult => outputPath != null;

  CompressImageState copyWith({
    String? sourcePath,
    int? originalBytes,
    int? outputBytes,
    String? outputPath,
    ImageQualityOption? quality,
    int? customTargetBytes,
    bool clearCustomTargetBytes = false,
    ProcessedFile? processedFile,
    bool? isPicking,
    bool? isCompressing,
    String? errorMessage,
    bool clearResult = false,
    bool clearSource = false,
  }) {
    return CompressImageState(
      sourcePath: clearSource ? null : (sourcePath ?? this.sourcePath),
      originalBytes: originalBytes ?? this.originalBytes,
      outputBytes: clearResult ? null : (outputBytes ?? this.outputBytes),
      outputPath: clearResult ? null : (outputPath ?? this.outputPath),
      quality: quality ?? this.quality,
      customTargetBytes: clearCustomTargetBytes
          ? null
          : (customTargetBytes ?? this.customTargetBytes),
      processedFile: clearResult ? null : (processedFile ?? this.processedFile),
      isPicking: isPicking ?? this.isPicking,
      isCompressing: isCompressing ?? this.isCompressing,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    sourcePath,
    originalBytes,
    outputBytes,
    outputPath,
    quality,
    customTargetBytes,
    processedFile,
    isPicking,
    isCompressing,
    errorMessage,
  ];
}
