import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/enums/image_quality_option.dart';
import 'package:formsathi/core/enums/processed_file_type.dart';
import 'package:formsathi/core/services/local_file_service.dart';
import 'package:formsathi/core/services/permission_service.dart';
import 'package:formsathi/features/tools/domain/usecases/compress_image_usecase.dart';
import 'package:formsathi/features/tools/presentation/cubit/compress_image_cubit.dart';

void main() {
  test('target-size presets update compression target bytes', () {
    final cubit = CompressImageCubit(
      compressImageUseCase: FakeCompressImageUseCase(),
      localFileService: FakeLocalFileService(),
      permissionService: PermissionService(),
    );
    addTearDown(cubit.close);

    cubit.setQuality(ImageQualityOption.under50kb);
    expect(cubit.state.quality.targetBytes, 50 * 1024);

    cubit.setCustomTargetKb(20);
    expect(cubit.state.customTargetBytes, 20 * 1024);
  });
}

class FakeCompressImageUseCase implements CompressImageUseCase {
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
