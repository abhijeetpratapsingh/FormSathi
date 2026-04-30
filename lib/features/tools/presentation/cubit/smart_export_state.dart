import 'package:equatable/equatable.dart';

import '../../../../core/enums/export_preset.dart';
import '../../domain/entities/processed_file.dart';

class SmartExportState extends Equatable {
  const SmartExportState({
    this.isProcessing = false,
    this.activePreset,
    this.result,
    this.errorMessage,
  });

  final bool isProcessing;
  final ExportPreset? activePreset;
  final ProcessedFile? result;
  final String? errorMessage;

  SmartExportState copyWith({
    bool? isProcessing,
    ExportPreset? activePreset,
    bool clearActivePreset = false,
    ProcessedFile? result,
    bool clearResult = false,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return SmartExportState(
      isProcessing: isProcessing ?? this.isProcessing,
      activePreset: clearActivePreset
          ? null
          : (activePreset ?? this.activePreset),
      result: clearResult ? null : (result ?? this.result),
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isProcessing, activePreset, result, errorMessage];
}
