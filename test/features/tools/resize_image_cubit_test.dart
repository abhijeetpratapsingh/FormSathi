import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/enums/processed_file_type.dart';
import 'package:formsathi/core/enums/resize_preset.dart';
import 'package:formsathi/core/services/local_file_service.dart';
import 'package:formsathi/core/services/permission_service.dart';
import 'package:formsathi/features/tools/domain/usecases/resize_image_usecase.dart';
import 'package:formsathi/features/tools/presentation/cubit/resize_image_cubit.dart';

void main() {
  test('custom dimensions switch to custom preset', () {
    final cubit = ResizeImageCubit(
      resizeImageUseCase: FakeResizeImageUseCase(),
      localFileService: FakeLocalFileService(),
      permissionService: PermissionService(),
    );
    addTearDown(cubit.close);

    cubit.setCustomDimensions(width: 600, height: 200);
    cubit.setCustomTargetKb(50);

    expect(cubit.state.preset, ResizePreset.custom);
    expect(cubit.state.customWidth, 600);
    expect(cubit.state.customHeight, 200);
    expect(cubit.state.customTargetBytes, 50 * 1024);
  });

  test('custom preset requires width and height before processing', () async {
    final cubit = ResizeImageCubit(
      resizeImageUseCase: FakeResizeImageUseCase(),
      localFileService: FakeLocalFileService(),
      permissionService: PermissionService(),
    );
    addTearDown(cubit.close);

    cubit.emit(cubit.state.copyWith(sourcePath: '/tmp/source.jpg'));
    cubit.setPreset(ResizePreset.custom);
    await cubit.processImage();

    expect(cubit.state.errorMessage, 'Enter width and height.');
  });
}

class FakeResizeImageUseCase implements ResizeImageUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLocalFileService implements LocalFileService {
  @override
  Future<int> fileSize(String path) async => 0;

  @override
  Future<FileMetadata> metadata(String path) async => const FileMetadata(
    fileSizeBytes: 0,
    originalFileName: 'x.jpg',
    mimeType: 'image/jpeg',
  );

  @override
  Future<void> deleteFile(String path) async {}

  @override
  Future<String> saveDocumentCopy({
    required String sourcePath,
    required String fileName,
  }) async => sourcePath;

  @override
  Future<String> saveProcessedCopy({
    required String sourcePath,
    required String fileName,
    required ProcessedFileType type,
  }) async => sourcePath;

  @override
  Future<bool> tryDeleteFile(String path) async => true;

  @override
  Future<String> writeBytes({
    required List<int> bytes,
    required String fileName,
    required ProcessedFileType type,
  }) async => '/tmp/$fileName';
}
