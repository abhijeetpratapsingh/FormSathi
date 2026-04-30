import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/export_preset.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../documents/domain/entities/saved_document.dart';
import '../../domain/usecases/export_saved_document_usecase.dart';
import 'smart_export_state.dart';

class SmartExportCubit extends Cubit<SmartExportState> {
  SmartExportCubit({required ExportSavedDocumentUseCase exportUseCase})
    : _exportUseCase = exportUseCase,
      super(const SmartExportState());

  final ExportSavedDocumentUseCase _exportUseCase;

  Future<void> exportDocument({
    required SavedDocument document,
    required ExportPreset preset,
    List<SavedDocument> relatedDocuments = const [],
  }) async {
    emit(
      state.copyWith(
        isProcessing: true,
        activePreset: preset,
        clearResult: true,
        clearErrorMessage: true,
      ),
    );
    try {
      final result = await _exportUseCase(
        document: document,
        preset: preset,
        relatedDocuments: relatedDocuments,
      );
      emit(
        state.copyWith(
          isProcessing: false,
          clearActivePreset: true,
          result: result,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isProcessing: false,
          clearActivePreset: true,
          errorMessage: _resolveError(error),
        ),
      );
    }
  }

  void clearResult() {
    emit(state.copyWith(clearResult: true, clearErrorMessage: true));
  }

  String _resolveError(Object error) {
    return AppException.userSafeMessage(error);
  }
}
