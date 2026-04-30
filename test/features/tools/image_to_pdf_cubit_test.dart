import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/enums/processed_file_type.dart';
import 'package:formsathi/core/services/local_file_service.dart';
import 'package:formsathi/core/services/pdf_service.dart';
import 'package:formsathi/core/services/permission_service.dart';
import 'package:formsathi/features/tools/domain/usecases/create_pdf_usecase.dart';
import 'package:formsathi/features/tools/presentation/cubit/image_to_pdf_cubit.dart';
import 'package:formsathi/features/tools/presentation/cubit/image_to_pdf_state.dart';

void main() {
  test('target KB can be set and cleared', () {
    final cubit = ImageToPdfCubit(
      createPdfUseCase: FakeCreatePdfUseCase(),
      localFileService: FakeLocalFileService(),
      permissionService: PermissionService(),
      pdfService: PdfService(),
    );
    addTearDown(cubit.close);

    cubit.setTargetKb(300);
    expect(cubit.state.targetBytes, 300 * 1024);

    cubit.setTargetKb(null);
    expect(cubit.state.targetBytes, isNull);
  });

  test('state carries output size warning', () {
    final state = const ImageToPdfState().copyWith(
      outputWarning: 'Output is above the selected target.',
    );
    expect(state.outputWarning, 'Output is above the selected target.');
  });
}

class FakeCreatePdfUseCase implements CreatePdfUseCase {
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
