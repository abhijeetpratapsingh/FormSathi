import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/enums/image_quality_option.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/services/local_file_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../domain/usecases/compress_image_usecase.dart';
import 'compress_image_state.dart';

class CompressImageCubit extends Cubit<CompressImageState> {
  CompressImageCubit({
    required CompressImageUseCase compressImageUseCase,
    required LocalFileService localFileService,
    required PermissionService permissionService,
    ImagePicker? imagePicker,
  }) : _compressImageUseCase = compressImageUseCase,
       _localFileService = localFileService,
       _permissionService = permissionService,
       _imagePicker = imagePicker ?? ImagePicker(),
       super(const CompressImageState());

  final CompressImageUseCase _compressImageUseCase;
  final LocalFileService _localFileService;
  final PermissionService _permissionService;
  final ImagePicker _imagePicker;

  void setQuality(ImageQualityOption quality) {
    emit(
      state.copyWith(
        quality: quality,
        clearCustomTargetBytes: quality.targetBytes != null,
        errorMessage: null,
      ),
    );
  }

  void setCustomTargetKb(int? kb) {
    emit(
      state.copyWith(
        customTargetBytes: kb == null ? null : kb * 1024,
        clearCustomTargetBytes: kb == null,
        errorMessage: null,
      ),
    );
  }

  Future<void> pickFromGallery() => _pickImage(ImageSource.gallery);

  Future<void> pickFromCamera() => _pickImage(ImageSource.camera);

  Future<void> _pickImage(ImageSource source) async {
    emit(state.copyWith(isPicking: true, errorMessage: null));
    try {
      if (source == ImageSource.camera) {
        await _permissionService.ensureCameraPermission();
      }
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 100,
      );
      if (picked == null) {
        emit(state.copyWith(isPicking: false));
        return;
      }
      final sourcePath = picked.path;
      final originalBytes = await _localFileService.fileSize(sourcePath);
      emit(
        state.copyWith(
          isPicking: false,
          sourcePath: sourcePath,
          originalBytes: originalBytes,
          clearResult: true,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isPicking: false, errorMessage: error.toString()));
    }
  }

  Future<void> compressImage() async {
    final sourcePath = state.sourcePath;
    if (sourcePath == null) {
      emit(state.copyWith(errorMessage: 'Select an image first.'));
      return;
    }
    emit(state.copyWith(isCompressing: true, errorMessage: null));
    try {
      final processed = await _compressImageUseCase(
        sourcePath: sourcePath,
        quality: state.quality,
        targetBytes: state.customTargetBytes,
      );
      final outputBytes = await _localFileService.fileSize(processed.localPath);
      emit(
        state.copyWith(
          isCompressing: false,
          outputPath: processed.localPath,
          outputBytes: outputBytes,
          processedFile: processed,
          errorMessage: null,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isCompressing: false, errorMessage: _message(error)));
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      emit(state.copyWith(errorMessage: null));
    }
  }

  String _message(Object error) {
    if (error is AppException) {
      return error.message;
    }
    return error.toString();
  }
}
