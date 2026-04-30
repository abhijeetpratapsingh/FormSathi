import 'package:formsathi/features/settings/domain/entities/app_lock_credential.dart';
import 'package:formsathi/features/settings/domain/entities/privacy_settings.dart';
import 'package:formsathi/features/settings/domain/entities/wipe_result.dart';
import 'package:formsathi/features/settings/domain/repositories/settings_repository.dart';

class FakeSettingsRepository implements SettingsRepository {
  PrivacySettings settings = const PrivacySettings();
  AppLockCredential? credential;
  WipeResult wipeResult = const WipeResult(
    deletedInfo: true,
    deletedDocumentRecords: 0,
    deletedDocumentFiles: 0,
    deletedProcessedRecords: 0,
    deletedProcessedFiles: 0,
  );

  @override
  Future<void> deleteAppLockCredential() async {
    credential = null;
  }

  @override
  Future<AppLockCredential?> getAppLockCredential() async => credential;

  @override
  Future<PrivacySettings> getPrivacySettings() async => settings;

  @override
  Future<void> saveAppLockCredential(AppLockCredential credential) async {
    this.credential = credential;
  }

  @override
  Future<void> savePrivacySettings(PrivacySettings settings) async {
    this.settings = settings;
  }

  @override
  Future<WipeResult> wipeLocalData() async {
    settings = const PrivacySettings();
    credential = null;
    return wipeResult;
  }
}
