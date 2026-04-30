import '../entities/app_lock_credential.dart';
import '../entities/privacy_settings.dart';
import '../entities/wipe_result.dart';

abstract class SettingsRepository {
  Future<PrivacySettings> getPrivacySettings();
  Future<void> savePrivacySettings(PrivacySettings settings);
  Future<AppLockCredential?> getAppLockCredential();
  Future<void> saveAppLockCredential(AppLockCredential credential);
  Future<void> deleteAppLockCredential();
  Future<WipeResult> wipeLocalData();
}
