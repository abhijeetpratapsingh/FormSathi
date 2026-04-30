import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/processed_file.dart';
import '../../domain/usecases/delete_processed_file_usecase.dart';
import '../../domain/usecases/load_recent_processed_files_usecase.dart';
import 'tools_state.dart';

class ToolsCubit extends Cubit<ToolsState> {
  ToolsCubit(
    this._loadRecentProcessedFilesUseCase,
    this._deleteProcessedFileUseCase,
  ) : super(const ToolsState());

  final LoadRecentProcessedFilesUseCase _loadRecentProcessedFilesUseCase;
  final DeleteProcessedFileUseCase _deleteProcessedFileUseCase;

  Future<void> loadRecentFiles() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final files = (await _loadRecentProcessedFilesUseCase.call())
          .where((file) => file.sourceDocumentId == null)
          .toList(growable: false);
      emit(
        state.copyWith(
          isLoading: false,
          recentFiles: files.take(12).toList(growable: false),
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<void> refresh() => loadRecentFiles();

  Future<void> deleteFile(ProcessedFile file) async {
    try {
      await _deleteProcessedFileUseCase.call(file.id);
      await loadRecentFiles();
    } catch (error) {
      emit(state.copyWith(errorMessage: error.toString()));
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }
}
