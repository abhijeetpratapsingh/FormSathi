import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/local_file_service.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../domain/usecases/create_pdf_usecase.dart';
import 'image_to_pdf_state.dart';

class ImageToPdfCubit extends Cubit<ImageToPdfState> {
  ImageToPdfCubit({
    required CreatePdfUseCase createPdfUseCase,
    required LocalFileService localFileService,
    required PermissionService permissionService,
    required PdfService pdfService,
    ImagePicker? imagePicker,
  }) : _createPdfUseCase = createPdfUseCase,
       _localFileService = localFileService,
       _permissionService = permissionService,
       _pdfService = pdfService,
       _imagePicker = imagePicker ?? ImagePicker(),
       super(const ImageToPdfState());

  final CreatePdfUseCase _createPdfUseCase;
  final LocalFileService _localFileService;
  final PermissionService _permissionService;
  final PdfService _pdfService;
  final ImagePicker _imagePicker;

  void setTitle(String title) {
    emit(state.copyWith(pdfTitle: title, errorMessage: null));
  }

  void setTargetKb(int? kb) {
    emit(
      state.copyWith(
        targetBytes: kb == null ? null : kb * 1024,
        clearTargetBytes: kb == null,
        clearOutputWarning: true,
        errorMessage: null,
      ),
    );
  }

  Future<void> addImagesFromGallery() async {
    emit(state.copyWith(isPicking: true, errorMessage: null));
    try {
      final picked = await _imagePicker.pickMultiImage(imageQuality: 100);
      _ingestPaths(picked.map((file) => file.path).toList(growable: false));
      emit(state.copyWith(isPicking: false, errorMessage: null));
    } catch (error) {
      emit(state.copyWith(isPicking: false, errorMessage: error.toString()));
    }
  }

  Future<void> addImageFromCamera() async {
    emit(state.copyWith(isPicking: true, errorMessage: null));
    try {
      await _permissionService.ensureCameraPermission();
      final picked = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );
      if (picked != null) {
        _ingestPaths([picked.path]);
      }
      emit(state.copyWith(isPicking: false, errorMessage: null));
    } catch (error) {
      emit(state.copyWith(isPicking: false, errorMessage: error.toString()));
    }
  }

  void removeImageAt(int index) {
    final updated = state.imagePaths.toList()..removeAt(index);
    emit(
      state.copyWith(
        imagePaths: updated,
        clearResult: true,
        pdfTitle: updated.isEmpty ? 'form_sathi_document' : state.pdfTitle,
      ),
    );
  }

  void reorderImages(int oldIndex, int newIndex) {
    final updated = state.imagePaths.toList();
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);
    emit(state.copyWith(imagePaths: updated, clearResult: true));
  }

  Future<void> generatePdf() async {
    if (state.imagePaths.isEmpty) {
      emit(state.copyWith(errorMessage: 'Add at least one image.'));
      return;
    }
    emit(state.copyWith(isGenerating: true, errorMessage: null));
    try {
      final processed = await _createPdfUseCase(
        imagePaths: state.imagePaths,
        title: state.pdfTitle.isEmpty
            ? _pdfService.suggestedPdfName(state.imagePaths)
            : state.pdfTitle,
        targetBytes: state.targetBytes,
      );
      final outputBytes = await _localFileService.fileSize(processed.localPath);
      final warning =
          state.targetBytes != null && outputBytes > state.targetBytes!
          ? 'Output is above the selected target.'
          : null;
      emit(
        state.copyWith(
          isGenerating: false,
          outputPath: processed.localPath,
          outputBytes: outputBytes,
          outputWarning: warning,
          processedFile: processed,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isGenerating: false, errorMessage: _message(error)));
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }

  void _ingestPaths(List<String> paths) {
    final merged = <String>{
      ...state.imagePaths,
      ...paths,
    }.toList(growable: false);
    final title =
        state.pdfTitle == 'form_sathi_document' || state.pdfTitle.isEmpty
        ? _pdfService.suggestedPdfName(merged)
        : state.pdfTitle;
    emit(
      state.copyWith(imagePaths: merged, pdfTitle: title, clearResult: true),
    );
  }

  String _message(Object error) {
    if (error is AppException) {
      return error.message;
    }
    return error.toString();
  }
}
