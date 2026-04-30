import '../../../../core/services/local_file_service.dart';
import '../../../documents/domain/repositories/documents_repository.dart';
import '../../../my_info/domain/repositories/my_info_repository.dart';
import '../../../tools/domain/repositories/tools_repository.dart';
import '../../domain/entities/app_lock_credential.dart';
import '../../domain/entities/privacy_settings.dart';
import '../../domain/entities/wipe_result.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/privacy_local_data_source.dart';
import '../models/app_lock_credential_model.dart';
import '../models/privacy_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({
    required PrivacyLocalDataSource localDataSource,
    required MyInfoRepository myInfoRepository,
    required DocumentsRepository documentsRepository,
    required ToolsRepository toolsRepository,
    required LocalFileService localFileService,
  }) : _localDataSource = localDataSource,
       _myInfoRepository = myInfoRepository,
       _documentsRepository = documentsRepository,
       _toolsRepository = toolsRepository,
       _localFileService = localFileService;

  final PrivacyLocalDataSource _localDataSource;
  final MyInfoRepository _myInfoRepository;
  final DocumentsRepository _documentsRepository;
  final ToolsRepository _toolsRepository;
  final LocalFileService _localFileService;

  @override
  Future<void> deleteAppLockCredential() => _localDataSource.deleteCredential();

  @override
  Future<AppLockCredential?> getAppLockCredential() async =>
      _localDataSource.getCredential()?.toEntity();

  @override
  Future<PrivacySettings> getPrivacySettings() async =>
      _localDataSource.getSettings()?.toEntity() ?? const PrivacySettings();

  @override
  Future<void> saveAppLockCredential(AppLockCredential credential) {
    return _localDataSource.saveCredential(
      AppLockCredentialModel.fromEntity(credential),
    );
  }

  @override
  Future<void> savePrivacySettings(PrivacySettings settings) {
    return _localDataSource.saveSettings(
      PrivacySettingsModel.fromEntity(settings),
    );
  }

  @override
  Future<WipeResult> wipeLocalData() async {
    await _myInfoRepository.clearUserInfo();
    final documents = await _documentsRepository.getDocuments();
    final processed = await _toolsRepository.getProcessedFiles();
    final failedPaths = <String>[];

    for (final document in documents) {
      final deleted = await _localFileService.tryDeleteFile(document.localPath);
      if (!deleted) failedPaths.add(document.localPath);
    }
    for (final file in processed) {
      final deleted = await _localFileService.tryDeleteFile(file.localPath);
      if (!deleted) failedPaths.add(file.localPath);
    }

    await _documentsRepository.clearDocuments();
    await _toolsRepository.clearProcessedFiles();
    await _localDataSource.clear();

    return WipeResult(
      deletedInfo: true,
      deletedDocumentRecords: documents.length,
      deletedDocumentFiles:
          documents.length -
          failedPaths
              .where((path) => documents.any((item) => item.localPath == path))
              .length,
      deletedProcessedRecords: processed.length,
      deletedProcessedFiles:
          processed.length -
          failedPaths
              .where((path) => processed.any((item) => item.localPath == path))
              .length,
      failedPaths: failedPaths,
    );
  }
}
