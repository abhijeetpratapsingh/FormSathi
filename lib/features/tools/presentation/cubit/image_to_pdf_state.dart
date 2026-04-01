import 'package:equatable/equatable.dart';

import '../../domain/entities/processed_file.dart';

class ImageToPdfState extends Equatable {
  const ImageToPdfState({
    this.imagePaths = const <String>[],
    this.pdfTitle = 'form_sathi_document',
    this.outputPath,
    this.outputBytes,
    this.processedFile,
    this.isPicking = false,
    this.isGenerating = false,
    this.errorMessage,
  });

  final List<String> imagePaths;
  final String pdfTitle;
  final String? outputPath;
  final int? outputBytes;
  final ProcessedFile? processedFile;
  final bool isPicking;
  final bool isGenerating;
  final String? errorMessage;

  bool get hasSelection => imagePaths.isNotEmpty;
  bool get hasResult => outputPath != null;

  ImageToPdfState copyWith({
    List<String>? imagePaths,
    String? pdfTitle,
    String? outputPath,
    int? outputBytes,
    ProcessedFile? processedFile,
    bool? isPicking,
    bool? isGenerating,
    String? errorMessage,
    bool clearResult = false,
  }) {
    return ImageToPdfState(
      imagePaths: imagePaths ?? this.imagePaths,
      pdfTitle: pdfTitle ?? this.pdfTitle,
      outputPath: clearResult ? null : (outputPath ?? this.outputPath),
      outputBytes: clearResult ? null : (outputBytes ?? this.outputBytes),
      processedFile: clearResult ? null : (processedFile ?? this.processedFile),
      isPicking: isPicking ?? this.isPicking,
      isGenerating: isGenerating ?? this.isGenerating,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        imagePaths,
        pdfTitle,
        outputPath,
        outputBytes,
        processedFile,
        isPicking,
        isGenerating,
        errorMessage,
      ];
}
