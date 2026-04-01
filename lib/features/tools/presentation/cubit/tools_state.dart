import 'package:equatable/equatable.dart';

import '../../domain/entities/processed_file.dart';

class ToolsState extends Equatable {
  const ToolsState({
    this.isLoading = false,
    this.recentFiles = const <ProcessedFile>[],
    this.errorMessage,
  });

  final bool isLoading;
  final List<ProcessedFile> recentFiles;
  final String? errorMessage;

  ToolsState copyWith({
    bool? isLoading,
    List<ProcessedFile>? recentFiles,
    String? errorMessage,
  }) {
    return ToolsState(
      isLoading: isLoading ?? this.isLoading,
      recentFiles: recentFiles ?? this.recentFiles,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, recentFiles, errorMessage];
}
